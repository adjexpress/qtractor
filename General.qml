import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import CustomControls 1.0
import Process 1.0
import Gsettings 1.0

Item {
    id: root

    property string exitNode: "ww"
    property int initial: {
        isRunning.start("tractor isrunning")
        dconf.settingNew()
        exitNode = dconf.getStringValue("exit-node")
        acceptConnectionDelegate.checked = dconf.getBoolValue("accept-connection")
        return 0
    }
    property Qgsettings tractorConf: dconf

    //property alias conf: dconf

    Rectangle {
        id: header

        Material.theme: Material.Light
        anchors.top: root.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5
        height: 46
        color : "#20FFFFFF"
        radius: 22
//        color: "transparent"

//        Rectangle {
//            height: 0.5
//            width: parent.width - 30
//            anchors.bottom: parent.bottom
//            anchors.horizontalCenter: parent.horizontalCenter
//            color: "#509E9E9E"
//        }

        Text {
            text: qsTr("Exit node:")
            font.pointSize: 13
            font.weight: Font.Medium
//            anchors.top: countryImage.top
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: countryImage.right
            anchors.leftMargin: 10
            color: "#9E9E9E"
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
            font.pointSize: 13
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
            anchors.leftMargin: 15
//            anchors.top: parent.top
//            anchors.topMargin: 7.5
            anchors.verticalCenter: parent.verticalCenter

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
                /*background: Rectangle {
                    border.color: "#00C853"
                    color: "#00C853"
                }*/
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                ListView {
                    id: countryList

                    focus: true
                    anchors.fill: parent
                    clip: true

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
                            if (tractorCondition.text == "Tractor is connected.") {
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
                        ListElement { title: "Russia"; icon: "qrc:/Icons/russia.png"; code: "su" }
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

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    onClicked: countryPopup.open()
                }
            }
        }


    }

    SwitchDelegate {
        id: acceptConnectionDelegate

        Material.accent: "#F50057"
        anchors.top: header.bottom
        anchors.topMargin: 5
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

        width: 195
        height: 195
        anchors.centerIn: parent
        color: "transparent"

        // animated Rectangle
        Rectangle {
            id: indicatorCircle

            color: "transparent"
            border.width: 1
            border.color: "#E91E63"
            anchors.centerIn: bar
            width: 192
            height: 192
            radius: 192
            opacity: {
                if (bar.value == 0)
                    return 1
                else
                    return 0
            }
        }

        Rectangle {
            id: barForground

            width: 190
            height: 190
            radius: 190
            border.width: 8
            border.color: "#191a2f"
            color: "transparent"
            anchors.centerIn: parent
        }

        // - - - - circular bar - - - -
        RadialBar {
            id: bar

            anchors.centerIn: parent
            width: 195
            height: 195
            penStyle: Qt.RoundCap
            dialType: RadialBar.FullDial
    //        progressColor: "#FF5722"
            progressColor: "#E91E63"
            foregroundColor: "transparent"  // foreground declared seperatly.
            dialWidth: 13
            startAngle: 0
            spanAngle: 70
            minValue: 0
            maxValue: 100
            value: {
                if (tractorCondition.text == "Tractor is connected.")
                    return 100
                else
                    return 0
            }
            textFont {
                family: "Halvetica"
                italic: false
                pointSize: 16

            }
            suffixText: "%"
//            textColor: "#00FAFAFA"

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
                    if (parent.value == 100)
                        return "#E91E63"
                    else
                        return "#FAFAFA"
                }

                opacity: {
                    if (parent.value == 100 || parent.value == 0)
                        return 1
                    else
                        return 0
                }

                font.pointSize: 16
                font.bold: true

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
                anchors.verticalCenterOffset: -15
                property int s: 0
                property int ss: 0
                property int m: 0
                property int mm: 0
                property int h: 0
                property int hh: 0
                text: hh.toString() + h + ":" + mm + m + ":" + ss + s
                color: "white"
                font.weight: Font.Medium
                font.pointSize: 18
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

    //        Text {
    //            id: disconnectText

    //            anchors.centerIn: parent
    //            anchors.verticalCenterOffset: 30
    //            color: "#FAFAFA"
    //            text: "Click To Disconnect"
    //            font.pointSize: 10
    //            opacity: {
    //                if (parent.value == 100)
    //                    return 1
    //                else
    //                    return 0
    //            }
    //        }

            MouseArea {
                id: barMouseArea
                anchors.fill: parent

                hoverEnabled: true

                onClicked: {
                    //progressAnim.enabled = true
                    if (parent.value == 0){
                        //focus = false  // for animation
                        processStart.start("tractor start")

                        //parent.value = 100

                    } else if (parent.value == 100) {
                        //focus = false
                        processStop.start("tractor stop")
                        //parent.value = 0
                    } else { }
                }
            }
        }
        // , , , , , , , , , , , , , , ,

    }

    Rectangle {
        id: logTxtRec

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 170
        anchors.left: parent.left
        anchors.leftMargin: 15
        width: logTxt.width + arrow.width
        height: arrow.width
        color: "transparent"

        Text {
            id: logTxt

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            text: "Log"
            font.family: ubuntuFontMono.name
            font.pointSize: 14
            color: "white"
        }

        Image {
            id: arrow

            source: "/Icons/right.png"
            anchors.left: logTxt.right
            anchors.leftMargin: 5
            anchors.verticalCenter: logTxt.verticalCenter
            width: 16
            height: 16

            Behavior on rotation {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (arrow.rotation == 0) {
                    arrow.rotation += 90
                    bootstrapTextContainer.height = 150
                } else {
                    arrow.rotation = 0
                    bootstrapTextContainer.height = 0
                }
            }
        }
    }

    Rectangle {
        id: bootstrapTextContainer

        anchors.top: logTxtRec.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 15
//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 15
        height: 0
        color: "#FFFDE7"
        radius: 2

        Behavior on height {
            NumberAnimation {
                duration: 200
            }
        }

        ScrollView {
            anchors.fill: parent
//            anchors.margins: 1
            clip: true

            Behavior on height {
                NumberAnimation {
                    duration: 200
                }
            }

            TextArea {
                id: bootstrapText

                Material.theme: Material.Dark
                Material.foreground: "#212121"
                Material.accent: "transparent"
                font.pointSize: 12
                font.family: ubuntuFontMono.name
                readOnly: true
                wrapMode: "WrapAnywhere"
                cursorPosition: length - 5
            }
        }
    }

    Text {
        id: tractorCondition

        //visible: false
        //width: root.width - 200
        height: 17
        clip: true
        anchors.bottom: root.bottom
        anchors.bottomMargin: 25
        anchors.horizontalCenter: root.horizontalCenter
        color: {
            if (text == "Tractor is not Connected." || text == "Tractor stopped" ||
                    text.includes("Reached timeout.") || text == "Tractor is not connected.")
                return "#E91E63"
            else
                return "#64FFDA"
        }
        text: ""
        font.family: ubuntuFontMono.name
        font.pointSize: 12
        visible: false
    }

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
                    tractorCondition.text = "Tractor is connected."
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
            bootstrapText.text += tractorCondition.text + "\n"
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
            bootstrapText.text += tractorCondition.text + "\n"
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
                tractorCondition.text = "Tractor is connected."
            else {
                tractorCondition.text = "Tractor is not connected."
            }
            bootstrapText.text += tractorCondition.text + "\n"
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

    // - - - - stand alone animations - - - -
    ParallelAnimation {
        id: indicatorAnim

        running: {
            if (bar.value == 0)
                return true
            else
                return false
        }
        loops: Animation.Infinite

        onStopped: {
            indicatorCircle.width = 190
            indicatorCircle.height = 190
        }

        NumberAnimation {
            target: indicatorCircle
            property: "width"
            from: 180
            to: 260
            duration: 2000
            easing.type: "InQuint"
        }

        NumberAnimation {
            target: indicatorCircle
            property: "height"
            from: 180
            to: 260
            duration: 2000
            easing.type: "InQuint"
        }

        ColorAnimation {
            target: indicatorCircle
            property: "border.color"
            from: "#455A64"
            to: "transparent"
            duration: 2000
            easing.type: "InExpo"
        }

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

//    SequentialAnimation {
//        id: barTextColorAnim

//        running: {
//            if (bar.value == 0 && barMouseArea.containsMouse)
//                return true
//            else
//                return false
//        }

//        loops: Animation.Infinite

//        onStarted: {
//            barText.font.pointSize = 18
//            //indicatorAnim.stop()
//        }

//        onStopped: {
//            barText.font.pointSize = 16
//            barText.color = "#FAFAFA"
//            //indicatorAnim.start()
//        }

//        ColorAnimation {
//            target: barText
//            property: "color"
//            from: "#E91E63"
//            to: "#242542"
//            duration: 800
//            easing.type: "InOutCubic"
//        }

//        ColorAnimation {
//            target: barText
//            property: "color"
//            from: "#242542"
//            to: "#E91E63"
//            duration: 800
//            easing.type: "InOutCubic"
//        }
//    }
    // , , , , , , , , , , , , , , , , , , , ,
}
