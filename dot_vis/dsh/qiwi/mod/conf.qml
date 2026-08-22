pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: config

	readonly property string homeDir: Quickshell.env("HOME")
	readonly property string configDir: Quickshell.env("QIWI_CONFIG") || (Quickshell.env("XDG_CONFIG_HOME") || (homeDir + "/.config")) + "/qiwi"

	property var dat: ({})
	property var inc: []

	FileView {
		path: config.configDir + "/include"
		preload: true
		watchChanges: true
		onLoaded: config._include(text() || "")
		onFileChanged: reload()
		printErrors: false
	}

	Instantiator {
		id: confInst
		model: !config.inc || config.inc.length === 0 ? ["config.json"] : config.inc

		delegate: FileView {
			path: config.configDir + "/" + modelData
			preload: true
			watchChanges: true
			onLoaded: config._parse(text() || "")
			onFileChanged: reload()
			printErrors: false
		}
	}

	function _include(raw) {
		if (!raw) return
		try { config.inc = raw.split(/\r?\n/).filter(Boolean) } catch (e) {}
	}

	function _parse(raw) {
		if (!raw) return
		try { config.dat = Object.assign({}, config.dat, JSON.parse(raw)) } catch (e) {}
	}

	function _clamp(val, min, max) {
		return Math.max(min, Math.min(max, val))
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

		"background": config.dat.colors?.background ?? "#000000",
		"foreground": config.dat.colors?.foreground ?? "white",
		"cursor": config.dat.colors?.cursor ?? "white",
		"border": config.dat.colors?.border ?? "white"
	}

	readonly property var style: {
		"font": config.dat.style?.font ?? "terminus",
		"borderWidth": config.dat.style?.borderWidth ?? 2,
		"backgroundOpacity": config._clamp(config.dat.style?.backgroundOpacity, 0, 1) ?? 1,
		"animationSlowdown": Math.max(0, config.dat.style?.animationSlowdown) ?? 1,
		"periphSizePrc": Math.max(0, config.dat.style?.periphSizePrc) ?? 0.5,
		"midSizePrc": config._clamp(config.dat.style?.midSizePrc, 0, 1) ?? 0.25,
		"sideMarginPrc": config._clamp(config.dat.style?.sideMarginPrc, 0, 1) ?? 0,
		"panelHeightPx": config.dat.style?.panelHeightPx ?? 42,
		"panelSlantPx": config.dat.style?.panelSlantPx ?? 36
	}
}
