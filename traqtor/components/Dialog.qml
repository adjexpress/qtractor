import QtQuick                    2.4
import QtQuick.Controls           2.4
import QtQuick.Controls.impl      2.4
import QtQuick.Controls.Material  2.4

Dialog {
    id: dlg

    property var rootItem

    x: (rootItem.width - width) / 2
    y: (rootItem.height - height) / 2 - 32

    width: contentWidth + leftPadding + rightPadding
    height: contentHeight + topPadding + bottomPadding +
            (header && header.visible ? header.height : 0) +
            (footer && footer.visible ? footer.height : 0)

    contentWidth: (contentChildren.length >= 1 ? contentChildren[0].width : 0)
    contentHeight: (contentChildren.length >= 1 ? contentChildren[0].height : 0)

    title: "Title"
    clip: true
    modal: true

    Overlay.modal: Rectangle {
      color: "#99000000"
      Behavior on opacity { NumberAnimation {  duration: 150 } }
    }

    Overlay.modeless: Rectangle {
      color: "#99000000"
      Behavior on opacity { NumberAnimation {  duration: 150 } }
    }

    header: Label {
      UIParameters { id: uiPrm }

      text: dlg.title
      visible: dlg.title
      elide: Label.ElideLeft
      topPadding: 18
      leftPadding: dlg.leftPadding
      rightPadding: dlg.rightPadding
      font: uiPrm.fonts.headingTwo
    }
}

