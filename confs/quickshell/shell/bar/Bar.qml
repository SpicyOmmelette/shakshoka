// import QtQuick
import Quickshell
import QtQuick.Controls
import Quickshell.Wayland
import QtQuick
WlrLayershell {
	id: panel

	layer: WlrLayer.Bottom
	namespace: "Qtbar"
	keyboardFocus: WlrKeyboardFocus.None
	exclusiveZone: 50
	width: 50
	color: "transparent"
	anchors {
		bottom: true
		top: true
		right: true
	}
	ToolBar {
		id: mainBar
		width: 50 ; height: parent.height
		anchors {
			right: parent.right
		}
		WorkspaceWidget {
			id: workspace
			// width: parent.width ; height: 50
			anchors {
				top: parent.top
				horizontalCenter: parent.horizontalCenter
			}
		}
		//END
		VolumeWidget {
			id: volume
			anchors {
				bottom: network.top
				bottomMargin: 3
				horizontalCenter: parent.horizontalCenter
			}
		}
		NetworkWidget {
			id: network
			// width: 50
			anchors {
				bottom: clock.top
				bottomMargin: 3
				horizontalCenter: parent.horizontalCenter
			}
		}
		Notification {
			id: notification
			anchors {
				bottom: parent.bottom
				horizontalCenter: parent.horizontalCenter
			}
		}
		TimeWidget {
			id: clock
			// width: parent.width
			anchors {
				bottom: notification.top
				bottomMargin: 3
				horizontalCenter: parent.horizontalCenter
			}
		}
		//END

	}
	//END

}
