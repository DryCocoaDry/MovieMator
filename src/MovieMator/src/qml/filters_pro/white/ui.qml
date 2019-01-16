
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import MovieMator.Controls 1.0
import QtQuick.Controls.Styles 1.1

Item {
    property var defaultParameters: []
    property var neutralParam: ""
    property var tempParam: ""
    property var defaultNeutral: "#7f7f7f"
    property var defaultTemp: 6500.0
    property var tempScale: 15000.0
    width: 300
    height: 250
    property bool bEnableControls: keyFrame.bKeyFrame  ||  (!filter.getKeyFrameNumber())


    function setKeyFrameValue(bKeyFrame)
     {
         var nFrame = keyFrame.getCurrentFrame();
         if(bKeyFrame)
         {

             var whiteValue = colorPicker.value;

             filter.setKeyFrameParaValue(nFrame,neutralParam, whiteValue.toString() )

             whiteValue = tempslider.value;
             filter.setKeyFrameParaValue(nFrame, tempParam, (whiteValue / tempScale).toString())

             filter.combineAllKeyFramePara();
         }
         else
         {
             //Todo, delete the keyframe date of the currentframe
             filter.removeKeyFrameParaValue(nFrame);
             if(!filter.getKeyFrameNumber())
             {
                filter.anim_set(neutralParam,defaultNeutral)
                filter.anim_set(tempParam,(defaultTemp / tempScale).toString())
                
             }

             filter.set(neutralParam, ""+colorPicker.value);
             filter.set(tempParam, tempslider.value/tempScale);

         }
     }

    Component.onCompleted: {
        if (filter.get("mlt_service").indexOf("movit.") == 0 ) {
            // Movit filter
            console.log("white balance: movit");
            neutralParam = "neutral_color"
            tempParam = "color_temperature"
            tempScale = 1;
        } else {
            // Frei0r filter
            console.log("white balance: Frei0r")
            neutralParam = "0"
            tempParam = "1"
            tempScale = 15000.0
        }
        defaultParameters = [neutralParam, tempParam]
        presetItem.parameters = defaultParameters

        if (filter.isNew) {
            // Set default parameter values
            filter.set(neutralParam, defaultNeutral)
            filter.set(tempParam, defaultTemp / tempScale)
            filter.savePreset(defaultParameters)
        }

        var keyFrameCount = filter.getKeyFrameCountOnProject("anim-"+tempParam);
        if(keyFrameCount > 0)
        {
            var index=0
            for(index=0; index<keyFrameCount;index++)
            {
                console.log("1.....")
                var nFrame = filter.getKeyFrameOnProjectOnIndex(index, "anim-"+tempParam);
                var keyValue = filter.getKeyValueOnProjectOnIndex(index, "anim-"+tempParam);


                console.log(nFrame)
                console.log(tempParam)
                console.log(keyValue)
                filter.setKeyFrameParaValue(nFrame, tempParam, keyValue)

                keyValue = filter.getStringKeyValueOnProjectOnIndex(index, "anim-"+neutralParam);
                console.log(nFrame)
                console.log(tempParam)
                console.log(keyValue)
                filter.setKeyFrameParaValue(nFrame,neutralParam, keyValue)

            }
            filter.combineAllKeyFramePara();

            var frame = filter.getKeyFrameOnProjectOnIndex(0, "anim-"+tempParam);

            tempslider.value = parseFloat(filter.getKeyFrameOnProjectOnIndex(0, "anim-"+tempParam) * tempScale)
            tempspinner.value = parseFloat(filter.getKeyValueOnProjectOnIndex(0, "anim-"+neutralParam) * tempScale)
            colorPicker.value = filter.getKeyFrameParaValue(frame, "anim-"+neutralParam)//filter.getKeyValueOnProjectOnIndex(0, "anim-"+neutralParam)
        }
        else
        {
            tempslider.value = filter.getDouble(tempParam) * tempScale
            tempspinner.value = filter.getDouble(tempParam) * tempScale


            colorPicker.value = filter.get(neutralParam)
        }
    }

    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: 8
        
        KeyFrame{
             id: keyFrame
             Layout.columnSpan:3
        // 	currentPosition: filterDock.getCurrentPosition()
             onSetAsKeyFrame:
             {
                setKeyFrameValue(bKeyFrame)
             }

             onLoadKeyFrame:
             {
                 var whiteValue = filter.getKeyFrameParaValue(keyFrameNum, neutralParam);
                 if(whiteValue != -1.0)
                 {
                     console.log("1 colorPick value changed")
                     console.log(whiteValue)
                     console.log(keyFrameNum)
                     colorPicker.value = whiteValue
                 }

                 whiteValue = filter.getKeyFrameParaDoubleValue(keyFrameNum, tempParam);
                 if(whiteValue != -1.0)
                 {
                     tempslider.value = whiteValue * tempScale
                 }

             }
        }

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignRight
            color: bEnableControls?'#ffffff': '#828282'
        }
        Preset {
            id: presetItem
            enabled: bEnableControls
            Layout.columnSpan: 2
            onPresetSelected: {
                tempslider.value = filter.getDouble(tempParam) * tempScale
                console.log('2 colorPicker value changed')
                console.log(filter.get(neutralParam))
                colorPicker.value = filter.get(neutralParam)
            }
        }
        
        // Row 1
        Label {
            text: qsTr('Neutral color')
            Layout.alignment: Qt.AlignRight
            color: bEnableControls?'#ffffff': '#828282'
        }
        ColorPicker {
            id: colorPicker
            enabled: bEnableControls
            property bool isReady: false
            Component.onCompleted: isReady = true
            onValueChanged:
            {
                if (isReady) {
                    if(keyFrame.bKeyFrame)
                    {
                        var nFrame = keyFrame.getCurrentFrame();
                        console.log("keyframe,colorPicker value:")
                        console.log(value)
                        filter.setKeyFrameParaValue(nFrame,neutralParam, value.toString())
                        filter.combineAllKeyFramePara()
                        console.log(filter.getKeyFrameParaValue(nFrame, neutralParam))
                    }
                    else
                    {
                        console.log("non-keyframe,colorPicker value:")
                        console.log(value)
                        filter.set(neutralParam, ""+value)

                    }
                    filter.set("disable", 0);
                  //  setKeyFrameValue(keyFrame.bKeyFrame)
                }
            }
            onPickStarted: {
                filter.set("disable", 1);
            }
        }
        UndoButton {
            enabled: bEnableControls
            onClicked: {
                console.log('3 colorPicker value changed')
                colorPicker.value = defaultNeutral
                setKeyFrameValue(keyFrame.bKeyFrame)
            }
        }

        // Row 2
        Label {
            text: qsTr('Color temperature')
            Layout.alignment: Qt.AlignRight
            color: bEnableControls?'#ffffff': '#828282'
        }
        RowLayout {
            Slider {
                id: tempslider
                enabled: bEnableControls
                Layout.fillWidth: true
                Layout.maximumHeight: tempspinner.height
                style: SliderStyle {
                    groove: Rectangle {
                        rotation: -90
                        height: parent.width
                        x: (parent.width - width) / 2
                        gradient: Gradient {
                            GradientStop { position: 0.000; color: "#FFC500" }
                            GradientStop { position: 0.392; color: "#FFFFFF" }
                            GradientStop { position: 1.000; color: "#DDFFFE" }
                        }
                        radius: 4
                        onWidthChanged: {
                            // Force width (which is really height due to rotation).
                            width = tempslider.height / 2
                        }
                    }
                    handle: Rectangle {
                        color: "lightgray"
                        border.color: "gray"
                        border.width: 2
                        width: height / 2
                        height: tempslider.height
                        radius: 4
                    }
                }
                minimumValue: 1000.0
                maximumValue: 15000.0
                property bool isReady: false
                Component.onCompleted: isReady = true
                onValueChanged: {
                    if (isReady) {
                        if(keyFrame.bKeyFrame)
                        {
                            var nFrame = keyFrame.getCurrentFrame();
                            filter.setKeyFrameParaValue(nFrame,tempParam, (value/tempScale).toString())
                            filter.combineAllKeyFramePara()
                            tempspinner.value = value
                        }
                        else
                        {
                            tempspinner.value = value
                            filter.set(tempParam, value / tempScale)
                        }
                      //  setKeyFrameValue(keyFrame.bKeyFrame)

                        

                    }
                }
            }
            SpinBox {
                id: tempspinner
                enabled: bEnableControls
                Layout.minimumWidth: 100
                minimumValue: 1000.0
                maximumValue: 15000.0
                decimals: 0
                stepSize: 10
                suffix: ' deg'
                onValueChanged: tempslider.value = value
            }
        }
        UndoButton {
            enabled: bEnableControls
            onClicked: 
            {
                tempslider.value = defaultTemp
                setKeyFrameValue(keyFrame.bKeyFrame)
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}