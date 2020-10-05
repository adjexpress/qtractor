import QtQuick                    2.4
import QtQuick.Controls           2.4
import QtQuick.Controls.Material  2.4
import app.tractor                1.0

import "./components" as C

Page {
    id: root

    property var tractor

    header: ToolBar {
        id: pageHeader

        Material.elevation: 0
        Material.background: "transparent"
        height: 58

        Label {
            anchors.left: parent.left
            anchors.margins: 16
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("Ports")
            font.pixelSize: 24
            font.weight: Font.Light
        }
    }

    ItemDelegate {
        id: socksPort

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        font.weight: Font.Light
        height: 50
        text: "Socks Port"
        enabled: tractor.status === Tractor.STOPED

        C.SpinBox {
            id: socksBox

            from: 1
            to: 9999

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            editable: true
            value: tractor.settings.socksPort

            onValueModified: { tractor.settings.socksPort = value }
        }

        // top splite
        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: uiParams.splitColor
        }

        // bottom splite
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: uiParams.splitColor
        }

    }

    ItemDelegate {
        id: dnsPort

        anchors.top: socksPort.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        font.weight: Font.Light
        height: 50
        text: "DNS Port"
        enabled: tractor.status === Tractor.STOPED

        C.SpinBox {
            id: dnsBox

            from: 1
            to: 9999
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            editable: true
            value: tractor.settings.dnsPort

            onValueModified: { tractor.settings.dnsPort = value }
        }

        // bottom splite
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: uiParams.splitColor
        }
    }
}
