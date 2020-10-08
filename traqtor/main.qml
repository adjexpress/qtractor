import QtQuick                      2.4
import QtQuick.Controls             2.4
import QtQuick.Controls.Material    2.4
import QtQuick.Window               2.2
import app.tractor                  1.0

import "./components" as C

ApplicationWindow {
    id: window

    property bool minimalMode: width < 1000

    Material.theme: Material.Dark
    Material.background: uiParams.backgroundColor
    Material.accent: uiParams.accentColor

    /*overlay.modal: Rectangle {*/
        /*color: "black"//"#DD000000"*/
        /*Behavior on opacity { NumberAnimation {  duration: 150 } }*/
    /*}*/

    /*overlay.modeless: Rectangle {*/
        /*color: "black"//"#DD000000"*/
        /*Behavior on opacity { NumberAnimation { duration: 150 } }*/
    /*}*/

    visible: true
    title: qsTr("traqtor")

    width: 360
    height: 640
    minimumWidth: 360
    minimumHeight: 640
    maximumWidth: 360
    maximumHeight: 640
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    C.UIParameters { id: uiParams }

    Tractor { id: trc }

    // left bar
    Rectangle {
        id: leftBar
        anchors.left: parent.left

        height: parent.height
        width: window.minimalMode ? 0 : 128
        clip: true

        color: "#222222"

        ListView {
            id: wLv

            anchors.fill: parent

            interactive: false
            currentIndex: view.currentIndex

            model: [
                { name: "General",  icon: "qrc:/icons/general.svg"  },
                { name: "Ports",        icon: "qrc:/icons/port.svg"         },
                { name: "Bridges",  icon: "qrc:/icons/bridge.svg"       }
            ]

            delegate: Button {
                width: wLv.width
                height: 128

                text: modelData.name

                icon.source: modelData.icon
                icon.width: 28
                icon.height: 28
                display: "TextUnderIcon"
                font.weight: Font.Normal
                font.pixelSize: 20

                topInset: 0
                bottomInset: 0

                Material.foreground: wLv.currentIndex === index ? "#222222" : "white"
                Material.background: wLv.currentIndex === index ? "#00C853" : "#222222"
                Material.elevation: 0

                onClicked: { view.currentIndex = index }

                Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: uiParams.splitColor
                }
            }
        }
    }

    // content swipe
    StackView {
        id: view

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: leftBar.right

        clip: true

        initialItem: generalPage

        property int currentIndex: footer.currentIndex

        onCurrentIndexChanged: {
            switch (currentIndex) {
            case 0:
                replace(generalPage)
                break
            case 1:
                replace(protsSettingPage)
                break
            case 2:
                replace(bridgesSettingPage)
                break
            default:
                //NOTHING
            }
        }

        GeneralPage {
            id: generalPage

            clip: true
            visible: false
            tractor: trc
        }

        PortsPage {
            id: protsSettingPage

            clip: true
            visible: false
            tractor: trc
        }

        BridgesPage {
            id: bridgesSettingPage

            clip: true
            visible: false
            tractor: trc
        }
    }

    footer: TabBar {
        id: footer

        Material.theme: Material.Light
        Material.background: "#00FFFFFF"
        Material.foreground: "#FAFAFA"
        Material.accent: "transparent"

        font.weight: Font.Medium
        height: window.minimalMode ? 60 : 0
        position: TabBar.Footer
        currentIndex: 0 //view.currentIndex

        
        // tab buttons
        Repeater {
            anchors.fill: parent

            model: [
                "/icons/general.svg",
                "/icons/port.svg",
                "/icons/bridge.svg"
            ]

            delegate: TabButton {
                icon.source: modelData
                icon.height: 20
                icon.width: 20
                icon.color: footer.currentIndex === index ? uiParams.accentColor : uiParams.foregroundColor

                height: parent.height

                onClicked: { footer.currentIndex = index }

                // indicator
                Rectangle {
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 5
                    height: 5
                    radius: 5
                    color: uiParams.accentColor
                    visible: footer.currentIndex === index
                }
            }
        }
    }
}
