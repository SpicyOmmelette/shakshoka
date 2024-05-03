import QtQuick
import QtQuick.Controls
import Quickshell
import ".."
Item {
    id: root

    Column {
        spacing: 1
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }
        Repeater {

            model: ["I", "II", "III","IV","V","VI","VII","VIII"]
            Button {
                required property int index
                required property string modelData
                width: 45 /*; height: 45*/
                text: modelData
                hoverEnabled: true
                checked: (Ipc.activeWorkspace == (index + 1)) ? true : false
                onClicked: Ipc.hyprIpc("dispatch workspace " + (index + 1))
            }
        }
        Button {
            text: Ipc.activeWorkspace
            width: 45 /*; height: 45*/
            hoverEnabled: false
            visible: (Ipc.activeWorkspace > 8) ? true : false
            // onClicked: Qt.quit() // >:)
        }
    }
    //END
}
//END
