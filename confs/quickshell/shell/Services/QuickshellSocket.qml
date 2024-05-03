pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

    signal osdMessage(text: string, progressBar: string, value: string, icon: string)

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

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: {
            curTime = Date()
        }
    }
}
