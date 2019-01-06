import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import Process 1.0
import Gsettings 1.0

Item {
    id: root

    property int initial: {
        dconf.settingNew()
        useBridgesDelegate.checked = dconf.getBoolValue("use-bridges")
//        process.setProgram("cat")
//        process.setArguments()
//        process.start("cat /etc/tor/torrc")
        birdgesWhereis.start("tractor bridgesfile")
        return 0
    }

    property string bridgesPath: ""

    Qgsettings {
        id: dconf

        schema: "org.tractor"
    }

    Process {
        id: birdgesWhereis

        onReadyReadStandardOutput: {
            bridgesPath = readAll()
        }

        onFinished: {
            echoToBridgesText.start("cat " + bridgesPath)
        }
    }

    Process {
        id: echoToBridgesText

        onReadyReadStandardOutput: {
            bridgesText.text = readAll()
        }
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
        //text: "Bridges"
        anchors.top: useBridgesDelegate.bottom
        anchors.left: root.left
        anchors.right: root.right
        height: root.height / 2

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

        ScrollView {
            id: bridgesScroll

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 15
            width: parent.width - 95
            height: parent.height - 40
            clip: true

            TextArea {
                id: bridgesText

                wrapMode: "WrapAnywhere"
                selectByMouse: true
                font.pointSize: 12
            }
        }
    }

}
