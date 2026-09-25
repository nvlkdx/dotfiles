import Quickshell
import QtQuick
import "mod"
import "mod/bars"
import "mod/lock"
import "mod/drun"
import "mod/proc"

ShellRoot {
	id: root

	Variants {
		model: Quickshell.screens
		TopBar {
			property var modelData
			screen: modelData
		}
	}
}
