import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import Gsettings 1.0

Window {
    id: window


    FontLoader {
        id: ubuntu
        source: "qrc:/Fonts/Ubuntu-R.ttf"
    }
    // load fontawasome.
    FontLoader {
            id: fontAweSolid
            source: "/Fonts/Font Awesome 5 Free-Solid-900.otf"
    }

    FontLoader {
        id: ubuntuMedium
        source: "qrc:/Fonts/Ubuntu-M.ttf"
    }

    FontLoader {
        id: ubuntuBold
        source: "qrc:/Fonts/Ubuntu-B.ttf"
    }

    FontLoader {
        id: ubuntuFontMono
        source: "qrc:/Fonts/UbuntuMono-R.ttf"
    }

    visible: true
    width: 360
    maximumWidth: 360
    minimumWidth: 360
    height: 640
    maximumHeight: 640
    minimumHeight: 640
    title: qsTr("traqtor")

    Image {
        id: backgroundImage

        source: "qrc:/Images/design.png"
        anchors.fill: parent

        fillMode: Image.Tile
        clip: false
    }


    TabBar {
        id: footer

        font.family: ubuntuMedium.name
        Material.theme: Material.Light
        Material.background: "#00FFFFFF"
        Material.foreground: "#FAFAFA"
//        Material.accent: "#2196F3"
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
