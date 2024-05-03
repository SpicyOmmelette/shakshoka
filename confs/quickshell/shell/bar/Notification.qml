import QtQuick.Controls
import QtQuick
import ".."
Item {
    id: root
    width: parent.width ; height: notificationButton.height
    ToolButton {
        id: notificationButton
        anchors.fill: parent
        icon.name: "notification-inactive"
        hoverEnabled: true
        icon.width: 50
        icon.height: 30
        onClicked: Ipc.hyprIpc("dispatch exec swaync-client -t")
        // onClicked: popup.visible = !popup.visible
    }
}
