import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import CustomControls 1.0
import Process 1.0

Item {
    id: root

    property int func: {
        isRunning.start("tractor isrunning")
        return 0
    }

    //color: "#0d0724"
    Text {
        id: countryName

        text: qsTr("Auto (Best)")
        color: "#FAFAFA"
        anchors.left: countryImage.right
        anchors.leftMargin: 10
        anchors.verticalCenter: countryImage.verticalCenter
    }

    Image {
        id: countryImage

        source: "qrc:/Icons/speed.png"
        width: 35
        height: 35
        anchors.right: parent.right
        anchors.rightMargin: 140
        anchors.top: parent.top
        anchors.topMargin: 30


        MouseArea {
            id: countryImageMouse

            anchors.fill: parent
            onClicked: countryPopup.open()
        }

        Popup {
            id: countryPopup

            Material.theme: Material.Light
            //x: -325
            x: (-1) * (root.width / 2 - 75)
            y: 0
            width: 200
            height: 350
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
                        countryAnim.start()
                        countryPopup.close()
                    }
                }

                model: ListModel {
                    ListElement { title: "Auto (Best)"; icon: "qrc:/Icons/speed.png"; code: "ww"}
                    ListElement { title: "Austria"; icon: "qrc:/Icons/austria.png"; code: "au"}
                    ListElement { title: "Canada"; icon: "qrc:/Icons/canada.png"; code: "ca" }
                    ListElement { title: "Finland"; icon: "qrc:/Icons/finland.png"; code: "fi" }
                    ListElement { title: "France"; icon: "qrc:/Icons/france.png"; code: "fr" }
                    ListElement { title: "Germany"; icon: "qrc:/Icons/germany.png"; code: "de" }
                    ListElement { title: "Netherlands"; icon: "qrc:/Icons/netherlands.png"; code: "nl" }
                    ListElement { title: "Norway"; icon: "qrc:/Icons/norway.png"; code: "no" }
                    ListElement { title: "Poland"; icon: "qrc:/Icons/poland.png"; code: "pl" }
                    ListElement { title: "Romania"; icon: "qrc:/Icons/romania.png"; code: "ro" }
                    ListElement { title: "Spain"; icon: "qrc:/Icons/spain.png"; code: "es" }
                    ListElement { title: "Sweden"; icon: "qrc:/Icons/sweden.png"; code: "se" }
                    ListElement { title: "Switzerland"; icon: "qrc:/Icons/switzerland.png"; code: "ch" }
                    ListElement { title: "Ukraine"; icon: "qrc:/Icons/ukraine.png"; code: "ua" }
                    ListElement { title: "United Kingdom"; icon: "qrc:/Icons/united-kingdom.png"; code: "uk" }
                }
            }
        }
    }

    Rectangle {
        id: indicatorCircle

        color: "transparent"
        border.width: 2
        border.color: "#33EEEEEE"
        anchors.centerIn: parent
        width: 190
        height: 190
        radius: 190
        opacity: {
            if (bar.value == 0)
                return 1
            else
                return 0
        }
    }



    RadialBar {
        id: bar

        anchors.centerIn: parent
        width: 200
        height: 200
        penStyle: Qt.RoundCap
        dialType: RadialBar.FullDial
        progressColor: "#FF5722"
        foregroundColor: "#191a2f"
        dialWidth: 15
        startAngle: 0
        spanAngle: 70
        minValue: 0
        maxValue: 100
        value: {
            if (bootstrapText.text == "Tractor is Connected.")
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
        //textColor: "#00FAFAFA"
        textColor: {
            if (value == 100 || value == 0)
                return "#00FAFAFA"
            else
                return "#FFFAFAFA"
        }

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
                if (parent.value == 100)
                    return "CONNECTED"
                else
                    return "CONNECT"
            }

            color: "#FAFAFA"

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
            id: disconnectText

            anchors.centerIn: parent
            anchors.verticalCenterOffset: 30
            color: "#FAFAFA"
            text: "Click To Disconnect"
            font.pointSize: 10
            opacity: {
                if (parent.value == 100)
                    return 1
                else
                    return 0
            }
        }

        MouseArea {
            id: barMouseArea
            anchors.fill: parent

            hoverEnabled: true

            onClicked: {
                //progressAnim.enabled = true
                if (parent.value == 0){
                    processStart.start("tractor start")
                    //parent.value = 100

                } else {
                    processStop.start("tractor stop")
                    //parent.value = 0
                }
                //progressAnim.enabled = false
            }
        }
    }

    Text {
        id: bootstrapText

        //visible: false
        //width: root.width - 200
        height: 15
        clip: true
        anchors.top: bar.bottom
        anchors.topMargin: 25
        anchors.horizontalCenter: root.horizontalCenter
        color: {
            if (text == "Tractor is not Connected." || text == "Tractor stopped")
                return "#ff1744"
            else
                return "#1DE9B6"
        }

        text: ""
        font.family: ubuntuFontMono.name
        font.pointSize: 12
    }

    Process {
        id: processStart

        property string str: ""

        onStarted: {
            progressAnim.enabled = true
        }

        onFinished: {
            progressAnim.enabled = false
        }

        //onReadyReadStandardOutput: bootstrapText.text = readAll()
        onReadyReadStandardOutput: {
            str = readAll()
            if (str.includes("Tractor"))
                bootstrapText.text = str.slice(7, str.length - 5)
            else {
                bootstrapText.text = str.slice(5, str.length - 5)
                if (str.includes("Bootstrapped")) {
                    bar.value = parseInt(str.slice(str.indexOf("Bootstrapped") + 13, str.indexOf("%")))
                }
            }
        }
    }

    Process {
        id: processStop

        property string str: ""
        //onReadyReadStandardOutput: bootstrapText.text = readAll()
        onReadyReadStandardOutput: {
            str = readAll()
            if (str.includes("Tractor"))
                bootstrapText.text = str.slice(7, str.length - 5)
            else
                bootstrapText.text = str.slice(5, str.length - 5)
        }

        onFinished: {
            if (bootstrapText.text == "Tractor stopped")
                bar.value = 0
        }
    }

    Process {
        id: isRunning

        onFinished: {
            bootstrapText.opacity = 1
            if (bootstrapText.text.includes("True"))
                bootstrapText.text = "Tractor is Connected."
            else {
                bootstrapText.text = "Tractor is not Connected."
            }
        }

        onReadyReadStandardOutput: bootstrapText.text = readAll()
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
            from: 190
            to: 300
            duration: 2000
            easing.type: "InQuint"
        }

        NumberAnimation {
            target: indicatorCircle
            property: "height"
            from: 190
            to: 300
            duration: 2000
            easing.type: "InQuint"
        }

        ColorAnimation {
            target: indicatorCircle
            property: "border.color"
            from: "#55EEEEEE"
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

    SequentialAnimation {
        id: barTextColorAnim

        running: {
            if (bar.value == 0 && barMouseArea.containsMouse)
                return true
            else
                return false
        }

        loops: Animation.Infinite

        onStarted: {
            barText.font.pointSize = 18
            indicatorAnim.stop()
        }

        onStopped: {
            barText.font.pointSize = 16
            barText.color = "#FAFAFA"
            indicatorAnim.start()
        }

        ColorAnimation {
            target: barText
            property: "color"
            from: "#673AB7"
            to: "#FF5722"
            duration: 800
            easing.type: "InOutCubic"
        }

        ColorAnimation {
            target: barText
            property: "color"
            from: "#FF5722"
            to: "#673AB7"
            duration: 800
            easing.type: "InOutCubic"
        }
    }
    // , , , , , , , , , , , , , , , , , , , ,
}
