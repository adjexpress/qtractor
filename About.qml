import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    id: root

    Rectangle {
        id: logoContainer

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 2
        color: "transparent"

        Image {
            id: logo

            width: 100
            height: 100
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -50
            source: "qrc:/Icons/torLogo.png"
            antialiasing: true
        }

        Text {
            id: name

            text: "Traqtor"
            anchors.top: logo.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#E0E0E0"
            font.pointSize: 16
            font.bold: true
        }

        Text {
            id: about

            text: "Version 0.5\n\nGraphical setting app for tractor\nReleased under the term f the GNU GPL v3"
            horizontalAlignment: Text.AlignHCenter
            color: "#E0E0E0"
            anchors.top: name.bottom
//            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 10
        }
    }

    ItemDelegate {
        id: starGitlab

        anchors.top: logoContainer.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        text: "Star on gitlab"
//        font.bold: true
        Image {
            source: "qrc:/Icons/right_arrow.png"
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            width: 20
            height: 20
        }

        onClicked: {
            Qt.openUrlExternally("https://gitlab.com/tractor-team/qtractor")
        }

    }

    ItemDelegate {
        id: reportBug

        anchors.top: starGitlab.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        text: "Report a bug"
//        font.bold: true
        Image {
            source: "qrc:/Icons/right_arrow.png"
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            width: 20
            height: 20
        }

        onClicked: {
            Qt.openUrlExternally("https://gitlab.com/tractor-team/qtractor/issues")
        }

    }

}
