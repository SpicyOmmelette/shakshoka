import QtQuick 2.15
import QtQml.Models 2.3
import org.kde.plasma.private.mpris as Mpris

QtObject {
    id: root

    property string sourceName: "any"
    property var mpris2Model: Mpris.Mpris2Model {
        readonly property string sourceName: root.sourceName
        function chooseCurrentPlayer() {
            if (sourceName === "any") {
                currentIndex = 0
                console.debug("setting current source to multiplex");
                return
            }
            const CONTAINER_ROLE = Qt.UserRole + 1
            for (let i = 1; i < rowCount(); i++) {
                const player = data(index(i, 0), CONTAINER_ROLE)
                if (player.desktopEntry === sourceName) {
                    currentIndex = i
                    console.debug(`setting current source to ${player.desktopEntry} (index ${i})`);
                    return;
                }
            }
        }
        onRowsInserted: {
            chooseCurrentPlayer()
        }
        onSourceNameChanged: {
            chooseCurrentPlayer()
        }
    }
    readonly property bool ready: {
        if (!mpris2Model.currentPlayer) {
            return false
        }
        return mpris2Model.currentPlayer.desktopEntry === sourceName || sourceName === "any";
    }

    readonly property string artists: ready ? mpris2Model.currentPlayer.artist : ""
    readonly property string title: ready ? mpris2Model.currentPlayer.track : ""
    readonly property int playbackStatus: ready ? mpris2Model.currentPlayer.playbackStatus : Mpris.PlaybackStatus.Unknown
    readonly property string artUrl: ready ? mpris2Model.currentPlayer.artUrl : ""

    function playPause() {
        mpris2Model.currentPlayer?.PlayPause();
    }

    function next() {
        mpris2Model.currentPlayer?.Next();
    }

    function previous() {
        mpris2Model.currentPlayer?.Previous();
    }
}

