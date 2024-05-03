import QtQuick
import Quickshell

Image {
    id: root
    required property ShellScreen screen;
    property int index: Math.ceil(Math.random() * 2)
    source: "wallpapers/gruvbox/" + index
    // source: "wallpapers/wallpaper_" + Ipc.activeWorkspace + ".png" // different wallpaper for differnt workspaces
    asynchronous: true
    fillMode: Image.PreserveAspectCrop

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onClicked: (mouse) => {
             (mouse.button == Qt.RightButton) ? contextMenu.popup() : {}
        }
        // to close contextMenu when mouse gets away, there is probably a better way
        onPositionChanged: (mouse) => {
            (contextMenu.opened && (Math.abs(mouse.x - (contextMenu.x + contextMenu.width / 2)) >= 250 || Math.abs(mouse.y - (contextMenu.y + contextMenu.height / 2)) >= 200)) ? contextMenu.close() : {}
        }
    }
    //END

    ContextMenu {
        id: contextMenu
        width: parent.width * 1/7
    }

    // ClockWidget {
    //     anchors {
    //         horizontalCenter: parent.horizontalCenter
    //         top: parent.top
    //         topMargin: 350
    //     }
    // }

    Timer {
        id: timer
        running: true
        repeat: true
        interval: 900000 //15 minutes
        onTriggered: {
            index = randomIndex(index)
        }
    }

    // next wallpaper but still sucks
    function nextIndex(index) {
        if (index == 2) {
            return 1
        }
        return index += 1
    }
    // random wallpapers 'sucks'
    function randomIndex(index) {
        var newIndex = Math.ceil(Math.random() * 2);
        return (newIndex == index ) ? updateIndex(index) : newIndex;
    }
}
