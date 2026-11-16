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
        width: 52
        height: 52
        enabled: root.powerOffEnabled
        text: "⏻"
        font.pixelSize: 25
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
        width: 52
        height: 52
        text: "⚙"
        font.pixelSize: 23
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
        onClicked: sessionMenu.open()
    }

    Menu {
        id: sessionMenu

        Repeater {
            model: root.sessionsModel

            MenuItem {
                text: model.name
                checkable: true
                checked: index === root.sessionIndex
                onTriggered: root.sessionSelected(index)
            }
        }
    }
}
