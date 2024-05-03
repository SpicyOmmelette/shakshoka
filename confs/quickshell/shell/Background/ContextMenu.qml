import QtQuick
import QtQuick.Controls

Menu {
    id: contextMenu
    padding: 5
    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0; to: 1.0
            duration: 150
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0; to: 0
            duration: 150
        }
    }
    MenuItem {
        text: "Firefox"
        icon.name: "firefox" // "internet-web-browser", for generci icon
        onClicked: Ipc.hyprIpc("dispatch exec firefox")
    }
    MenuItem {
        text: "Dolphin"
        icon.name: "system-file-manager"
        onClicked: Ipc.hyprIpc("dispatch exec dolphin")
    }
    MenuItem {
        text: "Kitty"
        icon.name: "kitty" // "utilities-terminal", for generic icon
        onClicked: Ipc.hyprIpc("dispatch exec kitty")
    }
    Menu {
        title: "Utils"
        icon.name: "applications-utilities"
        MenuItem {
            text: "Screenshot a region"
            icon.name: "preferences-system-windows-effect-screenshot"
            onClicked: Ipc.hyprIpc("dispatch exec screenshot region")
        }
        MenuItem {
            text: "Toggle Recording"
            icon.name: "media-record"
            onClicked: Ipc.hyprIpc("dispatch exec gsr-record")
        }
        MenuItem {
            text: "Toggle Replay-Buffer"
            icon.name: "keyframe-record"
            onClicked: Ipc.hyprIpc("dispatch exec replay-buffer toggle")
        }
        MenuItem {
            text: "Color Picker"
            icon.name: "color-picker"
            onClicked: Ipc.hyprIpc("dispatch exec hyprpicker -a --format=hex")
        }
        MenuItem {
            text: "Kill Quickshell"
            icon.name: "application-exit"
            onClicked: Qt.quit() // >:)
        }
    }
    MenuSeparator{}
    MenuItem {
        icon.name: "preferences-desktop-wallpaper"
        text: "Random Wallpaper"
        onClicked: {
            root.index = nextIndex(index)
            timer.restart()
        }
    }
    MenuSeparator{}
    Menu {
        title: "Power Options"
        icon.name: "preferences-system-power-management"
        MenuItem {
            text: "Power off"
            icon.name: "system-shutdown"
            onClicked: Ipc.hyprIpc("dispatch exec systemctl poweroff")
        }
        MenuItem {
            text: "Restart"
            icon.name: "system-reboot"
            onClicked: Ipc.hyprIpc("dispatch exec systemctl reboot")
        }
        MenuItem {
            text: "Soft Reboot"
            icon.name: "system-reboot"
            onClicked: Ipc.hyprIpc("dispatch exec systemctl soft-reboot")
        }
        MenuItem {
            text: "Sleep"
            icon.name: "system-suspend"
            onClicked: Ipc.hyprIpc("dispatch exec systemctl suspend")
        }
        MenuItem {
            text: "Lock screen"
            icon.name: "system-lock-screen"
            onClicked: Ipc.hyprIpc("dispatch exec loginctl lock-session")
        }
        MenuItem {
            text: "Logout"
            icon.name: "system-log-out-rtl"
            onClicked: Ipc.hyprIpc("dispatch exec loginctl terminate-user $USER")
        }
    }
}
