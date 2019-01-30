import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import Process 1.0
import Gsettings 1.0
import QmlFile 1.0
import QtQuick.Dialogs 1.2

Item {
    id: root

    QmlFile {
        id: bridgesFile

        name: ".config/tractor/Bridges"
        homeDir: true
    }

    property int initial: {
        dconf.settingNew()
        useBridgesDelegate.checked = dconf.getBoolValue("use-bridges")
        bridgesText.text = bridgesFile.readAll()
        return 0
    }

    property string bridgesPath: ""

    Qgsettings {
        id: dconf

        schema: "org.tractor"
    }

    SwitchDelegate {
        id: useBridgesDelegate

        Material.accent: "#F50057"
        anchors.top: root.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        text: "Use bridges"
        font.bold: true

        ToolTip {
            text: qsTr("Bridges help you to bypass tor sensorship")
            visible: parent.hovered
            delay: 2000
            timeout: 3000
            font.pointSize: 10
            font.weight: Font.Light
        }

        onClicked: {
            if (checked)
                dconf.setBoolValue("use-bridges", true)
            else
                dconf.setBoolValue("use-bridges", false)
        }
    }

    ItemDelegate {
        id: bridgesDelegate

        Material.accent: "#FF5722"
        anchors.top: useBridgesDelegate.bottom
        anchors.left: root.left
        anchors.right: root.right
        height: root.height / 3 * 2


        Text {
            id: bridges

            text: qsTr("Bridges:")
            color: "white"
            font.pointSize: 11
            font.bold: true
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 25
        }

        Button {
            id: saveBtn

            Material.theme: Material.Light
            Material.background: "#FF5722"
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: bridges.verticalCenter
            text: "Save"
            property int charCunt: 0

            onClicked: {
                charCunt = bridgesFile.write(bridgesText.text)
                saveDialog.open()
            }

        }

        ScrollView {
            id: bridgesScroll

            anchors.top: bridges.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: 15
            width: parent.width - 95
            height: parent.height - 80
            clip: true

            TextArea {
                id: bridgesText

                Material.theme: Material.Light
                Material.foreground: "white"
                wrapMode: "WrapAnywhere"
                selectByMouse: true
                font.pointSize: 12
            }
        }

        ToolTip {
            text: qsTr("Example: Bridge obfs4 194.13 . . .")
            visible: parent.hovered
            delay: 2000
            timeout: 3000
            font.pointSize: 10
            font.weight: Font.Light
        }
    }

    Dialog {
        id: saveDialog

        visible: false
        standardButtons: StandardButton.Close
        title: "Saved"

        Text {
            text: saveBtn.charCunt + " charecter saved."
            anchors.centerIn: parent
        }
    }

}
