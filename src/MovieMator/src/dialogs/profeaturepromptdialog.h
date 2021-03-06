/*
 * Copyright (c) 2016-2019 EffectMatrix Inc.
 * Author: vgawen <gdb_1986@163.com>
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
#ifndef PROFEATUREPROMPTDIALOG_H
#define PROFEATUREPROMPTDIALOG_H

#include <QDialog>

namespace Ui {
class ProFeaturePromptDialog;
}

class ProFeaturePromptDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ProFeaturePromptDialog(QWidget *parent = nullptr);
    ~ProFeaturePromptDialog();

private slots:
    void on_laterButton_clicked();

    void on_upgradeNowButton_clicked();

private:
    Ui::ProFeaturePromptDialog *ui;
};

#endif // PROFEATUREPROMPTDIALOG_H
