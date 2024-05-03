// All credit goes to https://github.com/Prayag2/kde_modernclock
import QtQuick
import QtQuick.Controls
import Quickshell.Io

Item {
    id: root
    property string timeFormat: "hh:mm AP"
    property string dateFormat: "dd MMM yyyy"


    Column {
        id: container

        anchors.centerIn: parent
        spacing: 5

        Label {
            id: currentDay
            text: Qt.formatDate(Ipc.curTime, "dddd").toUpperCase()
            font.pixelSize: 100
            font.family: "Anurati"
            font.letterSpacing: 15
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: currentDate
            text: Qt.formatDate(Ipc.curTime, dateFormat).toUpperCase()
            // anchors.centerIn: parent
            font.pixelSize: 15
            font.family: "Poppins"
            font.letterSpacing: 5
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: currentTime
            text: " - " + Qt.formatTime(Ipc.curTime, timeFormat) + " - "
            font.pixelSize: 15
            font.family: "Poppins"
            font.letterSpacing: 3
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    //END
}
//END
