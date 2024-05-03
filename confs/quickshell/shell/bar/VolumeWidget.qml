// All credits goes to KDE
import QtQuick
import QtQuick.Controls
import org.kde.plasma.private.volume 0.1
import ".."
Item {
    id: root
    width: parent.width ; height: volumeButton.height
    signal osdMessage(text: string, progressBar: string, value: string, icon: string)
    property int volumePercentStep: 5
    property bool globalMute: false
    property bool buttonVisibility: true
    // property int currentVolume: volumePercent(paSinkModel.preferredSink.volume)
    readonly property string dummyOutputName: "auto_null"
    property int currentMaxVolumePercent:  100
    property int currentMaxVolumeValue: currentMaxVolumePercent * PulseAudio.NormalVolume / 100.00
    readonly property SinkModel paSinkModel: SinkModel {
        id: paSinkModel
    }

    function volumePercent(volume) {
        return Math.round(volume / PulseAudio.NormalVolume * 100.0);
    }

    function iconSelector(volume, muted, prefix) {
        if (!prefix) {
            prefix = "audio-volume";
        }
        var icon = null;
        const percent = volumePercent(volume);
        switch (true){

            case (percent <= 0) || muted :
                icon = prefix + "-muted";
                break;
            case (percent <= 25):
                icon = prefix + "-low";
                break;
            case (percent <= 75):
                icon = prefix + "-medium";
                break;
            case (percent > 75):
                icon = prefix + "-high";
                break;
            case (percent >= 100):
                icon = `${prefix}-high-warning`;
                break;
            defualt:
                icon = `${prefix}-high-danger`;

        }
        return icon;
    }

    function muteVolume() {
        if (!paSinkModel.preferredSink || isDummyOutput(paSinkModel.preferredSink)) {
            return;
        }
        var toMute = !paSinkModel.preferredSink.muted;
        paSinkModel.preferredSink.muted = toMute;
    }

    function isDummyOutput(output) {
        return output && output.name === dummyOutputName;
    }

    function boundVolume(volume) {
        return Math.max(PulseAudio.MinimalVolume, Math.min(volume, currentMaxVolumeValue));
    }

    function changeVolumeByPercent(volumeObject, deltaPercent) {
        const oldVolume = volumeObject.volume;
        const oldPercent = volumePercent(oldVolume);
        const targetPercent = oldPercent + deltaPercent;
        const newVolume = boundVolume(Math.round(PulseAudio.NormalVolume * (targetPercent/100)));
        const newPercent = volumePercent(newVolume);
        volumeObject.muted = newPercent == 0;
        volumeObject.volume = newVolume;
        return newPercent;
    }

    function changeSpeakerVolume(deltaPercent) {
        if (!paSinkModel.preferredSink || isDummyOutput(paSinkModel.preferredSink)) {
            return;
        }
        const newPercent = changeVolumeByPercent(paSinkModel.preferredSink, deltaPercent);
    }
    Connections {
        target: paSinkModel.preferredSink
        function onVolumeChanged() {
            var currentVolume = volumePercent(paSinkModel.preferredSink.volume)
            osdMessage(currentVolume,"true",currentVolume,iconSelector(paSinkModel.preferredSink.volume, paSinkModel.preferredSink.muted))
        }
    }
    ToolButton {
        id: volumeButton
        visible: buttonVisibility
        anchors.fill: parent
        icon.name: paSinkModel.preferredSink ? iconSelector(paSinkModel.preferredSink.volume, paSinkModel.preferredSink.muted) : iconSelector(0, true)
        hoverEnabled: true
        icon.width: 50
        icon.height: 30
        onClicked: muteVolume();
        ToolTip.delay: 200
        ToolTip.visible: hovered
        ToolTip.text: paSinkModel.preferredSink.muted ? "Muted" : volumePercent(paSinkModel.preferredSink.volume)

        WheelHandler {
            orientation: Qt.Vertical | Qt.Horizontal
            property int wheelDelta: 0
            acceptedButtons: Qt.NoButton
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: wheel => {
                const delta = (wheel.angleDelta.y || -wheel.angleDelta.x) * (wheel.inverted ? -1 : 1)
                wheelDelta += delta;
                while (wheelDelta >= 120) {
                    wheelDelta -= 120;
                    // Ipc.hyprIpc("dispatch exec pamixer --increase 5")
                    changeSpeakerVolume(volumePercentStep);
                }
                while (wheelDelta <= -120) {
                    wheelDelta += 120;
                    // Ipc.hyprIpc("dispatch exec pamixer --decrease 5")
                    changeSpeakerVolume(-volumePercentStep);
                }
            }
        }
    }
}
