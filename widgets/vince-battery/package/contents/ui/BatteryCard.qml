// SPDX-License-Identifier: MIT
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3
import "Telemetry.js" as Telemetry

Item {
    id: card
    property var sample: null
    readonly property string direction: Telemetry.direction(sample)
    readonly property color outline: "#202020"
    readonly property color accent: !sample ? "#dddddd"
        : direction === "charging" ? "#a5f2b4"
        : sample.capacity <= 15 ? "#ffaaa0" : "white"

    implicitWidth: Kirigami.Units.gridUnit * 9
    implicitHeight: Kirigami.Units.gridUnit * 4

    Accessible.role: Accessible.StaticText
    Accessible.name: Telemetry.voltageText(sample) + ", " + Telemetry.currentText(sample)
        + ", " + Telemetry.temperatureText(sample)

    RowLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.largeSpacing

        Item {
            Layout.preferredWidth: 18
            Layout.preferredHeight: 28
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                y: 3
                width: 18
                height: 26
                radius: 4
                color: "transparent"
                border.width: 4
                border.color: card.outline
            }

            Rectangle {
                x: 1
                y: 4
                width: 16
                height: 24
                radius: 3
                color: "transparent"
                border.width: 1.5
                border.color: card.accent

                Rectangle {
                    x: 3
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3
                    width: 10
                    height: card.sample ? 18 * card.sample.capacity / 100 : 0
                    radius: 1
                    color: card.accent
                    opacity: 0.8
                }
            }

            Rectangle {
                x: 4.5
                width: 9
                height: 5
                radius: 2
                color: card.outline
            }

            Rectangle {
                x: 5.5
                y: 1
                width: 7
                height: 3
                radius: 1
                color: card.accent
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            PC3.Label {
                Layout.fillWidth: true
                text: Telemetry.voltageText(card.sample)
                font.pixelSize: 19
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
                minimumPixelSize: 12
                color: "white"
                style: Text.Outline
                styleColor: card.outline
            }

            PC3.Label {
                Layout.fillWidth: true
                text: Telemetry.currentText(card.sample)
                font.pixelSize: 16
                fontSizeMode: Text.Fit
                minimumPixelSize: 11
                color: card.accent
                style: Text.Outline
                styleColor: card.outline
            }

            PC3.Label {
                Layout.fillWidth: true
                text: Telemetry.temperatureText(card.sample)
                font.pixelSize: 14
                fontSizeMode: Text.Fit
                minimumPixelSize: 11
                color: "white"
                style: Text.Outline
                styleColor: card.outline
            }
        }
    }
}
