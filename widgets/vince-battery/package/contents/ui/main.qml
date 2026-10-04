// SPDX-License-Identifier: MIT
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.private.mobileshell.dpmsplugin as DPMS
import org.kde.plasma.private.mobileshell.state as MobileState
import "Telemetry.js" as Telemetry

PlasmoidItem {
    id: root
    property var sample: null
    property bool screenAwake: true
    readonly property bool polling: Plasmoid.configuration.pollingEnabled
        && visible && screenAwake
        && !MobileState.LockscreenDBusClient.lockscreenActive
    readonly property string readerPath: decodeURIComponent(
        Qt.resolvedUrl("../code/read-battery.sh").toString().replace(/^file:\/\//, ""))
    readonly property string readerCommand: "timeout 4 sh '"
        + readerPath.replace(/'/g, "'\\''") + "'"

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.status: PlasmaCore.Types.ActiveStatus
    preferredRepresentation: fullRepresentation
    toolTipMainText: i18n("Battery voltage and current")
    toolTipSubText: !sample ? i18n("Battery data unavailable")
        : sample.current > 0 ? i18n("Charging · %1%", sample.capacity)
        : sample.current < 0 ? i18n("Discharging · %1%", sample.capacity)
        : i18n("No net battery current · %1%", sample.capacity)

    onPollingChanged: {
        // Never retain old readings across a hidden/locked/display-off interval.
        if (!polling) {
            sample = null;
        }
    }

    DPMS.DPMSUtil {
        onDpmsTurnedOff: (screen) => {
            if (!screen || !root.Window.window
                    || screen.name === root.Window.window.screen.name) {
                root.screenAwake = false;
            }
        }
        onDpmsTurnedOn: (screen) => {
            if (!screen || !root.Window.window
                    || screen.name === root.Window.window.screen.name) {
                root.screenAwake = true;
            }
        }
    }

    Plasma5Support.DataSource {
        id: reader
        engine: "executable"
        interval: 5000
        connectedSources: root.polling ? [root.readerCommand] : []
        onNewData: (sourceName, data) => {
            if (root.polling && sourceName === root.readerCommand) {
                root.sample = Telemetry.parse(data["stdout"], data["exit code"]);
            }
        }
    }

    fullRepresentation: BatteryCard {
        sample: root.sample
        Layout.minimumWidth: Kirigami.Units.gridUnit * 7
        Layout.minimumHeight: Kirigami.Units.gridUnit * 3
        Layout.preferredWidth: implicitWidth
        Layout.preferredHeight: implicitHeight
    }
}
