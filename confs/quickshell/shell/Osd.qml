import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "bar"
WlrLayershell {
    id: osd
    visible: false
    exclusionMode: ExclusionMode.Ignore
    layer: WlrLayer.Overlay
    namespace: "quickshell:osd"
    keyboardFocus: WlrKeyboardFocus.None
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }
    color: "transparent"
    mask: Region {}

    VolumeWidget {
        id: volumeWidget
        buttonVisibility: false
        Connections {
            function onOsdMessage (text,progressBar,value,icon) {
                showOsd(text,progressBar,value,icon);
            }
        }
    }

    Popup {
        id: popup
        visible: true
        anchors.centerIn: parent
        topMargin: (osd.height * 2/3) + 50
        width: 250
        height: 50
        padding: 0
        contentWidth: row.implicitWidth
        contentHeight: row.implicitHeight
        focus: false
        // closePolicy: Popup.NoAutoClose
        RowLayout {
            id: row
            anchors.centerIn: parent
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.margins: 0
            // width: parent
            spacing: 0;

            ToolButton {
                id: osdIcon
                visible: false
                icon.width: 50
                icon.height: 50
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredWidth: popup.width * 1/7
                Layout.preferredHeight: popup.height
            }
            ProgressBar {
                id: bar
                from: 0; to: 100;
                // width: row.width / 2
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                Layout.preferredWidth: popup.width * 2/3
                Layout.rightMargin: 8
            }
            Label {
                id: popupText
                visible: true
                font {
                    bold: true
                    pixelSize: 14
                }
                Layout.alignment: Qt.AlignRight | Qt.AlignHCenter
            }
        }
        //END
    }
    //END

    Connections {
        target: Ipc
        function onOsdMessage (text,progressBar,value,icon) {
            showOsd (text,progressBar,value,icon)
        }
    }

    function showOsd (text,progressBar,value,icon) {
        popupText.text = text
        bar.visible = (progressBar.toLowerCase() == "true") ; bar.value = value
        icon ? (osdIcon.visible = true, osdIcon.icon.name = icon) : osdIcon.visible = false;
        osd.visible = true
        osdTimer.restart();
    }

    Timer {
        id: osdTimer
        running: false
        repeat: false
        interval: 2000
        onTriggered: {
            osd.visible = !osd.visible
        }
    }
    //END
}
