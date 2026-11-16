import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: root

    property var sessionsModel
    property int sessionIndex: 0
    property color textColor: "#173d60"
    property color buttonColor: "#dff3ff"
    property string fontFamily: "Noto Sans"
    property bool powerOffEnabled: false

    signal powerOffRequested()
    signal sessionSelected(int index)

    spacing: 8

    RoundButton {
        id: settingsButton
        width: 68
        height: 68
        enabled: root.powerOffEnabled
        text: "⏻"
        font.pixelSize: 36
        font.family: "Noto Sans"
        contentItem: Text {
            text: parent.text
            color: root.textColor
            font: parent.font
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 15
            color: root.buttonColor
            opacity: parent.enabled ? 0.94 : 0.45
            border.color: "#f5fbff"
            border.width: 1
        }
        onClicked: root.powerOffRequested()
    }

    RoundButton {
        id: powerButton
        width: 68
        height: 68
        text: "⚙"
        font.pixelSize: 32
        font.family: root.fontFamily
        contentItem: Text {
            text: parent.text
            color: root.textColor
            font: parent.font
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 15
            color: root.buttonColor
            opacity: 0.94
            border.color: "#f5fbff"
            border.width: 1
        }
        onClicked: sessionMenu.popup(
            settingsButton,
            settingsButton.width + 8,
            powerButton.height + root.spacing
        )
    }

    Menu {
        id: sessionMenu
        palette.window: root.buttonColor
        palette.text: root.textColor
        palette.highlight: "#b9e2fa"
        palette.highlightedText: root.textColor

        background: Rectangle {
            implicitWidth: 180
            radius: 12
            color: root.buttonColor
            border.color: "#f5fbff"
            border.width: 1
        }

        Repeater {
            model: root.sessionsModel

            MenuItem {
                text: model.name
                checkable: true
                checked: index === root.sessionIndex
                contentItem: Text {
                    text: parent.text
                    color: root.textColor
                    font.family: root.fontFamily
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 34
                }
                background: Rectangle {
                    radius: 8
                    color: parent.highlighted ? "#b9e2fa" : "transparent"
                }
                onTriggered: root.sessionSelected(index)
            }
        }
    }
}
