import QtQuick                        2.4
import QtQuick.Controls               2.4
import QtQuick.Controls.impl          2.4
import QtQuick.Controls.Material      2.4
import QtQuick.Controls.Material.impl 2.4


SpinBox {
  id: control

  up.indicator: Item {
    x: control.mirrored ? 0 : parent.width - width
    implicitWidth: control.Material.touchTarget
    implicitHeight: control.Material.touchTarget
    height: parent.height
    width: height

    Ripple {
      clipRadius: 2
      x: control.spacing
      y: control.spacing
      width: parent.width - 2 * control.spacing
      height: parent.height - 2 * control.spacing
      pressed: control.up.pressed
      active: control.up.pressed || control.up.hovered || control.visualFocus
      color: control.Material.rippleColor
    }

    IconLabel {
      icon.source: "qrc:/icons/rightarrow.svg"
      anchors.centerIn: parent
      height: parent.height / 2
      width: height
      opacity: enabled ? 1 : 0.3
    }
  }

  down.indicator: Item {
    x: control.mirrored ? parent.width - width : 0
    implicitWidth: control.Material.touchTarget
    implicitHeight: control.Material.touchTarget
    height: parent.height
    width: height

    Ripple {
      clipRadius: 2
      x: control.spacing
      y: control.spacing
      width: parent.width - 2 * control.spacing
      height: parent.height - 2 * control.spacing
      pressed: control.down.pressed
      active: control.down.pressed || control.down.hovered || control.visualFocus
      color: control.Material.rippleColor
    }

    IconLabel {
      icon.source: "qrc:/icons/leftarrow.svg"
      anchors.centerIn: parent
      height: parent.height / 2
      width: height
      opacity: enabled ? 1 : 0.3
    }
  }

  textFromValue: function(value, locale) { return value }
}
