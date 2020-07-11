import QtQuick                    2.4
import QtQuick.Controls           2.4
import QtQuick.Controls.impl      2.4
import QtQuick.Controls.Material  2.4
import app.customControls         1.0
import app.tractor                1.0

import "./components" as C

Page {
  id: root

  property var tractor

  header: ToolBar {
    id: pageHeader

    height: 58
    Material.elevation: 0
    Material.background: "transparent"

    Label {
      anchors.left: parent.left
      anchors.margins: 16
      anchors.verticalCenter: parent.verticalCenter

      text: qsTr("General")
      font: uiParams.fonts.headingOne
    }

    TabButton {
      anchors.right: parent.right
      anchors.rightMargin: 8

      checkable: false
      height: parent.height
      icon.source: "qrc:/icons/info.svg"

      onClicked: { aboutDialog.open() }
    }
  }

  Item {
    id: container

    anchors.fill: parent

    // circular bar
    Item {
      id: barCtnr

      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right

      property real height_2: root.height * 9 / 32
      property real height_1: root.height / 2

      height: tractor.status === Tractor.CONNECTED ? height_2 : height_1

      Behavior on height {
        enabled: tractor.status === Tractor.CONNECTING
        NumberAnimation {
          duration: 300
          easing.type: Easing.OutQuad
        }
      }

      RadialBar {
        id: bar

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter

        width: height
        height: root.height * 9 / 32 - 4
        penStyle: Qt.RoundCap
        progressColor: uiParams.accentColor//"#E91E63"
        foregroundColor: "#191a2f"  // foreground declared seperatly.
        dialWidth: 8
        startAngle: 190
        spanAngle: 340
        minValue: 0
        maxValue: 100
        value: tractor.progress
        textColor: "#00FAFAFA"
        suffixText: ""

        textFont.family: uiParams.fonts.headingCondensed.family
        textFont.italic: false
        textFont.pixelSize: 26

        Behavior on value {
          enabled: tractor.status === Tractor.CONNECTING
          NumberAnimation { duration: 500 }
        }

        Label {
          id: barText

          anchors.centerIn: parent
//                anchors.verticalCenterOffset: bar.value === 100 ? 25 : 0

          text: tractor.status === Tractor.CONNECTED ?
                    "Stop" : tractor.status === Tractor.STOPED ?
                        "Connect" : Math.round(bar.value) + " %"

          color: barMouseArea.containsMouse &&
                 tractor.status !== Tractor.CONNECTING ? "#E91E63" : "white"
          enabled: tractor.status !== Tractor.CONNECTING
          font.family: uiParams.fonts.headingCondensed.family
          font.pixelSize: bar.width * 26 / 174

          Behavior on font.pixelSize {
            NumberAnimation {
              duration: 400
              easing.type: "OutElastic"
            }
          }
        }

        Text {
          id: timerText

//                visible: {
//                    if (tractor.status === Tractor.CONNECTED) {
//                        return true
//                    } else {
//                        return false
//                    }
//                }

          visible: false

          onVisibleChanged: { s = ss = m = mm = h = hh = 0 }

          anchors.centerIn: parent
          anchors.verticalCenterOffset: -20
          property int s: 0
          property int ss: 0
          property int m: 0
          property int mm: 0
          property int h: 0
          property int hh: 0
          text: hh.toString() + h + ":" + mm + m + ":" + ss + s
          color: "#E0E0E0"
          font.family: uiParams.fonts.headingCondensed.family
          font.weight: Font.Medium
          font.pointSize: 22
          onSChanged: {
            if (s == 10) {
              s = 0
              ss++
            }
          }
          onSsChanged: {
            if (ss == 6) {
              ss = 0
              m++
            }
          }
          onMChanged: {
            if (m == 10) {
              m = 0
              mm++
            }
          }
          onMmChanged: {
            if (mm == 6) {
              mm = 0
              h++
            }
          }
          onHChanged: {
            if (h == 10) {
              h = 0
              hh++
            }
          }

          Timer {
            id: timer

            repeat: true
            running: {
              if (tractor.status === Tractor.CONNECTED) {
                return true
              }
              else {
                return false
              }
            }

            onTriggered: {
              parent.s++
            }
          }
        }

        MouseArea {
          id: barMouseArea

          anchors.centerIn: parent
          width: parent.width
          height: parent.height
          hoverEnabled: true
          cursorShape: tractor.status === Tractor.STOPED ||
                       tractor.status === Tractor.CONNECTED ? Qt.PointingHandCursor
                                                            : Qt.WaitCursor

          onClicked: {
            if (tractor.status === Tractor.STOPED){
                tractor.start()
            } else if (tractor.status === Tractor.CONNECTED) {
                tractor.stop()
            } else {
                // NOTHING
            }
          }
        }
      }
    }

    // parameters
    Item {
      id: slCtr
      width: parent.width
      anchors.top: barCtnr.bottom
      anchors.bottom: mapCtnr.top

      Column {
        id: selectionList

        anchors.verticalCenter: parent.verticalCenter
        width: parent.width

        // accept connection
        SwitchDelegate {
          id: acceptConnectionDelegate

          width: parent.width
          text: "Accept connection"
//          font: uiParams.fonts.paragraph
          font.weight: Font.Light
          enabled: tractor.status === Tractor.STOPED

          checked: tractor.settings.acceptConnection

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

          ToolTip {
            Material.theme: Material.Light
            text: qsTr("Whether or not allowing external devices <br> to use this network")
            visible: parent.hovered
            delay: 2000
            timeout: 3000
            font.pointSize: 10
            font.weight: Font.Light
          }

          onToggled: { tractor.settings.acceptConnection = checked }
        }

        // exit node
        ItemDelegate {
          width: parent.width
          font: uiParams.fonts.paragraph
          text: "Exit node:"
          enabled: tractor.status !== Tractor.CONNECTING

          Label {
            id: eNodeName

            anchors.left: eNImg.right
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter

            font: uiParams.fonts.paragraph

            text: {
              var m = eNView.model
              for (var i = 0; i < eNView.count; i++) {
                if (m[i].code === tractor.settings.exitNode)
                  return m[i].title
              }
              return "---"
            }
          }

          Image {
            id: eNImg

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 100

            width: 25
            height: 25

            source: {
              var m = eNView.model
              for (var i = 0; i < eNView.count; i++) {
                if (m[i].code === tractor.settings.exitNode)
                  return m[i].icon
              }

              return ""
            }
          }

          // bottom splite
          Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: uiParams.splitColor
          }

          onClicked: {
            eNodeDialog.open()
          }
        }
      }
    }

    // map
    Item {
      id: mapCtnr

      anchors.bottom: parent.bottom
      anchors.bottomMargin: 75
      anchors.horizontalCenter: parent.horizontalCenter

      readonly property real offmapOpacity: 0.125
      readonly property real onmapOpacity: 0.4

      property real _avaHeight: parent.height - barCtnr.height_2 - selectionList.height -
                                cdnCtr.height - header.height - 16

      property real _maxHeight: root.width * 180 / 340

      property real height_2: Math.min(_avaHeight, _maxHeight)
      property real height_1: 0

      width: height_2 * 340 / 180
      height: tractor.status === Tractor.CONNECTED ? height_2 : height_1
      opacity: tractor.status === Tractor.CONNECTED ? 1 : 0
      clip: true

      readonly property real imgHeight: height_2

      Behavior on height {
        enabled: tractor.status === Tractor.CONNECTING
        NumberAnimation {
          duration: 500
          easing.type: Easing.InOutQuad
        }
      }

      Behavior on opacity {
        NumberAnimation {
          duration: 200
          easing.type: Easing.InOutQuad
        }
      }

//        Image {
//            id: global

//            source: "qrc:/images/global.png"
////            anchors.fill: parent
//            anchors.top: parent.top
//            anchors.left: parent.left
//            anchors.right: parent.right
//            height: 180
//            opacity: 0.1
//        }

      Image {
        id: otherMap

        source: "qrc:/images/other_map.png"
//            anchors.fill: parent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.imgHeight//180
        opacity: parent.offmapOpacity
      }

      Image {
        id: austria_map

        source: "qrc:/images/austria_map.png"
//            anchors.fill: parent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.imgHeight
        opacity: {
          if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "au")
            return parent.onmapOpacity
          else
            return parent.offmapOpacity
        }
      }

      Image {
        id: canadaMap

        source: "qrc:/images/canada_map.png"
//            anchors.fill: parent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.imgHeight
        opacity: {
          if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "ca")
            return parent.onmapOpacity
          else
            return parent.offmapOpacity
        }
      }

      Image {
          id: czechMap

          source: "qrc:/images/czech_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "cz")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: finlandMap

          source: "qrc:/images/finland_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "fi")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: franceMap

          source: "qrc:/images/france_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "fr")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: germanyMap

          source: "qrc:/images/germany_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "de")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: irelandMap

          source: "qrc:/images/ireland_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "ie")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: moldovaMap

          source: "qrc:/images/moldova_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "md")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: netherlandsMap

          source: "qrc:/images/netherlands_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "nl")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: norwayMap

          source: "qrc:/images/norway_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "no")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: polandMap

          source: "qrc:/images/poland_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "pl")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: romaniaMap

          source: "qrc:/images/romania_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "ro")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: russiaMap

          source: "qrc:/images/russia_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "ru")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: seychellesMap

          source: "qrc:/images/seychelles_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "sc")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

//        Image {
//            id: singaporeMap

//            source: "qrc:/images/singapore_map.png"
////            anchors.fill: parent
//            anchors.top: parent.top
//            anchors.left: parent.left
//            anchors.right: parent.right
//            height: parent.imgHeight
//            opacity: {
//        if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "sg")
//            return 0.4
//        else
//            return 0.1
//    }
//        }

      Image {
          id: spainMap

          source: "qrc:/images/spain_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "es")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: swedenMap

          source: "qrc:/images/sweden_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "se")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: switzerlandMap

          source: "qrc:/images/switzerland_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "ch")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: ukraineMap

          source: "qrc:/images/ukraine_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "ua")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: unitedKingdomMap

          source: "qrc:/images/unitedKingdom_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "uk")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }

      Image {
          id: unitedStatesMap

          source: "qrc:/images/unitedStates_map.png"
//            anchors.fill: parent
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: parent.imgHeight
          opacity: {
              if (tractor.status === Tractor.CONNECTED && tractor.settings.exitNode === "us")
                  return parent.onmapOpacity
              else
                  return parent.offmapOpacity
          }
      }
    }

    // status bar
    Rectangle {
        id: cdnCtr

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter
        height: 30
        width: tractorCondition.width

        Behavior on width {
            NumberAnimation {
                easing.type: Easing.Linear
            }
        }

        Rectangle {
            width: Math.min(tractorCondition.contentWidth, tractorCondition.width) / 2
            height: 5
            anchors.horizontalCenter: tractorCondition.horizontalCenter
            radius: 4
            anchors.top: tractorCondition.bottom
            anchors.topMargin: 12
            Behavior on width {
                NumberAnimation {
    //                duration: 500
                    easing.type: Easing.Linear
                }
            }

            color: {
                if (tractor.status === Tractor.CONNECTED) {
                    return "#E91E63"
                } else {
                    return "#191a2f"
                }
            }

        }

        color: "transparent"

        Label {
            id: tractorCondition

            height: 17
            clip: true
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: tractor.statusMessage
            width: root.width - 16
            horizontalAlignment: Label.AlignHCenter
            elide: Label.ElideRight

            Behavior on text {
                ColorAnimation {
                    target: tractorCondition
                    property: "color"
                    from: "transparent"
                    to: "#BDBDBD"

                    easing.type: Easing.Linear
                }
            }

            font: uiParams.fonts.codeblock
        }
    }
  }

  C.Dialog {
    id: eNodeDialog

    rootItem: root
    title: "Choose exit node"

    ListView {
      id: eNView

      focus: true
      clip: true
      currentIndex: -1
      width: 256
      height: Math.min(contentHeight, root.height / 2)

      ScrollBar.vertical: ScrollBar {
        parent: eNodeDialog.contentItem
        anchors.top: eNView.top
        anchors.bottom: eNView.bottom
        anchors.right: parent.right
        anchors.rightMargin: -eNodeDialog.rightPadding + 1
      }

      delegate: ItemDelegate {
        id: eNDelegate

        width: parent.width
        text: "       " + modelData.title

        // flag logo
        Image {
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.left
          anchors.leftMargin: 4
          width: 25
          height: 25
          source: modelData.icon
        }

        highlighted: ListView.isCurrentItem

        onClicked: {
          eNView.currentIndex = index
          tractor.settings.exitNode = modelData.code
          if (tractor.status === Tractor.CONNECTED) {
            tractor.restart()
          }

          eNodeDialog.close()
        }
      }

      model: [
        { "title": "Optimal",     "icon": "qrc:/icons/speed.png",           "code": "ww" },
        { "title": "Austria",     "icon": "qrc:/icons/austria.png",         "code": "au" },
        { "title": "Canada",      "icon": "qrc:/icons/canada.png",          "code": "ca" },
        { "title": "Czech",       "icon": "qrc:/icons/czech-republic.png",  "code": "cz" },
        { "title": "Finland",     "icon": "qrc:/icons/finland.png",         "code": "fi" },
        { "title": "France",      "icon": "qrc:/icons/france.png",          "code": "fr" },
        { "title": "Germany",     "icon": "qrc:/icons/germany.png",         "code": "de" },
        { "title": "Ireland",     "icon": "qrc:/icons/ireland.png",         "code": "ie" },
        { "title": "Moldova",     "icon": "qrc:/icons/moldova.png",         "code": "md" },
        { "title": "Netherlands", "icon": "qrc:/icons/netherlands.png",     "code": "nl" },
        { "title": "Norway",      "icon": "qrc:/icons/norway.png",          "code": "no" },
        { "title": "Poland",      "icon": "qrc:/icons/poland.png",          "code": "pl" },
        { "title": "Romania",     "icon": "qrc:/icons/romania.png",         "code": "ro" },
        { "title": "Russia",      "icon": "qrc:/icons/russia.png",          "code": "ru" },
        { "title": "Seychelles",  "icon": "qrc:/icons/seychelles.png",      "code": "sc" },
        { "title": "Singapore",   "icon": "qrc:/icons/singapore.png",       "code": "sg" },
        { "title": "Spain",       "icon": "qrc:/icons/spain.png",           "code": "es" },
        { "title": "Sweden",      "icon": "qrc:/icons/sweden.png",          "code": "se" },
        { "title": "Switzerland", "icon": "qrc:/icons/switzerland.png",     "code": "ch" },
        { "title": "Ukraine",     "icon": "qrc:/icons/ukraine.png",         "code": "ua" },
        { "title": "United Kingdom", "icon": "qrc:/icons/united-kingdom.png", "code": "uk" },
        { "title": "United States", "icon": "qrc:/icons/united-states.png", "code": "us" },
      ]
    }
  }

  C.Dialog {
    id: aboutDialog

    rootItem: root
    title: "About"

    Column {
      width: 256
      spacing: 2

      // logo
      Image {
        anchors.horizontalCenter: parent.horizontalCenter

        width: 88
        height: 88
        source: "qrc:/icons/torLogo.png"
        antialiasing: true
      }

      // app name
      Label {
        anchors.horizontalCenter: parent.horizontalCenter

        text: "Traqtor"
        color: uiParams.foregroundColor
        font.pixelSize: 20
        font.bold: true
      }

      // description
      Label {
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter

        width: parent.width
        text: "Version 1.0\n\nGraphical setting app for tractor\nReleased under the term of the GNU GPL v3"
        wrapMode: "WordWrap"
        color: uiParams.foregroundColor
        font.pixelSize: 16
      }

      // free space
      Item {
        width: 1
        height: 8
      }

      // star on gitlab
      TabButton {
        anchors.horizontalCenter: parent.horizontalCenter
        checkable: false
        text: "Star on gitlab"
        width: parent.width
        font: uiParams.fonts.paragraph

        onClicked: {
          Qt.openUrlExternally("https://gitlab.com/tractor-team/qtractor")
          aboutDialog.accept()
        }
      }

      // report a bug
      TabButton {
        anchors.horizontalCenter: parent.horizontalCenter

        checkable: false
        text: "Report a bug"
        width: parent.width
        font: uiParams.fonts.paragraph

        onClicked: {
          Qt.openUrlExternally("https://gitlab.com/tractor-team/qtractor/issues")
          aboutDialog.accept()
        }
      }

      // close
      TabButton {
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        checkable: false
        text: "Close"
        font: uiParams.fonts.paragraph

        onClicked: {  aboutDialog.close() }
      }
    }
  }

  // status bar animation
  NumberAnimation {
    running: tractor.status === Tractor.CONNECTED
    target: cdnCtr
    property: "anchors.bottomMargin"
    from: 40
    to: 25
    duration: 1000
    easing.type: "OutElastic"
  }
}
