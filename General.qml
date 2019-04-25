import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import CustomControls 1.0
import Process 1.0
import Gsettings 1.0

Item {
    id: root

    property string exitNode: "ww"
    Component.onCompleted: {
        isRunning.start("tractor isrunning")
        dconf.settingNew()
        exitNode = dconf.getStringValue("exit-node")
        acceptConnectionDelegate.checked = dconf.getBoolValue("accept-connection")
    }

    property Qgsettings tractorConf: dconf

    //property alias conf: dconf

    Rectangle {
        id: header

        Rectangle {
            id: bottomHeader

            anchors.top : header.top
            anchors.left: header.left
            anchors.right: header.right
            height: 20
            color: parent.color
            z: -1

        }

        Material.theme: Material.Light
        anchors.top: root.top
        anchors.left: parent.left
        anchors.right: parent.right
//        anchors.margins: 6
        height: 50
//        color : "#29292c"
        color: "#212121"
//        radius: 5
//        color: "transparent"

        Text {
            text: qsTr("Exit node:")
            font.pointSize: 10
//            font.weight: Font.Medium
            font.weight: Font.Light
//            anchors.top: countryImage.top
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: countryImage.right
            anchors.leftMargin: 10
//            color: "black"
            color: "#EEEEEE"
        }

        Text {
            id: countryName

            //text: qsTr("Optimal")
            text: {
                //console.log("debug started.")
                var i = 0
                for (i = 0; i < exitNodeModel.count; i++) {
                    //console.log(i + "\n")
                    if (exitNodeModel.get(i).code === exitNode)
                        return exitNodeModel.get(i).title
                }
                return "Optimal"
            }
            color: "#FAFAFA"
            font.pointSize: 12
            font.weight: Font.Medium
            //font.bold: true
//            anchors.left: countryImage.right
            anchors.right: parent.right
//            anchors.leftMargin: 15
            anchors.rightMargin: 15
//            anchors.bottom: countryImage.bottom
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            id: countryImage

            //source: "qrc:/Icons/speed.png"
            source: {
                var i = 0
                for (i = 0; i < exitNodeModel.count; i++) {
                    if (exitNodeModel.get(i).code === exitNode)
                        return exitNodeModel.get(i).icon
                }
                return "qrc:/Icons/speed.png"
            }

            width: 30
            height: 30
            anchors.left: parent.left
            anchors.leftMargin: 16
//            anchors.top: parent.top
//            anchors.topMargin: 7.5
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    onClicked: countryPopup.open()
                }
            }

            Popup {
                id: countryPopup

                Material.theme: Material.Light
                x: 35  // center : root.width / 2 - 115
                y: 30
                width: 200
                height: (root.height / 4) * 3
                modal: true
                focus: true
                topPadding: 10
                bottomPadding: 10
                leftPadding: 0
                rightPadding: 0
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                ListView {
                    id: countryList

                    focus: true
                    anchors.fill: parent
                    clip: true
                    currentIndex: -1

                    delegate: ItemDelegate {
                        width: parent.width
                        text: model.title

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            width: 25
                            height: 25
                            source: model.icon
                        }

                        highlighted: ListView.isCurrentItem

                        onClicked: {
                            countryList.currentIndex = index
                            countryImage.source = model.icon
                            countryName.text = model.title
                            dconf.setStringValue("exit-node", model.code)
                            if (bar.value == 100) {
                                processRestart.start(processRestart.command)
                            }
                            countryAnim.start()
                            countryPopup.close()

                            root.exitNode = model.code
                        }
                    }

                    model: ListModel {
                        id: exitNodeModel

                        ListElement { title: "Optimal"; icon: "qrc:/Icons/speed.png"; code: "ww"}
                        ListElement { title: "Austria"; icon: "qrc:/Icons/austria.png"; code: "au"}
                        ListElement { title: "Canada"; icon: "qrc:/Icons/canada.png"; code: "ca" }
                        ListElement { title: "Czech"; icon: "qrc:/Icons/czech-republic.png"; code: "cz" }
                        ListElement { title: "Finland"; icon: "qrc:/Icons/finland.png"; code: "fi" }
                        ListElement { title: "France"; icon: "qrc:/Icons/france.png"; code: "fr" }
                        ListElement { title: "Germany"; icon: "qrc:/Icons/germany.png"; code: "de" }                        
                        ListElement { title: "Ireland"; icon: "qrc:/Icons/ireland.png"; code: "ie" }
                        ListElement { title: "Moldova"; icon: "qrc:/Icons/moldova.png"; code: "md" }
                        ListElement { title: "Netherlands"; icon: "qrc:/Icons/netherlands.png"; code: "nl" }
                        ListElement { title: "Norway"; icon: "qrc:/Icons/norway.png"; code: "no" }
                        ListElement { title: "Poland"; icon: "qrc:/Icons/poland.png"; code: "pl" }
                        ListElement { title: "Romania"; icon: "qrc:/Icons/romania.png"; code: "ro" }
                        ListElement { title: "Russia"; icon: "qrc:/Icons/russia.png"; code: "ru" }
                        ListElement { title: "Seychelles"; icon: "qrc:/Icons/seychelles.png"; code: "sc" }
                        ListElement { title: "Singapore"; icon: "qrc:/Icons/singapore.png"; code: "sg" }
                        ListElement { title: "Spain"; icon: "qrc:/Icons/spain.png"; code: "es" }
                        ListElement { title: "Sweden"; icon: "qrc:/Icons/sweden.png"; code: "se" }
                        ListElement { title: "Switzerland"; icon: "qrc:/Icons/switzerland.png"; code: "ch" }
                        ListElement { title: "Ukraine"; icon: "qrc:/Icons/ukraine.png"; code: "ua" }
                        ListElement { title: "United Kingdom"; icon: "qrc:/Icons/united-kingdom.png"; code: "uk" }
                        ListElement { title: "United States"; icon: "qrc:/Icons/united-states.png"; code: "us" }

                    }
                }
            }
        }


    }

    SwitchDelegate {
        id: acceptConnectionDelegate

        Material.accent: "#E91E63"
        anchors.top: header.bottom
        anchors.topMargin: 1
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        text: "Accept connection"
        font.bold: true

        ToolTip {
            Material.theme: Material.Light
            text: qsTr("Whether or not allowing external devices <br> to use this network")
            visible: parent.hovered
            delay: 2000
            timeout: 3000
            font.pointSize: 10
            font.weight: Font.Light
        }

        onClicked: {
            if (checked)
                dconf.setBoolValue("accept-connection", true)
            else
                dconf.setBoolValue("accept-connection", false)
        }
    }

    Rectangle {
        id: barContainer

//        width: 195
        anchors.top: acceptConnectionDelegate.bottom
//        anchors.bottom: globalContainer.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: {
            if (bar.value == 100) {
                return root.height - header.height -
                acceptConnectionDelegate.height -
                conditionContainer.height - 180 -
                80  // to be beautifull
            } else {
                return root.height - header.height -
                acceptConnectionDelegate.height -
                conditionContainer.height - 80  // to be beautifull
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

//        anchors.centerIn: parent
        color: "transparent"
        property real barScale: 150

        // animated Rectangle
//        Rectangle {
//            id: indicatorCircle

//            color: "transparent"
//            border.width: 1
//            border.color: "#E91E63"
//            anchors.centerIn: bar
//            width: 152
//            height: 152
//            radius: 152
//            opacity: {
//                if (bar.value == 0)
//                    return 1
//                else
//                    return 0
//            }
//        }

//        Rectangle {
//            id: barForground

//            width: parent.barScale
//            height: parent.barScale
//            radius: parent.barScale
//            border.width: 6
//            border.color: "#191a2f"
//            color: "transparent"
//            anchors.centerIn: parent

////            MouseArea {
////                id: barMouseArea
////                anchors.fill: barForground

////                hoverEnabled: true

////                onClicked: {
////                    //progressAnim.enabled = true
////                    if (bar.value == 0){
////                        //focus = false  // for animation
//////                        barClickedAnim.start()
////                        processStart.start("tractor start")

////                        //parent.value = 100

////                    } else if (bar.value == 100) {
////                        //focus = false
////                        processStop.start("tractor stop")
////                        //parent.value = 0
////                    } else { }
////                }

////                cursorShape: {
////                    if (bar.value == 0 || bar.value == 100) {
////                        return Qt.PointingHandCursor
////                    } else {
////                        return Qt.WaitCursor
////                    }
////                }
////            }
//        }

        // - - - - circular bar - - - -
        RadialBar {
            id: bar

            anchors.centerIn: parent
            width: parent.barScale + 5
            height: parent.barScale + 5
            penStyle: Qt.RoundCap
//            dialType: RadialBar.FullDial
    //        progressColor: "#FF5722"
            progressColor: "#E91E63"
            foregroundColor: "#191a2f"  // foreground declared seperatly.
            dialWidth: 8
//            startAngle: 200
            startAngle: 190
            spanAngle: 340
            minValue: 0
            maxValue: 100
            value: {
                if (tractorCondition.text == "Tractor is connected")
                    return 100
                else
                    return 0
            }
            textFont {
//                family: "Halvetica"
                family: ubuntuFontCondensed.name
                italic: false
                pointSize: 20

            }
            suffixText: "%"

            textColor: {
                if (value == 100 || value == 0)
                    return "#00FAFAFA"
                else
                    return "#FFFAFAFA"
            }
//            BusyIndicator {
//                Material.accent: "white"
//                running: {
//                    if (parent.value == 100 || parent.value == 0)
//                        return false
//                    else
//                        return true
//                }
//                anchors.left: barText.right
//                anchors.verticalCenter: barText.verticalCenter
//                width: 40
//                height: 40
//            }

            Behavior on value {
                id: progressAnim

                NumberAnimation {
                    duration: 500
                }

                enabled: false
            }

            MouseArea {
                id: barMouseArea
                anchors.fill: barText

                hoverEnabled: true

                onClicked: {
                    //progressAnim.enabled = true
                    if (bar.value == 0){
                        //focus = false  // for animation
//                        barClickedAnim.start()
                        processStart.start("tractor start")

                        //parent.value = 100

                    } else if (bar.value == 100) {
                        //focus = false
                        processStop.start("tractor stop")
                        //parent.value = 0
                    } else { }
                }

                cursorShape: {
                    if (bar.value == 0 || bar.value == 100) {
                        return Qt.PointingHandCursor
                    } else {
                        return Qt.WaitCursor
                    }
                }

            }

            Text {
                id: barText

                anchors.centerIn: parent

                text: {
                    if (parent.value == 100) {
                        return "Stop"
                    } else {
                        return "Connect"
                    }
                }
                anchors.verticalCenterOffset: {
                    if (parent.value == 100)
                        return 25
                    else
                        return 0
                }
    //            color: "#FAFAFA"
                color: {
                    if (barMouseArea.containsMouse)
                        return "#E91E63"
                    else
                        return "white"
                }

                opacity: {
                    if (parent.value == 100 || parent.value == 0)
                        return 1
                    else
                        return 0
                }

                font.family: ubuntuFontCondensed.name
//                font.pointSize: 14
//                font.bold: true
                font.pointSize: {
                    if (bar.value == 100)
                        return 14
                    else
                        return 18
                }

                Behavior on font.pointSize {
                    NumberAnimation {
                        duration: 400
                        easing.type: "OutElastic"
                    }
                }

            }

            Text {
                id: timerText

                visible: {
                    if (bar.value == 100) {
                        return true
                    } else {
                        return false
                    }
                }

                onVisibleChanged: {
                    s = ss = m = mm = h = hh = 0
                }

                anchors.centerIn: parent
                anchors.verticalCenterOffset: -20
                property int s: 0
                property int ss: 0
                property int m: 0
                property int mm: 0
                property int h: 0
                property int hh: 0
                text: hh.toString() + h + ":" + mm + m + ":" + ss + s
//                color: "white"
                color: "#E0E0E0"
                font.family: ubuntuFontCondensed.name
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
                        if (bar.value == 100) {
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



        }
        // , , , , , , , , , , , , , , ,


    }

    Rectangle {
        id: globalContainer

        anchors.bottom: root.bottom
        anchors.bottomMargin: 75
        anchors.horizontalCenter: parent.horizontalCenter
        property real offmapOpacity: 0.125
        property real onmapOpacity: 0.4
        color: "transparent"
        width: 340
//        height: 180
        height: {
            if (bar.value == 100)
                return 180
            else
                return 120
        }

        Behavior on height {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }

        opacity: {
            if (bar.value == 100)
                return 1
            else
                return 0
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

//        Image {
//            id: global

//            source: "qrc:/Images/global.png"
////            anchors.fill: parent
//            anchors.top: parent.top
//            anchors.left: parent.left
//            anchors.right: parent.right
//            height: 180
//            opacity: 0.1
//        }

        Image {
            id: otherMap

            source: "qrc:/Images/other_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: parent.offmapOpacity
        }

        Image {
            id: austria_map

            source: "qrc:/Images/austria_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "au")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: canadaMap

            source: "qrc:/Images/canada_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "ca")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: czechMap

            source: "qrc:/Images/czech_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "cz")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: finlandMap

            source: "qrc:/Images/finland_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "fi")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: franceMap

            source: "qrc:/Images/france_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "fr")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: germanyMap

            source: "qrc:/Images/germany_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "de")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: irelandMap

            source: "qrc:/Images/ireland_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "ie")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: moldovaMap

            source: "qrc:/Images/moldova_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "md")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: netherlandsMap

            source: "qrc:/Images/netherlands_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "nl")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: norwayMap

            source: "qrc:/Images/norway_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "no")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: polandMap

            source: "qrc:/Images/poland_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "pl")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: romaniaMap

            source: "qrc:/Images/romania_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "ro")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: russiaMap

            source: "qrc:/Images/russia_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "ru")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: seychellesMap

            source: "qrc:/Images/seychelles_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "sc")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

//        Image {
//            id: singaporeMap

//            source: "qrc:/Images/singapore_map.png"
////            anchors.fill: parent
//            anchors.top: parent.top
//            anchors.left: parent.left
//            anchors.right: parent.right
//            height: 180
//            opacity: {
//        if (bar.value == 100 && exitNode === "sg")
//            return 0.4
//        else
//            return 0.1
//    }
//        }

        Image {
            id: spainMap

            source: "qrc:/Images/spain_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "es")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: swedenMap

            source: "qrc:/Images/sweden_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "se")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: switzerlandMap

            source: "qrc:/Images/switzerland_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "ch")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: ukraineMap

            source: "qrc:/Images/ukraine_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "ua")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: unitedKingdomMap

            source: "qrc:/Images/unitedKingdom_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "uk")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

        Image {
            id: unitedStatesMap

            source: "qrc:/Images/unitedStates_map.png"
//            anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 180
            opacity: {
                if (bar.value == 100 && exitNode === "us")
                    return parent.onmapOpacity
                else
                    return parent.offmapOpacity
            }
        }

    }

    Rectangle {
        id: conditionContainer

        anchors.bottom: root.bottom
        anchors.bottomMargin: 25
        anchors.horizontalCenter: root.horizontalCenter
        height: 30
        width: tractorCondition.width
        Behavior on width {
            NumberAnimation {
//                duration: 500
                easing.type: Easing.Linear
            }
        }

        // , , , , , , , , , , , , ,


        Rectangle {
            width: tractorCondition.width / 2
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
                if (bar.value == 100) {
                    return "#E91E63"
                } else {
                    return "#191a2f"
                }
            }

        }


        color: "transparent"

        Text {
            id: tractorCondition

            //visible: false
            //width: root.width - 200
            height: 17
            clip: true
//            anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
//            color: {
//                if (text == "Tractor is not Connected." || text == "Tractor stopped" ||
//                        text.includes("Reached timeout.") || text == "Tractor is not connected.")
//                    return "#BDBDBD"
//                else
//                    return "black"
//            }
//            visible: {
//                if (bar.value == 100)
//                    return false
//                else
//                    return true
//            }

            text: ""

            Behavior on text {
                ColorAnimation {
                    target: tractorCondition
                    property: "color"
                    from: "transparent"
                    to: "#BDBDBD"

                    easing.type: Easing.Linear
                }
            }

            font.family: ubuntuFontMono.name
            font.pointSize: 12
        }

//        Text {
//            height: 17
//            clip: true
//            anchors.verticalCenter: parent.verticalCenter
//            anchors.horizontalCenter: parent.horizontalCenter
//            color: "black"
//            visible: {
//                if (bar.value == 100)
//                    return true
//                else
//                    return false
//            }

//            text: tractorCondition.text
//            font.family: ubuntuFontMono.name
//            font.pointSize: 12
//        }

    }


    // - - - - third_party classes - - - -
    Process {
        id: processStart

        property string str: ""

        onStarted: {
            progressAnim.enabled = true
        }

        onFinished: {
            //barMouseArea.focus = true
            progressAnim.enabled = false
        }

        //onReadyReadStandardOutput: tractorCondition.text = readAll()
        onReadyReadStandardOutput: {
            str = readAll()
            if (str.includes("Tractor")) {
                if (str.includes("Starting")) {
                    tractorCondition.text = "Starting Tractor"
                } else if (str.includes("conneted")) {
                    tractorCondition.text = "Tractor is connected"
                } else {
                    tractorCondition.text = str.slice(7, str.length - 5)
                }
            }
            else if (str.includes("Bootstrapped")) {
                tractorCondition.text = str.slice(str.indexOf("Bootstrapped") + 13, str.length - 5)
                bar.value = parseInt(str.slice(str.indexOf("Bootstrapped") + 13, str.indexOf("%")))
            } else {
                tractorCondition.text = str.slice(5, str.length - 5)
                if (str.includes("Reached timeout.")) {
                    bar.value = 0
                }
            }

            if (tractorCondition.text.length > 30) {
                tractorCondition.text = tractorCondition.text.slice(0, 25) + " ..."
            }
        }
    }

    Process {
        id: processStop

        property string str: ""
        //onReadyReadStandardOutput: tractorCondition.text = readAll()
        onReadyReadStandardOutput: {
            str = readAll()
            if (str.includes("Tractor"))
                tractorCondition.text = str.slice(7, str.length - 5)
            else
                tractorCondition.text = str.slice(5, str.length - 5)

            if (tractorCondition.text.length > 30) {
                tractorCondition.text = tractorCondition.text.slice(0, 25) + " ..."
            }

        }
        onFinished: {
            //barMouseArea.focus = true
            if (tractorCondition.text == "Tractor stopped")
                bar.value = 0
        }
    }

    Process {
        id: isRunning

        onFinished: {
//            tractorCondition.opacity = 1
            if (tractorCondition.text.includes("True"))
                tractorCondition.text = "Tractor is connected"
            else {
                tractorCondition.text = "Tractor is not connected"
            }
        }

        onReadyReadStandardOutput: {
            tractorCondition.text = readAll()
        }
    }

    Process {
        id: processRestart

        property string command: "tractor stop"
        //onReadyReadStandardOutput: tractorCondition.text = readAll()

        onFinished: {
            bar.value = 0
            processStart.start("tractor start")
        }
    }

    Qgsettings {
        id: dconf

        schema: "org.tractor"
    }

    // ___________________________________


    // - - - - stand alone animations - - - -
//    ParallelAnimation {
//        id: indicatorAnim

//        running: {
//            if (bar.value == 0)
//                return true
//            else
//                return false
//        }
//        loops: Animation.Infinite

//        onStopped: {
//            indicatorCircle.width = 164
//            indicatorCircle.height = 164
//        }

//        NumberAnimation {
//            target: indicatorCircle
//            property: "width"
//            from: 149
//            to: 230
//            duration: 1500
//            easing.type: "InQuint"
//        }

//        NumberAnimation {
//            target: indicatorCircle
//            property: "height"
//            from: 149
//            to: 230
//            duration: 1500
//            easing.type: "InQuint"
//        }

//        ColorAnimation {
//            target: indicatorCircle
//            property: "border.color"
//            from: "#191a2f"
//            to: "#55191a2f"
//            duration: 1500
//            easing.type: "InExpo"
//        }

//    }

//    NumberAnimation {
//        id: barClickedAnim

//        target: barContainer
//        property: "barScale"
//        from: 165
//        to: 150
//        duration: 2000
//        easing.type: "OutElastic"
//    }


    NumberAnimation {
        id: conditionAnim

        running: {
            if (bar.value == 100)
                return true
            else
                return false
        }

        target: conditionContainer
        property: "anchors.bottomMargin"
        from: 40
        to: 25
        duration: 1000
        easing.type: "OutElastic"
    }

    // animation for county flags when select.
    RotationAnimation {
        id: countryAnim

        target: countryImage
        from: 20
        to: 0
        duration: 1000
        easing.type: "OutElastic"
    }

    // ______________________________________
}
