pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

    property string curTime: new Date()
    property string activeWorkspace: "1"

    Socket {
        id: hyprlandIPC
        connected: true
        path: `/tmp/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket.sock`
        // onConnectedChanged: {
        //     console.log(connected ? "new connection!" : "connection dropped!")
        // }
        parser: SplitParser {
            onRead: message => console.log(`read message from Hyprland socket1: ${message}`)
        }
    }
    //END
    Socket {
        id: hyprlandEvents
        path: `/tmp/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket2.sock`
        connected: true

        parser: SplitParser {
            onRead: msg => {
                const [type,body] = msg.split(">>");
                const args = body.split(",");

                switch(type) {
                    case "workspacev2":
                        activeWorkspace = args[1];
                        break;
                    case "activewindow":
                        // activeWindow = args[0];
                        break;
                }
            }
        }
    }
    //END

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: {
            curTime = Date()
        }
    }

    //Functions
    function hyprIpc(command) {
        hyprlandIPC.connected = true
        hyprlandIPC.write(command)
    }
    //END
}
