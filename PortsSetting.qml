import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Process 1.0
import Gsettings 1.0

Item {
    id: root

    property int initial: {
        dconf.settingNew()
        socksBox.value = dconf.getIntValue("socks-port")
        dnsBox.value = dconf.getIntValue("dns-port")
        return 0
    }

    Qgsettings {
        id: dconf

        schema: "org.tractor"
    }

    ItemDelegate {
        id: socksPort

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        text: "Socks Port"
        font.bold: true

        SpinBox {
            id: socksBox

            Material.accent: "#E91E63"
            from: 1
            to: 9999
            //value: 9052
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            editable: true

            onValueModified: {
                dconf.setIntValue("socks-port", value)
            }
        }
    }

    ItemDelegate {
        id: dnsPort

        anchors.top: socksPort.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        text: "DNS Port"
        font.bold: true

        SpinBox {
            id: dnsBox

            Material.accent: "#E91E63"
            from: 1
            to: 9999
            //value: 9053
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            editable: true

            onValueModified: {
                dconf.setIntValue("dns-port", value)
            }
        }
    }

}
