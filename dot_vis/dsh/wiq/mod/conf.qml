pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: config

	readonly property string homeDir: Quickshell.env("HOME")
	readonly property string configDir: Quickshell.env("WIQ_CONFIG") || (Quickshell.env("XDG_CONFIG_HOME") || (homeDir + "/.config")) + "/wiq"

	property var dat: ({})
	property var inc: []

	property var includeFile: FileView {
		path: config.configDir + "/include"
		preload: true
		watchChanges: true
		onLoaded: config._include(text() || "")
		onFileChanged: reload()
	}

	Instantiator {
		id: confInst
		model: config.inc

		delegate: FileView {
			required property var modelData

			path: config.configDir + "/" + modelData
			preload: true
			watchChanges: true
			onLoaded: config._parse(text() || "")
			onFileChanged: reload()
		}
	}

	function _include(raw) {
		if (!raw) return
		try { config.inc = raw.split(/\r?\n/).filter(Boolean) } catch (e) {}
	}

	function _parse(raw) {
		if (!raw) return

		const oldDat = config.dat
		const newDat = JSON.parse(raw)

		try { config.dat = Object.assign({}, oldDat, newDat) } catch (e) {}
	}

	readonly property var colors: {
		"black": config.dat.colors?.black ?? "black",
		"red": config.dat.colors?.red ?? "red",
		"green": config.dat.colors?.green ?? "green",
		"yellow": config.dat.colors?.yellow ?? "yellow",
		"blue": config.dat.colors?.blue ?? "blue",
		"magenta": config.dat.colors?.magenta ?? "magenta",
		"cyan": config.dat.colors?.cyan ?? "cyan",
		"white": config.dat.colors?.white ?? "white",

		"gray": config.dat.colors?.gray ?? "gray",
		"brightRed": config.dat.colors?.brightRed ?? "red",
		"brightGreen": config.dat.colors?.brightGreen ?? "green",
		"brightYellow": config.dat.colors?.brightYellow ?? "yellow",
		"brightBlue": config.dat.colors?.brightBlue ?? "blue",
		"brightMagenta": config.dat.colors?.brightMagenta ?? "magenta",
		"brightCyan": config.dat.colors?.brightCyan ?? "cyan",
		"brightWhite": config.dat.colors?.brightWhite ?? "white",

		"background": config.dat.colors?.background ?? "black",
		"foreground": config.dat.colors?.foreground ?? "white",
		"cursor": config.dat.colors?.cursor ?? "white",
		"border": config.dat.colors?.border ?? "white"
	}

	readonly property var style: {
		"font": config.dat.style?.font ?? "terminus",
		"borderWidth": config.dat.style?.borderWidth ?? 2,
		"backgroundOpacity": config.dat.style?.backgroundOpacity ?? 1,
		"animationCurve": config.dat.style?.animationCurve ?? "easing",
		"animationMultiplier": config.dat.style?.animationMultiplier ?? 1,
		"sideMarginFrac": config.dat.style?.sideMarginFrac ?? 1
	}
}
