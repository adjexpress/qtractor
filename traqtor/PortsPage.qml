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

            text: qsTr("Network")
            font.pixelSize: 24
            font.weight: Font.Light
        }
    }

    Column {
        anchors.top: parent.top
        width: parent.width

        C.GroupHeader {
            text: qsTr("Ports")
            C.SLine { anchors.top: parent.top }
        }

        // Http Port
        ItemDelegate {
            id: httpPort

            font: uiParams.fonts.small
            width: parent.width
            text: "HTTP TUNNEL PORT"
            enabled: tractor.status === Tractor.STOPED

            C.SpinBox {
                id: httpBox

                from: 1
                to: 9999

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                editable: true
                value: tractor.settings.httpPort

                onValueModified: { tractor.settings.httpPort = value }
            }

            C.SLine { anchors.bottom: parent.bottom }
        }

        // Socks Port
        ItemDelegate {
            id: socksPort

            font: uiParams.fonts.small
            width: parent.width
            text: "SOCKS PORT"
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

            C.SLine { anchors.bottom: parent.bottom }
        }

        // DNS Port
        ItemDelegate {
            id: dnsPort

            font: uiParams.fonts.small
            width: parent.width
            text: "DNS PORT"
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

            C.SLine { anchors.bottom: parent.bottom }
        }

        C.GroupHeader { text: qsTr("Others") }

        // Set Proxy
        SwitchDelegate {
            id: proxySwitch

            width: parent.width
            text: qsTr("SET PROXY")
            font: uiParams.fonts.small
            checked: tractor.settings.eProxy

            onToggled: { tractor.settings.toggleEProxy() }

            C.SLine { anchors.bottom: parent.bottom }
        }

        // Accept Connection
        SwitchDelegate {
            id: acSwitch

            width: parent.width
            text: "ACCEPT CONNECTION"
            font: uiParams.fonts.small
            enabled: tractor.status === Tractor.STOPED
            checked: tractor.settings.acceptConnection

            onToggled: { tractor.settings.acceptConnection = checked }

            C.SLine { anchors.bottom: parent.bottom }

            ToolTip {
                Material.theme: Material.Light
                text: qsTr("Whether or not allowing external devices <br> to use this network")
                visible: parent.hovered
                delay: 2000
                timeout: 3000
                font.pointSize: 10
                font.weight: Font.Light
            }
        }
    }
}
