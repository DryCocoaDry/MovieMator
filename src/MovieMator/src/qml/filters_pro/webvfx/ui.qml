/*
 * Copyright (c) 2014-2016 Meltytech, LLC
 * Author: Brian Matherly <pez4brian@yahoo.com>
 *
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: wyl <wyl@pylwyl.local>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import QtQuick.Window 2.1
import QtQuick.Controls.Styles 1.4
import MovieMator.Controls 1.0 as MovieMator
import com.moviemator.qml 1.0 as MovieMator

Item {
    id: webvfxRoot
    width: 300
    height: 250
    property string settingsSavePath: settings.savePath

    SystemPalette { id: activePalette; colorGroup: SystemPalette.Active }
    MovieMator.File { id: htmlFile }
    MovieMator.File {
        id: customUiFile
        url: {
            if (!htmlFile.url || !htmlFile.exists())
                return "";
            var uiFile = htmlFile.url.toString();
            return uiFile.substr(0, uiFile.lastIndexOf(".")) + "_ui.qml";
        }
        onUrlChanged: {
            if (exists())
                customUILoader.source = url;
            else
                customUILoader.source = "";
        }
    }

    // This signal is used to workaround context properties not available in
    // the FileDialog onAccepted signal handler on Qt 5.5.
    signal fileSaved(string path)
    onFileSaved: settings.savePath = path

    Component.onCompleted: {
        var resource = filter.get('resource')
        if (resource.substring(0,6) === "plain:") {
            resource = resource.substring(6)
            webvfxCheckBox.checked = false
        } else if (resource) {
            webvfxCheckBox.checked = true
        }
        else {
            webvfxCheckBox.checked = false
        }

        htmlFile.url = resource

        if (htmlFile.exists()) {
            fileLabel.text = htmlFile.fileName
            fileLabelTip.text = htmlFile.url.toString()
            openButton.visible = false
            newButton.visible = false
            editButton.visible = true
            reloadButton.visible = true
            webvfxCheckBox.enabled = false
        } else {
            console.log('htmlFile.url = ' + htmlFile.url)
            fileLabel.text = qsTr("No File Loaded")
            fileLabel.color = 'red'
            fileLabelTip.text = qsTr('No HTML file loaded. Click "Open" or "New" to load a file.')
            filter.set("disable", 1)
        }

        filter.setInAndOut(filter.producerIn, filter.producerOut)
    }

    FileDialog {
        id: fileDialog
        modality: Qt.WindowModal
        selectMultiple: false
        selectFolder: false
        folder: settingsSavePath
        nameFilters: [ "HTML-Files (*.htm *.html)", "All Files (*)" ]
        selectedNameFilter: "HTML-Files (*.htm *.html)"
        onAccepted: {
            htmlFile.url = fileDialog.fileUrl
            webvfxRoot.fileSaved(htmlFile.path)

            if (fileDialog.selectExisting == false) {
                if (!htmlFile.suffix()) {
                    htmlFile.url = htmlFile.url + ".html"
                }
                htmlFile.copyFromFile(":/scripts/new.html")
            }

            fileLabel.text = htmlFile.fileName
            fileLabel.color = activePalette.text
            fileLabelTip.text = htmlFile.url.toString()
            openButton.visible = false
            newButton.visible = false
            webvfxCheckBox.enabled = false
            editButton.visible = true
            reloadButton.visible = true

            var resource = htmlFile.url.toString()
            if (!webvfxCheckBox.checked) {
                resource = "plain:" + resource
            }
            filter.set('resource', resource)
            filter.set("disable", 0)

            if (!selectExisting) {
                editor.edit(htmlFile.url.toString())
                editButton.enabled = false
                reloadButton.enabled = false
            }
        }
        onRejected: {
            openButton.visible = true
            newButton.visible = true
        }
    }

    GridLayout {
        columns: 4
        anchors.fill: parent
        anchors.margins: 8

        // Row 1
        Label {
            text: qsTr('<b>File:</b>')
            color: activePalette.text//'#ffffff'
        }
        Label {
            id: fileLabel
            Layout.columnSpan: 3
            color: activePalette.text//'#ffffff'
            MovieMator.ToolTip { id: fileLabelTip }
        }

        // Row 2
        CheckBox {
            id: webvfxCheckBox
            Layout.columnSpan: 4
          //  text: qsTr('Use WebVfx JavaScript extension')
            MovieMator.ToolTip {
                id: webvfxCheckTip
                text: '<b>' + qsTr('For Advanced Users: ') + '</b>' + '<p>' +
                      qsTr('If you enable this, and you do not use the WebVfx JavaScript extension, your content will not render!')
            }

            style: CheckBoxStyle {
                        label: Text {
                            color: activePalette.text//"white"
                            text: qsTr('Use WebVfx JavaScript extension')
                        }
            }

            onClicked: {
                if (checked) {
                    webvfxDialog.visible = true
                }
            }
            MessageDialog {
                id: webvfxDialog
                visible: false
                modality: Qt.ApplicationModal
                icon: StandardIcon.Question
                title: qsTr("Confirm Selection")
                text: webvfxCheckTip.text + "<p>" + qsTr("Do you still want to use this?")
                standardButtons: StandardButton.Yes | StandardButton.No
                onNo: {
                    webvfxCheckBox.checked = false
                }
            }
        }

        // Row 3
        Button {
            id: openButton
            text: qsTr('Open...')
            onClicked: {
                fileDialog.selectExisting = true
                fileDialog.title = qsTr( "Open HTML File" )
                fileDialog.open()
            }
            MovieMator.ToolTip {
                 text: qsTr("Load an existing HTML file.")
            }
        }
        Button {
            id: newButton
            text: qsTr('New...')
            onClicked: {
                fileDialog.selectExisting = false
                fileDialog.title = qsTr( "Save HTML File" )
                fileDialog.open()
            }
            MovieMator.ToolTip {
                 text: qsTr("Load new HTML file.")
            }
        }
        Item {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            visible: openButton.visible
        }

        // Row 4
        Button {
            id: editButton
            text: qsTr('Edit...')
            visible: false
            onClicked: {
                editor.edit(htmlFile.url.toString())
                editButton.enabled = false
                reloadButton.enabled = false
            }
            MovieMator.HtmlEditor {
                id: editor
                onSaved: {
                    filter.set("_reload", 1);
                }
                onClosed: {
                    editButton.enabled = true
                    reloadButton.enabled = true
                }
            }
        }
        Button {
            id: reloadButton
            text: qsTr('Reload')
            visible: false
            onClicked: {
                filter.set("_reload", 1);
            }
        }
        Item {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            visible: editButton.visible
        }

        Loader {
            id: customUILoader
            Layout.columnSpan: 4
            Layout.fillWidth: true
        }

        Item {
            Layout.fillHeight: true;
            Layout.columnSpan: 4
        }
    }

}
