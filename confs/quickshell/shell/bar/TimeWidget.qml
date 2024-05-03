import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."
Frame {
    id: root
    property string timeFormat: "hh mm" // add AP for 12 hour-format
    // property string dateFormat: "dd MMM yyyy" // to-do onClikced event
    property string time: Qt.formatTime(Ipc.curTime, timeFormat)
    // width: parent.width
    ColumnLayout {
        id: container
        anchors.centerIn: parent
        // anchors.fill: parent
        spacing: 0

        Label {
            id: hours
            text: time.substring(0,2)
            font.pixelSize: 14
            font.letterSpacing: 0
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
        Label {
            id: minutes
            text: time.substring(3,5)
            font.pixelSize: 14
            font.letterSpacing: 0
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
        // Label {
        //     id: twelvefm // I don't what's called so be it
        //     text: time.substring(6,8)
        //     focus: true
        //     // font.pixelSize: 12
        //     // font.family: "Poppins"
        //     font.letterSpacing: 0
        //     horizontalAlignment: Text.AlignHCenter
        //     verticalAlignment: Text.AlignVCenter
        //     Layout.alignment: Qt.AlignHCenter
        // }
        // //END

    }
    //END
    // MouseArea {
    //     // anchors.fill:
    // }
}
//END
