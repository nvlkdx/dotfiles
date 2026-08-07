import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import ".."
import "../proc"

Scope {
	id: root
	
	property real panelWidthFrac: 4
	property real panelHeight: 42
	property real panelSlant: 36

	property var loConf: {
		"col": {
			"br": Config.colors.border,
			"bg": _hextorgba(Config.colors.background, Config.style.backgroundOpacity),
			"fg": Config.colors.foreground,
			"cr": Config.colors.cursor,

			"c0": Config.colors.black,
			"c1": Config.colors.red,
			"c2": Config.colors.green,
			"c3": Config.colors.yellow,
			"c4": Config.colors.blue,
			"c5": Config.colors.magenta,
			"c6": Config.colors.cyan,
			"c7": Config.colors.white,

			"c8": Config.colors.gray,
			"c9": Config.colors.brightRed,
			"ca": Config.colors.brightGreen,
			"cb": Config.colors.brightYellow,
			"cc": Config.colors.brightBlue,
			"cd": Config.colors.brightMagenta,
			"ce": Config.colors.brightCyan,
			"cf": Config.colors.brightWhite
		},
		"stl": {
			"fnt": Config.style.font,
			"brw": Config.style.borderWidth,
			"anm": Config.style.animationMultiplier,
			"smf": Config.style.sideMarginFrac
		}
	}		

	function _hextorgba(hex, alpha) {
		let cleanHex = hex.replace("#","");

		let r = parseInt(cleanHex.substring(0,2), 16);
		let g = parseInt(cleanHex.substring(2,4), 16);
		let b = parseInt(cleanHex.substring(4,6), 16);

		return Qt.rgba(r / 255, g / 255, b / 255, alpha)
	}


	component EaseAnim: Behavior {
		NumberAnimation {
			duration: 250 * root.loConf.stl.anm
			easing.type: Easing.OutCubic
		}
	}

	component ColorAnim: Behavior {
		ColorAnimation {
			duration: 250 * root.loConf.stl.anm
		}
	}

	PanelWindow {
		id: midBar

		anchors.top: true
		margins.top: -1

		property int y: active ? 0 : -height-(loConf.stl.brw * 2)
		EaseAnim on y {}
		onYChanged: midBarVisual.requestPaint()
		property int x: ( width - visualWidth ) / 2
		EaseAnim on x {}
		onXChanged: midBarVisual.requestPaint()
		
		implicitWidth: screen.width
		implicitHeight: root.panelHeight
		property real slant: root.panelSlant

		property real visualWidth: screen.width / root.panelWidthFrac
		property real visualHeight: height

		exclusiveZone: ExclusionMode.Ignore
		property real borderWidth: root.loConf.stl.brw
		EaseAnim on borderWidth {}
		onBorderWidthChanged: midBarVisual.requestPaint()

		color: "transparent"

		Item {
			id: midBarColors

			property color fg: root.loConf.col.fg
			ColorAnim on fg {}
			onFgChanged: midBarVisual.requestPaint()

			property color bg: root.loConf.col.bg
			ColorAnim on bg {}
			onBgChanged: midBarVisual.requestPaint()

			property color br: root.loConf.col.br
			ColorAnim on br {}
			onBrChanged: midBarVisual.requestPaint()
		}

		enum Status {
			Hidden,
			Visible,
			Active
		}

		property bool active: false

		Timer {
			interval: 500
			running: true 
			repeat: true
			onTriggered: {
				midBar.active = true
			}
		}

		Canvas {
			id: midBarVisual

			anchors.fill: parent

			onPaint: {
				var ctx = getContext("2d");
				ctx.reset();
				ctx.moveTo(midBar.x + midBar.borderWidth, midBar.y);
				ctx.lineTo(midBar.x + midBar.slant, midBar.y + midBar.height);
				ctx.lineTo(midBar.x + midBar.visualWidth - midBar.slant, midBar.y + midBar.height);
				ctx.lineTo(midBar.x + midBar.visualWidth - midBar.borderWidth, midBar.y);
		    
				ctx.fillStyle = midBarColors.bg;
				ctx.fill();
		    
				ctx.strokeStyle = midBarColors.br
				ctx.lineWidth = midBar.borderWidth
				ctx.stroke();
			}
		}

		Rectangle {
			id: midBarTextSpace

			x: midBar.x + midBar.slant
			y: midBar.y

			property int fontSize: midBar.visualHeight / 2
			width: midBar.visualWidth - ( midBar.slant * 2 )
			height: midBar.visualHeight

			color: "transparent"

			Text {
				id: midBarTextField
				width: parent.width

				anchors.fill: parent
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter

				color: midBarColors.fg
				font.family: root.loConf.stl.fnt
				font.pixelSize: parent.fontSize

				elide: Text.ElideLeft

				text: TimeProcess.time
			}
		}
	}

	PanelWindow {
		id: leftBar

		anchors.top: true
		margins.top: -1

		property int y: active ? 0 : -height-(loConf.stl.brw * 2)
		EaseAnim on y {}
		onYChanged: leftBarVisual.requestPaint()
		property int x: midBar.visualWidth / root.loConf.stl.smf 
		EaseAnim on x {}
		onXChanged: leftBarVisual.requestPaint()
		
		implicitWidth: screen.width
		implicitHeight: root.panelHeight
		property real slant: root.panelSlant

		property real visualWidth: midBar.x
		EaseAnim on visualWidth {}
		onVisualWidthChanged: leftBarVisual.requestPaint()
		property real visualHeight: height
		EaseAnim on visualHeight {}
		onVisualHeightChanged: leftBarVisual.requestPaint()

		exclusiveZone: ExclusionMode.Ignore
		property real borderWidth: root.loConf.stl.brw
		EaseAnim on borderWidth {}
		onBorderWidthChanged: leftBarVisual.requestPaint()

		color: "transparent"
		Item {
			id: leftBarColors

			property color fg: root.loConf.col.fg
			ColorAnim on fg {}
			onFgChanged: leftBarVisual.requestPaint()

			property color bg: root.loConf.col.bg
			ColorAnim on bg {}
			onBgChanged: leftBarVisual.requestPaint()

			property color br: root.loConf.col.br
			ColorAnim on br {}
			onBrChanged: leftBarVisual.requestPaint()
		}

		enum Status {
			Hidden,
			Visible,
			Active
		}

		property bool active: false

		Timer {
			interval: 1000
			running: true 
			repeat: true
			onTriggered: {
				leftBar.active = true
			}
		}

		Canvas {
			id: leftBarVisual

			anchors.fill: parent

			onPaint: {
				var ctx = getContext("2d");
				ctx.reset();
				ctx.moveTo(leftBar.x, leftBar.y);
				ctx.lineTo(leftBar.x + leftBar.slant, leftBar.y + leftBar.visualHeight);
				ctx.lineTo(leftBar.visualWidth, leftBar.y + leftBar.visualHeight);
				ctx.lineTo(leftBar.visualWidth - leftBar.slant, leftBar.y);
		    
				ctx.fillStyle = leftBarColors.bg;
				ctx.fill();
		    
				ctx.strokeStyle = leftBarColors.br
				ctx.lineWidth = leftBar.borderWidth
				ctx.stroke();
			}
		}
	}

	PanelWindow {
		id: rightBar

		anchors.top: true
		margins.top: -1

		property int y: active ? 0 : -height-(loConf.stl.brw * 2)
		EaseAnim on y {}
		onYChanged: rightBarVisual.requestPaint()
		property int x: midBar.x + midBar.visualWidth
		EaseAnim on x {}
		onXChanged: rightBarVisual.requestPaint()
		
		implicitWidth: screen.width
		implicitHeight: root.panelHeight
		property real slant: root.panelSlant
		property real visualWidth: width - ( midBar.x + midBar.visualWidth + ( midBar.visualWidth / root.loConf.stl.smf ) )
		EaseAnim on visualWidth {}
		onVisualWidthChanged: rightBarVisual.requestPaint()
		property real visualHeight: height
		EaseAnim on visualHeight {}
		onVisualHeightChanged: rightBarVisual.requestPaint()

		exclusiveZone: ExclusionMode.Ignore
		property real borderWidth: root.loConf.stl.brw
		EaseAnim on borderWidth {}
		onBorderWidthChanged: rightBarVisual.requestPaint()

		color: "transparent"
		Item {
			id: rightBarColors

			property color fg: root.loConf.col.fg
			ColorAnim on fg {}
			onFgChanged: rightBarVisual.requestPaint()

			property color bg: root.loConf.col.bg
			ColorAnim on bg {}
			onBgChanged: rightBarVisual.requestPaint()

			property color br: root.loConf.col.br
			ColorAnim on br {}
			onBrChanged: rightBarVisual.requestPaint()
		}

		enum Status {
			Hidden,
			Visible,
			Active
		}

		property bool active: false

		Timer {
			interval: 1000
			running: true 
			repeat: true
			onTriggered: {
				rightBar.active = true
			}
		}

		Canvas {
			id: rightBarVisual

			anchors.fill: parent

			onPaint: {
				var ctx = getContext("2d");
				ctx.reset();
				ctx.moveTo(rightBar.x + rightBar.slant, rightBar.y);
				ctx.lineTo(rightBar.x, rightBar.y + rightBar.visualHeight);
				ctx.lineTo(rightBar.x + rightBar.visualWidth - rightBar.slant, rightBar.y + rightBar.visualHeight);
				ctx.lineTo(rightBar.x + rightBar.visualWidth, rightBar.y);
		    
				ctx.fillStyle = leftBarColors.bg;
				ctx.fill();
		    
				ctx.strokeStyle = leftBarColors.br
				ctx.lineWidth = leftBar.borderWidth
				ctx.stroke();
			}
		}
	}

}
