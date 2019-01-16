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


#ifndef CONTAINERDOCK_H
#define CONTAINERDOCK_H

#include<QDockWidget>
#include<QList>
#include<QPushButton>

typedef struct button_info{
    QPushButton *button;
    QIcon normalIcon;
    QIcon activeIcon;
} BUTTON_INFO;

class ContainerDock : public QDockWidget
{
    Q_OBJECT
    Q_PROPERTY(QRect dockPosition READ dockPosition NOTIFY dockPositionChanged)
public:
    ContainerDock(QWidget *parent = 0);

    void addDock(QDockWidget *dock, QString tabButtonTitle, QIcon tabButtonNormalIcon, QIcon tabButtonAcitveIcon);

    void showDock(QDockWidget *dock);
    QRect dockPosition();

public slots:
    void onTabButtonClicked();
    void onTabButtonClicked2();

signals:
    void dockPositionChanged();

private:
    QWidget *m_tabBtnWidget;
    QList<BUTTON_INFO> m_buttons;
    QList<QDockWidget *> m_docks;
};

#endif // CONTAINERDOCK_H