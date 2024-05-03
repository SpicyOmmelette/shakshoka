pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

    signal osdMessage(text: string, progressBar: string, value: string, icon: string)
    property string curTime: new Date()
    property string activeWorkspace

    SocketServer {
        active: true
        path: "/run/user/1000/quickshell.sock"

        handler: Socket {
            parser: SplitParser {
                onRead: message => {
                    const [type, body] = message.split(":");
                    const args = body.split(",");

                    switch (type) {
                        case "osd":
                            osdMessage(args[0], args[1], args[2], args[3])
                            // console.log(args[0], args[1], args[2])
                            break;
                        default:
                            console.log(`socket received unknown message: ${message}`)
                    }
                }
            }

        }
    }
    //END

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
    Process {
        id: getactiveWorkspace
        command: ["activeworkspace"]
        running: true
        stdout: SplitParser {
            onRead: data => activeWorkspace = data
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
