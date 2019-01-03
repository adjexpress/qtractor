import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import Gsettings 1.0

Window {
    id: window

    //property string exitNode: qsTr("de")
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
    width: 360
    height: 640
    title: qsTr("Qtractor")

    Image {
        id: backgroundImage

        source: "qrc:/Images/design.png"
        /*anchors.top: parent.top
        anchors.bottom: footer.top
        anchors.right: parent.right
        anchors.left: parent.left*/
        anchors.fill: parent

        fillMode: Image.Tile
        clip: false
    }


    TabBar {
        id: footer

        Material.theme: Material.Light
        Material.background: "#30FAFAFA"
        Material.foreground: "#FAFAFA"
        Material.accent: "#FF5722"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: 50
        position: TabBar.Footer
        currentIndex: view.currentIndex

        TabButton {
            text: "General"
            font.pointSize: 10
            icon.source: "/Icons/general.png"
            icon.height: 20
            icon.width: 20
        }
        TabButton {
            text: "Ports"
            font.pointSize: 10
            icon.source: "/Icons/port.png"
            icon.height: 20
            icon.width: 20
        }
        TabButton {
            text: "Bridges"
            font.pointSize: 10
            icon.source: "/Icons/bridge.png"
            icon.height: 20
            icon.width: 20
        }
    }


    SwipeView {
        id: view

        currentIndex: footer.currentIndex
        anchors.top: window.top
        width: window.width
        height: window.height - 50

        General {
            id: generalPage
        }

        PortsSetting {
            id: protsSettingPage
        }

        BridgesSetting {
            id: bridgesSettingPage
        }
    }
}
