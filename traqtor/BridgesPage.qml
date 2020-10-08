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

            text: qsTr("Bridges")
            font: uiParams.fonts.headingOne
        }
    }

    // Use Bridges
    SwitchDelegate {
        id: useBridgesDelegate

        Material.accent: "#E91E63"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        text: "USE BRIDGES"
        font: uiParams.fonts.paragraph
        enabled: tractor.status === Tractor.STOPED

        checked: tractor.settings.useBridges

        ToolTip {
            text: qsTr("Bridges help you to bypass tor sensorship")
            visible: parent.hovered
            delay: 2000
            timeout: 3000
            font: uiParams.fonts.small
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

        onToggled: { tractor.settings.useBridges = checked }
    }

    ItemDelegate {
        id: bridgesDelegate

        Material.accent: uiParams.accentColor

        anchors.top: useBridgesDelegate.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        height: root.height / 3 * 2

        Label {
            id: briLabel

            text: qsTr("BRIDGES:")
            color: uiParams.foregroundColor
            font: uiParams.fonts.paragraph
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 25
        }

        Button {
            id: saveBtn

            Material.theme: Material.Dark
            Material.background: "transparent"
            Material.foreground: "#E91E63"

            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: briLabel.verticalCenter

            font.bold: true
            text: "Save"
            enabled: tractor.status === Tractor.STOPED

            onClicked: {
                tractor.settings.bridges = bridgesText.text
                saveDialog.open()
            }
        }

        ScrollView {
            anchors.top: briLabel.bottom
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
                font.family: uiParams.fonts.codeblock.family
                font.pixelSize: 18
                text: tractor.settings.bridges
            }
        }

        ToolTip {
            Material.theme: Material.Light
            text: qsTr("Example: Bridge obfs4 194.13 . . .")
            visible: parent.hovered
            delay: 2000
            timeout: 3000
            font.pointSize: 10
            font.weight: Font.Light
        }

        // bottom splite
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: uiParams.splitColor
        }
    }

    C.Dialog {
        id: saveDialog

        rootItem: root
        title: "Saved"
        width: 200
        height: 150
        standardButtons: Dialog.Close

        Label {
            text: "Bridges save successfully"
            font.weight: Font.Light
            anchors.centerIn: parent
        }
    }
}
