import QtQuick 2.4

Item {
  readonly property string foregroundColor: "#fafafa"
  readonly property string backgroundColor: "#191919"
  readonly property string accentColor: "#E91E63"
  readonly property string splitColor: "#303030"
  readonly property string overlayColor: "#99000000"

  property alias fonts: fontItem

  // fonts
  Item {
    id: fontItem

    property font headingOne		    // for headers
    property font headingTwo		    // for headers
    property font headingCondensed	// for titles
    property font paragraph			    // for normal text
    property font small				      // for showing small text like some errors
    property font codeblock			    // for codes

    Component.onCompleted: {
      // Declaration fonts
      headingOne.family = ubuntuFont.name
      headingOne.weight = Font.Light
      headingOne.capitalization = Font.MixedCase
      headingOne.pixelSize = 24

      headingTwo.family = ubuntuFont.name
      headingTwo.capitalization = Font.MixedCase
      headingTwo.weight = Font.Light
      headingTwo.pixelSize = 20

      headingCondensed.family = ubuntuFontCondensed.name
      headingCondensed.capitalization = Font.MixedCase
      headingCondensed.weight = Font.Light
      headingCondensed.pixelSize = 24
      headingCondensed.bold = true

      paragraph.family = ubuntuFont.name
      paragraph.capitalization = Font.MixedCase
      paragraph.weight = Font.Light
      paragraph.pixelSize = 16

      small.family = ubuntuFont.name
      small.weight = Font.Light
      small.capitalization = Font.MixedCase
      small.pixelSize = 12

      codeblock.family = ubuntuFontMono.name
      codeblock.capitalization = Font.MixedCase
      codeblock.pixelSize = 18
    }

    // ubuntu font
    FontLoader {
      id: ubuntuFont
      source: "qrc:/fonts/Ubuntu-R.ttf"
    }

    // ubuntu medium
    FontLoader { source: "qrc:/fonts/Ubuntu-M.ttf" }

    // ubuntu bold
    FontLoader { source: "qrc:/fonts/Ubuntu-B.ttf" }

    // ubuntu mono
    FontLoader {
      id: ubuntuFontMono
      source: "qrc:/fonts/UbuntuMono-R.ttf"
    }

    // ubuntu condensed
    FontLoader {
      id: ubuntuFontCondensed
      source: "qrc:/fonts/Ubuntu-C.ttf"
    }
  }
}
