import QtQuick                        2.4
import QtQuick.Controls               2.4
import QtQuick.Controls.impl          2.4
import QtQuick.Controls.Material      2.4
import QtQuick.Controls.Material.impl 2.4

Rectangle {
    property alias text: la.text

    width: parent.width
    height: 25
    color: uip.sbColor

    UIParameters { id: uip }

    Label {
        id: la
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 16
        font: uip.fonts.small
    }

    SLine { anchors.bottom: parent.bottom }
}
