
import Quickshell
import Quickshell.Wayland
import "bar"
ShellRoot {
    settings.watchFiles: false
    Variants {
        model: Quickshell.screens

        Scope {
            property var modelData

            PanelWindow {
                id: shell
                anchors {
                    top: true
                    bottom: true
                    right: true
                    left: true
                }
                color: "transparent"
                // exclusiveZone: 50
                exclusionMode: ExclusionMode.Normal
                WlrLayershell.layer: WlrLayer.Background

                Bar {
                    screen: shell.screen
                }

                Osd {
                    id: osd
                }

                Background {
                    anchors.fill: parent
                    screen: shell.screen
                }
            }
            //END
        }
    }
}
//END
