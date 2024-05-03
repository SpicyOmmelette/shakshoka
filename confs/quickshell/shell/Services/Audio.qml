// All credits goes to KDE
import QtQuick
import org.kde.plasma.private.volume 0.1
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

        property bool initalDefaultSinkIsSet: false

        onDefaultSinkChanged: {
            if (!defaultSink) {
                return;
            }

            // avoid showing a OSD on startup
            if (!initalDefaultSinkIsSet) {
                initalDefaultSinkIsSet = true;
                return;
            }
        }
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
}
