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

	function _hextorgba(hex, alpha) {
		let cleanHex = hex.replace("#","");

		let r = parseInt(cleanHex.substring(0,2), 16);
		let g = parseInt(cleanHex.substring(2,4), 16);
		let b = parseInt(cleanHex.substring(4,6), 16);

		return Qt.rgba(r / 255, g / 255, b / 255, alpha)
	}


	component EaseAnim: Behavior {
		NumberAnimation {
			duration: 250 * Config.style.animationMultiplier
			easing.type: Easing.OutCubic
		}
	}

	component ColorAnim: Behavior {
		ColorAnimation {
			duration: 250 * Config.style.animationMultiplier
		}
	}

	PanelWindow {
		id: midBar

		anchors.top: true
		margins.top: -1

		property int y: active ? -borderWidth / 2 : -height - borderWidth
		EaseAnim on y {}
		onYChanged: midBarVisual.requestPaint()
		property int x: 0

		property int xStart: (screen.width / 2) - (width / 2)
		property int xEnd: (screen.width / 2) + (width / 2)
		
		implicitWidth: screen.width * Config.style.midSizePrc
		implicitHeight: Config.style.panelHeightPx + borderWidth
		property real slant: Config.style.panelSlantPx
		onSlantChanged: midBarVisual.requestPaint()

		property real visualWidth: width
		onVisualWidthChanged: midBarVisual.requestPaint()
		property real visualHeight: height
		onVisualHeightChanged: midBarVisual.requestPaint()

		exclusiveZone: ExclusionMode.Ignore
		property real borderWidth: Config.style.borderWidth
		onBorderWidthChanged: midBarVisual.requestPaint()

		color: "transparent"

		Item {
			id: midBarColors

			property color fg: Config.colors.foreground
			ColorAnim on fg {}
			onFgChanged: midBarVisual.requestPaint()

			property color bg: root._hextorgba(Config.colors.background, Config.style.backgroundOpacity)
			ColorAnim on bg {}
			onBgChanged: midBarVisual.requestPaint()

			property color br: Config.colors.border
			ColorAnim on br {}
			onBrChanged: midBarVisual.requestPaint()
		}

		property bool active: false
		property bool visible: true

		Canvas {
			id: midBarVisual

			anchors.fill: parent

			onPaint: {
				var ctx = getContext("2d");
				ctx.reset();
				ctx.moveTo(midBar.x, midBar.y);
				ctx.lineTo(midBar.x + midBar.slant, midBar.y + midBar.visualHeight);
				ctx.lineTo(midBar.x + midBar.visualWidth - midBar.slant, midBar.y + midBar.visualHeight);
				ctx.lineTo(midBar.x + midBar.visualWidth, midBar.y);
				ctx.closePath();
		    
				ctx.fillStyle = midBarColors.bg;
				ctx.fill();
		    
				ctx.strokeStyle = midBarColors.br
				ctx.lineWidth = midBar.borderWidth
				ctx.stroke();
			}
		}

		Timer {
			interval: 500
			running: true 
			repeat: true
			onTriggered: {
				midBar.active = true
			}
		}

		Rectangle {
			id: midBarTextSpace

			x: midBar.x + midBar.slant
			y: midBar.y

			width: midBar.visualWidth - ( midBar.slant * 2 )
			height: midBar.visualHeight - midBar.borderWidth
			property int fontSize: height / 2

			color: "transparent"

			Text {
				id: midBarTextField
				width: parent.width

				anchors.fill: parent
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter

				color: midBarColors.fg
				font.family: Config.style.font
				font.pixelSize: parent.fontSize

				elide: Text.ElideLeft

				text: TimeProcess.time
			}
		}
	}

	PanelWindow {
		id: leftBar

		anchors.top: true
		anchors.left: true
		margins.top: -1

		property int y: active ? -borderWidth / 2 : -height - borderWidth
		EaseAnim on y {}
		onYChanged: leftBarVisual.requestPaint()
		property int x: Math.min(Math.max(screen.width * Config.style.sideMarginPrc, midBar.xStart - (midBar.visualWidth * Config.style.periphSizePrc)), midBar.xStart - (slant * 2))
		onXChanged: leftBarVisual.requestPaint()
		
		implicitWidth: midBar.xStart
		implicitHeight: Config.style.panelHeightPx
		property real slant: Config.style.panelSlantPx
		onSlantChanged: leftBarVisual.requestPaint()

		property real visualWidth: midBar.xStart - leftBar.x
		onVisualWidthChanged: leftBarVisual.requestPaint()
		property real visualHeight: height
		onVisualHeightChanged: leftBarVisual.requestPaint()

		exclusiveZone: ExclusionMode.Ignore
		property real borderWidth: Config.style.borderWidth
		onBorderWidthChanged: leftBarVisual.requestPaint()

		color: "transparent"
		Item {
			id: leftBarColors

			property color fg: Config.colors.foreground
			ColorAnim on fg {}
			onFgChanged: leftBarVisual.requestPaint()

			property color bg: root._hextorgba(Config.colors.background, Config.style.backgroundOpacity)
			ColorAnim on bg {}
			onBgChanged: leftBarVisual.requestPaint()

			property color br: Config.colors.border
			ColorAnim on br {}
			onBrChanged: leftBarVisual.requestPaint()
		}

		property bool active: false
		property bool visible: true

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
				ctx.lineTo(leftBar.x + leftBar.visualWidth, leftBar.y + leftBar.visualHeight);
				ctx.lineTo(leftBar.x + leftBar.visualWidth - leftBar.slant, leftBar.y);
				ctx.closePath();
		    
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
		anchors.right: true
		margins.top: -1

		property int y: active ? 0 : -height - borderWidth
		EaseAnim on y {}
		onYChanged: rightBarVisual.requestPaint()
		property int x: 0
		
		implicitWidth: screen.width - midBar.xEnd
		implicitHeight: Config.style.panelHeightPx
		property real slant: Config.style.panelSlantPx
		onSlantChanged: rightBarVisual.requestPaint()

		property real visualWidth: Math.min(midBar.visualWidth * Config.style.periphSizePrc, Math.max(width - (screen.width * Config.style.sideMarginPrc), slant * 2))
		onVisualWidthChanged: rightBarVisual.requestPaint()
		property real visualHeight: height
		onVisualHeightChanged: rightBarVisual.requestPaint()

		exclusiveZone: ExclusionMode.Ignore
		property real borderWidth: Config.style.borderWidth
		onBorderWidthChanged: rightBarVisual.requestPaint()

		color: "transparent"
		Item {
			id: rightBarColors

			property color fg: Config.colors.foreground
			ColorAnim on fg {}
			onFgChanged: rightBarVisual.requestPaint()

			property color bg: root._hextorgba(Config.colors.background, Config.style.backgroundOpacity)
			ColorAnim on bg {}
			onBgChanged: rightBarVisual.requestPaint()

			property color br: Config.colors.border
			ColorAnim on br {}
			onBrChanged: rightBarVisual.requestPaint()
		}

		property bool active: false
		property bool visible: true

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
				ctx.closePath();
		    
				ctx.fillStyle = leftBarColors.bg;
				ctx.fill();
		    
				ctx.strokeStyle = leftBarColors.br
				ctx.lineWidth = leftBar.borderWidth
				ctx.stroke();
			}
		}
	}

}
