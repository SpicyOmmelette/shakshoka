// All credits goes to KDE's amazing devs
import QtQuick
import QtQuick.Controls
import org.kde.plasma.networkmanagement as PlasmaNM
Item {
    id: root
    width: parent.width ; height: networkButton.height

    PlasmaNM.NetworkStatus {
        id: networkStatus
    }
    PlasmaNM.ConnectionIcon {
        id: connectionIconProvider
        connectivity: networkStatus.connectivity
    }
    ToolButton {
        id: networkButton
        anchors.fill: parent
        icon.name: connectionIconProvider.connectionIcon
        hoverEnabled: true
        icon.width: 50
        icon.height: 30
        ToolTip.delay: 300
        ToolTip.visible: hovered
        ToolTip.text: networkStatus.activeConnections
    }
}
