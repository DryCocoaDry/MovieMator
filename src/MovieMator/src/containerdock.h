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
#include<QToolButton>

typedef struct button_info{
    QToolButton *button;
    QIcon normalIcon;
    QIcon activeIcon;
} BUTTON_INFO;

typedef enum{
    TabPosition_Left = 0,
    TabPosition_Bottom,
    TabPosition_Right,
    TabPosition_Top
}TAB_POSITION;

class ContainerDock : public QDockWidget
{
    Q_OBJECT
    Q_PROPERTY(QRect dockPosition READ dockPosition NOTIFY dockPositionChanged)
public:


    ContainerDock(TAB_POSITION tabPosition = TabPosition_Left, QWidget *parent = nullptr);

    void addDock(QDockWidget *dock, QString tabButtonTitle, QString tabButtonTooltip, QIcon tabButtonNormalIcon, QIcon tabButtonAcitveIcon);

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
    TAB_POSITION m_tabPostion;
};

#endif // CONTAINERDOCK_H
