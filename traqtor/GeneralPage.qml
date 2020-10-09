import QtQuick                      2.4
import QtQuick.Controls             2.4
import QtQuick.Controls.impl        2.4
import QtQuick.Controls.Material    2.4
import app.customControls           1.0
import app.tractor                  1.0

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

        // Circular Bar
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

            // Bar background
            Rectangle {
                anchors.fill: bar
                anchors.margins: 3
                radius: width
                color: "transparent"
                border.width: 3
                border.color: uiParams.splitColor

                Rectangle {
                    anchors.top: parent.top
                    anchors.topMargin: -5
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 40
                    width: 40
                    color: uiParams.backgroundColor
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
                /*foregroundColor: "#191a2f"  // foreground declared seperatly.*/
                foregroundColor: "transparent"  // foreground declared seperatly.
                dialWidth: 10
                startAngle: 195
                spanAngle: 330
                minValue: 0
                maxValue: 100
                value: tractor.progress
                textColor: "#00FAFAFA"
                suffixText: ""

                textFont.family: uiParams.fonts.paragraph.family
                textFont.italic: false
                textFont.pixelSize: 26

                Behavior on value {
                    enabled: tractor.status === Tractor.CONNECTING
                    NumberAnimation { duration: 500 }
                }

                Label {
                    id: barText

                    anchors.centerIn: parent
                    /*anchors.verticalCenterOffset: bar.value === 100 ? 25 : 0*/

                    text: tractor.status === Tractor.CONNECTED ? "STOP" : 
                    tractor.status === Tractor.STOPED ? "CONNECT" : 
                    Math.round(bar.value) + " %"

                    color: barMouseArea.containsMouse && 
                    tractor.status !== Tractor.CONNECTING ? uiParams.accentColor : "white"

                    enabled: tractor.status !== Tractor.CONNECTING
                    font.family: uiParams.fonts.paragraph.family
                    font.pixelSize: bar.width * 26 / 174
                    font.capitalization: Font.AllUppercase
                    font.bold: true
                }

                Label {
                    anchors.horizontalCenter: barText.horizontalCenter
                    anchors.top: barText.bottom
                    anchors.topMargin: 8
                    font.family: uiParams.fonts.paragraph.family
                    font.pixelSize: barText.pixelSize * 2 / 5
                    /*font.capitalization: Font.AllUppercase*/
                    enabled: tractor.status == Tractor.CONNECTING
                    visible: enabled
                    color: barMouseArea.containsMouse ? uiParams.accentColor : "white"
                    text: "STOP"
                }

                /*Text {*/
                    /*id: timerText*/

                    /*visible: {*/
                        /*if (tractor.status === Tractor.CONNECTED) {*/
                            /*return true*/
                        /*} else {*/
                            /*return false*/
                        /*}*/
                    /*}*/

                    /*visible: false*/

                    /*onVisibleChanged: { s = ss = m = mm = h = hh = 0 }*/

                    /*anchors.centerIn: parent*/
                    /*anchors.verticalCenterOffset: -20*/
                    /*property int s: 0*/
                    /*property int ss: 0*/
                    /*property int m: 0*/
                    /*property int mm: 0*/
                    /*property int h: 0*/
                    /*property int hh: 0*/
                    /*text: hh.toString() + h + ":" + mm + m + ":" + ss + s*/
                    /*color: "#E0E0E0"*/
                    /*font.family: uiParams.fonts.headingCondensed.family*/
                    /*font.weight: Font.Medium*/
                    /*font.pointSize: 22*/
                    /*onSChanged: {*/
                        /*if (s == 10) {*/
                            /*s = 0*/
                            /*ss++*/
                        /*}*/
                    /*}*/
                    /*onSsChanged: {*/
                        /*if (ss == 6) {*/
                            /*ss = 0*/
                            /*m++*/
                        /*}*/
                    /*}*/
                    /*onMChanged: {*/
                        /*if (m == 10) {*/
                            /*m = 0*/
                            /*mm++*/
                        /*}*/
                    /*}*/
                    /*onMmChanged: {*/
                        /*if (mm == 6) {*/
                            /*mm = 0*/
                            /*h++*/
                        /*}*/
                    /*}*/
                    /*onHChanged: {*/
                        /*if (h == 10) {*/
                            /*h = 0*/
                            /*hh++*/
                        /*}*/
                    /*}*/

                    /*Timer {*/
                        /*id: timer*/

                        /*repeat: true*/
                        /*running: {*/
                            /*if (tractor.status === Tractor.CONNECTED) {*/
                                /*return true*/
                            /*}*/
                            /*else {*/
                                /*return false*/
                            /*}*/
                        /*}*/

                        /*onTriggered: {*/
                            /*parent.s++*/
                        /*}*/
                    /*}*/
                /*}*/

                MouseArea {
                    id: barMouseArea

                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    hoverEnabled: true
                    /*cursorShape: tractor.status === Tractor.STOPED ||*/
                    /*tractor.status === Tractor.CONNECTED ? Qt.PointingHandCursor : Qt.WaitCursor*/
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        if (tractor.status === Tractor.STOPED){
                            tractor.start()
                        } else if (tractor.status === Tractor.CONNECTED) {
                            tractor.stop()
                        } else {  // tractor.status === Tractor.CONNECTING
                            tractor.kill()
                        }
                    }
                }
            }
        }

        // Exit Node
        Item {
            id: slCtr
            width: parent.width
            anchors.top: barCtnr.bottom
            anchors.bottom: mapCtnr.top

            /*Rectangle {  //DEBUG*/
                /*anchors.fill: parent*/
                /*color: "blue"*/
            /*}*/

            Column {
                id: selectionList

                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 12
                width: parent.width

                // Exit Node
                ItemDelegate {
                    width: parent.width
                    font: uiParams.fonts.small
                    text: "EXIT NODE :"
                    enabled: tractor.status !== Tractor.CONNECTING

                    Label {
                        id: eNodeName

                        /*anchors.left: eNImg.right*/
                        /*anchors.leftMargin: 8*/
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter

                        font: uiParams.fonts.small

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
                        /*anchors.left: parent.left*/
                        /*anchors.leftMargin: 110*/
                        anchors.right: eNodeName.left
                        anchors.rightMargin: 8

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

                    C.SLine { anchors.top: parent.top }
                    C.SLine { anchors.bottom: parent.bottom }

                    onClicked: {
                        eNodeDialog.open()
                    }
                }
            }
        }

        // Map
        Item {
            id: mapCtnr

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 65
            anchors.horizontalCenter: parent.horizontalCenter

            /*Rectangle {  //DEBUG*/
                /*anchors.fill: parent*/
                /*color: "green"*/
            /*}*/

            readonly property real offmapOpacity: 0.125
            readonly property real onmapOpacity: 0.4

            property real _avaHeight: parent.height - barCtnr.height_2 - selectionList.height - 
            cdnCtr.height - header.height - 24 //+ urIP.height

            property real _maxHeight: root.width * 180 / 340 + urIP.height

            property real height_2: Math.min(_avaHeight, _maxHeight)
            property real height_1: 0

            width: parent.width//height_2 * 340 / 180 + urIP.height
            height: tractor.status === Tractor.CONNECTED ? height_2 : height_1
            opacity: tractor.status === Tractor.CONNECTED ? 1 : 0
            clip: true

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

            // Locationas
            Repeater {
                model: [
                    { "src": "qrc:/images/austria_map.png", "code": "au", "name": "Austria"},
                    { "src": "qrc:/images/canada_map.png", "code": "ca", "name": "Canada"},
                    { "src": "qrc:/images/czech_map.png", "code": "cz", "name": "Czech"},
                    { "src": "qrc:/images/finland_map.png", "code": "fi", "name": "Finland"},
                    { "src": "qrc:/images/france_map.png", "code": "fr", "name": "France"},
                    { "src": "qrc:/images/germany_map.png", "code": "de", "name": "Germany"},
                    { "src": "qrc:/images/ireland_map.png", "code": "ie", "name": "Ireland"},
                    { "src": "qrc:/images/moldova_map.png", "code": "md", "name": "Moldova"},
                    { "src": "qrc:/images/netherlands_map.png", "code": "nl", "name": "Netherlands"},
                    { "src": "qrc:/images/norway_map.png", "code": "no", "name": "Norway"},
                    { "src": "qrc:/images/poland_map.png", "code": "pl", "name": "Poland"},
                    { "src": "qrc:/images/romania_map.png", "code": "ro", "name": "Romania"},
                    { "src": "qrc:/images/russia_map.png", "code": "ru", "name": "Russia"},
                    { "src": "qrc:/images/seychelles_map.png", "code": "sc", "name": "Seychelles"},
                    { "src": "qrc:/images/spain_map.png", "code": "es", "name": "Spain"},
                    { "src": "qrc:/images/sweden_map.png", "code": "se", "name": "Sweden"},
                    { "src": "qrc:/images/switzerland_map.png", "code": "ch", "name": "Switzerland"},
                    { "src": "qrc:/images/ukraine_map.png", "code": "ua", "name": "Ukraine"},
                    { "src": "qrc:/images/unitedKingdom_map.png", "code": "uk", "name": "United Kingdom"},
                    { "src": "qrc:/images/unitedStates_map.png", "code": "us", "name": "United States"},
                    { "src": "qrc:/images/other_map.png", "code": "", "name": ""},
                ]

                Image {
                    id: austria_map

                    anchors.horizontalCenter: mapCtnr.horizontalCenter
                    source: modelData.src
                    width: mapCtnr.width - 32
                    height: mapCtnr.height_2 - urIP.height

                    opacity: {
                        if (tractor.status === Tractor.CONNECTED) {
                            var geo = tractor.geoIP.split(',')
                            var cname = ""
                            if (geo.length > 1) cname = geo[1]

                            if (tractor.settings.exitNode === modelData.code || 
                            (modelData.name.length > 0 && cname.includes(modelData.name))) {
                                return 0.4;
                            } 
                        }

                        return 0.125
                    }
                }
            }

            Button {
                id: ipRefBtn
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.top: parent.top
                /*anchors.bottom: urIP.top*/
                /*anchors.verticalCenter: parent.verticalCenter*/
                width: 32
                height: 32
                padding: 8
                icon.source: "qrc:/icons/sync.svg"
                topInset: 0
                bottomInset: 0

                /*background: Item {}*/
                background: Rectangle {
                    color: uiParams.backgroundColor
                    radius: width
                    border.width: 1
                    border.color: uiParams.splitColor
                    opacity: ipRefBtn.hovered ? 1 : 0.7
                }

                Behavior on rotation {
                    NumberAnimation {
                        duration: 800
                        easing.type: Easing.InOutQuart
                    }
                }

                onClicked: {
                    tractor.calTorIP()
                    rotation += 180
                }
            }

            // IP, GeoIP
            Item {
                id: urIP
                anchors.top: parent.top
                anchors.topMargin: parent.height_2 - height
                height: 40
                width: parent.width
                visible: tractor.status === Tractor.CONNECTED

                Label {
                    /*anchors.verticalCenter: parent.verticalCenter*/
                    /*anchors.left: parent.left*/
                    /*anchors.leftMargin: 16*/
                    anchors.centerIn: parent
                    text: "Tor IP :  " + tractor.torIP + "  " + tractor.geoIP
                    font: uiParams.fonts.small
                }

                C.SLine { anchors.bottom: parent.bottom }
            }
        }

        // Status Bar
        Item {
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
                        /*duration: 500*/
                        easing.type: Easing.Linear
                    }
                }

                color: {
                    if (tractor.status === Tractor.CONNECTED) {
                        return uiParams.accentColor
                    } else {
                        return uiParams.splitColor
                    }
                }
            }

            Label {
                id: tractorCondition

                height: 20
                clip: true
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                font: uiParams.fonts.paragraph
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
            }
        }
    }

    C.Dialog {
        id: eNodeDialog

        rootItem: root
        title: "Choose exit node"
        standardButtons: Dialog.Cancel

        ListView {
            id: eNView

            focus: true
            clip: true
            currentIndex: -1
            /*width: aboutDialog.contentWidth*/
            width: 256//aboutDialog.contentWidth
            height: Math.min(contentHeight, root.height / 2)
            spacing: 1

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
                text: "             " + modelData.title

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
                { "title": "Optimal", "icon": "qrc:/icons/speed.png", "code": "ww" },
                { "title": "Austria", "icon": "qrc:/icons/austria.png", "code": "au" },
                { "title": "Canada", "icon": "qrc:/icons/canada.png", "code": "ca" },
                { "title": "Czech", "icon": "qrc:/icons/czech-republic.png", "code": "cz" },
                { "title": "Finland", "icon": "qrc:/icons/finland.png", "code": "fi" },
                { "title": "France", "icon": "qrc:/icons/france.png", "code": "fr" },
                { "title": "Germany", "icon": "qrc:/icons/germany.png", "code": "de" },
                { "title": "Ireland", "icon": "qrc:/icons/ireland.png", "code": "ie" },
                { "title": "Moldova", "icon": "qrc:/icons/moldova.png", "code": "md" },
                { "title": "Netherlands", "icon": "qrc:/icons/netherlands.png", "code": "nl" },
                { "title": "Norway", "icon": "qrc:/icons/norway.png", "code": "no" },
                { "title": "Poland", "icon": "qrc:/icons/poland.png", "code": "pl" },
                { "title": "Romania", "icon": "qrc:/icons/romania.png", "code": "ro" },
                { "title": "Russia", "icon": "qrc:/icons/russia.png", "code": "ru" },
                { "title": "Seychelles", "icon": "qrc:/icons/seychelles.png", "code": "sc" },
                { "title": "Singapore", "icon": "qrc:/icons/singapore.png", "code": "sg" },
                { "title": "Spain", "icon": "qrc:/icons/spain.png", "code": "es" },
                { "title": "Sweden", "icon": "qrc:/icons/sweden.png", "code": "se" },
                { "title": "Switzerland", "icon": "qrc:/icons/switzerland.png", "code": "ch" },
                { "title": "Ukraine", "icon": "qrc:/icons/ukraine.png", "code": "ua" },
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
            /*width: aboutDialog.contentWidth*/
            width: 256
            spacing: 1

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
                text: "Version 1.0\n\nGraphical setting app for tractor.\nReleased under the term of the GNU GPL v3"
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
                width: parent.width
                height: 40

                Label {
                    anchors.centerIn: parent
                    text: "STAR ON GITLAB"
                    color: uiParams.accentColor
                }

                onClicked: {
                    Qt.openUrlExternally("https://gitlab.com/tractor-team/qtractor")
                    aboutDialog.accept()
                }
            }

            // report a bug
            TabButton {
                anchors.horizontalCenter: parent.horizontalCenter
                checkable: false
                width: parent.width
                height: 40

                Label {
                    anchors.centerIn: parent
                    text: "REPORT A BUG"
                    color: uiParams.accentColor
                }

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
                height: 40

                Label {
                    anchors.centerIn: parent
                    text: "CLOSE"
                    color: uiParams.accentColor
                }

                onClicked: {    aboutDialog.close() }
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
