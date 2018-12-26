import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

Window {
    id: window

    // load fontawasome.
    FontLoader {
            id: fontAweSolid
            source: "/Fonts/Font Awesome 5 Free-Solid-900.otf"
    }

    FontLoader {
        id: ubuntuFontMono
        source: "qrc:/Fonts/UbuntuMono-R.ttf"
    }

    visible: true
    width: 800
    height: 400
    title: qsTr("Qtractor")
    //color: "black"



    Image {
        id: backgroundImage

        source: "qrc:/Images/black.jpg"
        /*anchors.top: parent.top
        anchors.bottom: footer.top
        anchors.right: parent.right
        anchors.left: parent.left*/
        anchors.fill: parent

        fillMode: Image.PreserveAspectCrop
        clip: false
    }

    Rectangle {
        id: footer

        Material.theme: Material.Light
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: "#30FAFAFA"
        height: 50

        ListView {
            id: listView

            focus: true
            anchors.fill: parent
            orientation: ListView.Horizontal
            boundsBehavior: Flickable.StopAtBounds

            delegate: ItemDelegate {
                id: presentation

                height: parent.height
                width: window.width / 3
                icon.source: model.icon
                icon.color: highlighted ? "#FF5722" : "#FAFAFA"

                Text {
                    id: delegateText

                    text: model.title
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: highlighted ? "#FF5722" : "#FAFAFA"
                }

                leftPadding: width / 5

                highlighted: ListView.isCurrentItem
                onClicked: {
                    listView.currentIndex = index
                    if (index == 0) {
                        generalPage.x = 0
                    } else if (index == 1) {
                        generalPage.x = (-1) * window.width
                    } else if (index == 2) {
                        generalPage.x = (-2) * window.width
                    }
                }
            }

            highlight: Component {
                Item {
                    width: presentation.width
                    height: footer.height

                    Rectangle {
                        width: parent.width
                        height: 4.5
                        anchors.top: parent.top
                        color: "#FF5722"
                    }
                }
            }

            highlightMoveDuration: 100

            model: ListModel {
                ListElement { icon: "/Icons/general.png"; title: "General"; source: "qrc:/pages/general.qml" }
                ListElement { icon: "/Icons/port.png"; title: "Ports"; source: "qrc:/pages/portsSetting.qml" }
                ListElement { icon: "/Icons/bridge.png"; title: "Bridges"; source: "qrc:/pages/bridgesSetting.qml" }
            }

            ScrollIndicator.horizontal: ScrollIndicator { }
        }
    }

    General {
        id: generalPage

        x: 0
        width: window.width
        height: window.height - 50
        anchors.top: parent.top

        Behavior on x {
            id: xBehaviorGeneralPage

            NumberAnimation { duration: 100 }
        }
    }

    PortsSetting {
        id: protsSettingPage

        width: window.width
        height: window.height - 50
        anchors.top: parent.top
        anchors.left: generalPage.right
    }

    BridgesSetting {
        id: bridgesSettingPage

        width: window.width
        height: window.height - 50
        anchors.top: parent.top
        anchors.left: protsSettingPage.right
    }


}
