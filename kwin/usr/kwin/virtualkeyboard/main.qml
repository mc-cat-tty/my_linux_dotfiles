/********************************************************************
 KWin - the KDE window manager
 This file is part of the KDE project.

Copyright (C) 2016 Martin Gräßlin <mgraesslin@kde.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.VirtualKeyboard 2.1
import org.kde.kirigami 2.5 as Kirigami

Item {
    id: window
    property real adjustment: 0
    property real adjustmentFactor: 0.0
    InputPanel {
        id: inputPanel
        objectName: "inputPanel"
        width: parent.width - parent.width * parent.adjustmentFactor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
    //NOTE: ToolButton for some reasons breaks the virtual keyboard loading on Plasma Mobile
    Button {
        id: resizeButton
        visible: !Kirigami.Settings.isMobile //don't show on handheld devices
        flat: true
        display: AbstractButton.IconOnly
        icon.name: "transform-scale"
        icon.color: "white"
        down: mouseArea.pressed

        anchors {
            right: inputPanel.right
            top: inputPanel.top
        }

        MouseArea {
            id: mouseArea
            property real startPoint: 0
            anchors.fill: parent
            onPressed: {
                startPoint = mouse.x;
            }
            onPositionChanged: {
                window.adjustment -= (mouse.x - startPoint);
                window.adjustmentFactor = Math.min(Math.max(window.adjustment / window.width, 0.0), 0.66);
                startPoint = mouse.x;
            }
        }
    }
    // this property assignment is done here to not break 5.14.x qtvirtualkeyboard
    // TODO: Move it to InputPanel when we depend on 5.15
    Component.onCompleted: {
        if (inputPanel.hasOwnProperty("desktopPanel")) {
            inputPanel.desktopPanel = true;
        }
    }
}
