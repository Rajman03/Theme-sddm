import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    width: Screen.width
    height: Screen.height
    color: "#80D4D9"

    property color ink: "#173d60"
    property color accent: "#dff3ff"
    property int sessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
    property string selectedUser: userModel.lastUser || ""
    property bool otherUserMode: !userModel.lastUser
    property string displayFont: fredoka.status === FontLoader.Ready ? fredoka.name : "Noto Sans"

    FontLoader {
        id: fredoka
        source: "FredokaOne.ttf"
    }

    function polishDate(dateValue) {
        const weekdays = ["niedziela", "poniedziałek", "wtorek", "środa", "czwartek", "piątek", "sobota"]
        const months = [
            "stycznia", "lutego", "marca", "kwietnia", "maja", "czerwca",
            "lipca", "sierpnia", "września", "października", "listopada", "grudnia"
        ]
        return weekdays[dateValue.getDay()] + ", " + dateValue.getDate() + " " + months[dateValue.getMonth()]
    }

    function updateClock() {
        const now = new Date()
        timeLabel.text = now.toLocaleTimeString(Qt.locale("pl_PL"), "HH:mm")
        dateLabel.text = polishDate(now)
    }

    function startLogin() {
        const username = root.otherUserMode ? usernameInput.text.trim() : root.selectedUser
        if (!username) {
            statusLabel.text = "Wpisz nazwę użytkownika"
            usernameInput.forceActiveFocus()
            return
        }
        if (!passwordInput.text) {
            statusLabel.text = "Wpisz hasło"
            passwordInput.forceActiveFocus()
            return
        }

        statusLabel.text = ""
        sddm.login(username, passwordInput.text, root.sessionIndex)
    }

    Rectangle {
        width: Math.max(root.width, root.height) * 0.72
        height: width
        radius: width / 2
        x: root.width * 0.58
        y: -height * 0.54
        color: "#f7fcff"
        opacity: 0.22
    }

    Rectangle {
        width: Math.max(root.width, root.height) * 0.64
        height: width
        radius: width / 2
        x: -width * 0.27
        y: root.height * 0.62
        color: "#398fc9"
        opacity: 0.12
    }

    Rectangle {
        width: Math.max(root.width, root.height) * 0.3
        height: width
        radius: width / 2
        x: root.width * 0.78
        y: root.height * 0.72
        color: "#eaf8ff"
        opacity: 0.2
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.height * 0.205
        spacing: 5

        Text {
            id: timeLabel
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.ink
            font.family: root.displayFont
            font.pixelSize: Math.min(76, root.height * 0.095)
            font.weight: Font.Normal
            text: ""
        }

        Text {
            id: dateLabel
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.ink
            opacity: 0.88
            font.family: root.displayFont
            font.pixelSize: Math.min(27, root.height * 0.035)
            font.weight: Font.Normal
            text: ""
        }
    }

    Column {
        width: Math.min(430, root.width * 0.82)
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * 0.43
        spacing: 12

        Flow {
            width: parent.width
            visible: userModel.count > 0
            spacing: 8

            Repeater {
                model: userModel

                Button {
                    required property string name
                    text: name
                    checkable: true
                    checked: !root.otherUserMode && root.selectedUser === name
                    font.family: root.displayFont
                    font.pixelSize: 16
                    onClicked: {
                        root.selectedUser = name
                        root.otherUserMode = false
                        passwordInput.clear()
                        statusLabel.text = ""
                    }
                    background: Rectangle {
                        radius: 16
                        color: parent.checked ? "#eaf7ff" : "#c8eef0"
                        opacity: 0.94
                        border.width: 1
                        border.color: parent.checked ? "#408fc5" : "#f5fbff"
                    }
                    contentItem: Text {
                        text: parent.text
                        color: root.ink
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 14
                        rightPadding: 14
                    }
                }
            }

            Button {
                visible: userModel.count > 0
                text: root.otherUserMode ? "Wróć do kont" : "+ Inne konto"
                enabled: !root.otherUserMode || !!root.selectedUser
                font.family: root.displayFont
                font.pixelSize: 15
                onClicked: {
                    if (root.otherUserMode) {
                        root.otherUserMode = false
                    } else {
                        root.otherUserMode = true
                        usernameInput.clear()
                    }
                    passwordInput.clear()
                    statusLabel.text = ""
                }
                background: Rectangle {
                    radius: 16
                    color: "#c8eef0"
                    opacity: parent.enabled ? 0.9 : 0.45
                    border.width: 1
                    border.color: "#f5fbff"
                }
                contentItem: Text {
                    text: parent.text
                    color: root.ink
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 14
                    rightPadding: 14
                }
            }
        }

        TextField {
            id: usernameInput
            width: parent.width
            height: 54
            visible: root.otherUserMode
            placeholderText: "Nazwa użytkownika"
            color: root.ink
            font.family: root.displayFont
            font.pixelSize: 18
            leftPadding: 20
            background: Rectangle {
                radius: 18
                color: "#eaf7ff"
                opacity: 0.82
                border.width: 1
                border.color: usernameInput.activeFocus ? "#408fc5" : "#b9e2fa"
            }
            onAccepted: passwordInput.forceActiveFocus()
        }

        Rectangle {
            id: passwordBox
            width: parent.width
            height: 54
            radius: 18
            color: "#eaf7ff"
            opacity: 0.9
            border.width: 1
            border.color: passwordInput.activeFocus ? "#408fc5" : "#b9e2fa"

            TextField {
                id: passwordInput
                anchors.fill: parent
                anchors.rightMargin: 54
                leftPadding: 20
                placeholderText: "Hasło"
                echoMode: TextInput.Password
                color: root.ink
                font.family: root.displayFont
                font.pixelSize: 18
                background: Item {}
                onAccepted: root.startLogin()
            }

            RoundButton {
                width: 42
                height: 42
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                text: "›"
                font.family: "Noto Sans"
                font.pixelSize: 30
                font.weight: Font.Bold
                contentItem: Text {
                    text: parent.text
                    color: root.ink
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: width / 2
                    color: root.accent
                    opacity: parent.down ? 0.65 : 1
                }
                onClicked: root.startLogin()
            }
        }

        Text {
            id: statusLabel
            width: parent.width
            color: "#173d60"
            font.family: "Noto Sans"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }
    }

    Column {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 34
        anchors.bottomMargin: 34
        spacing: 8

        RoundButton {
            width: 52
            height: 52
            enabled: sddm.canPowerOff
            text: "⏻"
            font.pixelSize: 25
            font.family: "Noto Sans"
            contentItem: Text {
                text: parent.text
                color: root.ink
                font: parent.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: 15
                color: root.accent
                opacity: parent.enabled ? 0.94 : 0.45
                border.color: "#f5fbff"
                border.width: 1
            }
            onClicked: sddm.powerOff()
        }

        RoundButton {
            width: 52
            height: 52
            text: "⚙"
            font.pixelSize: 23
            font.family: root.displayFont
            contentItem: Text {
                text: parent.text
                color: root.ink
                font: parent.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: 15
                color: root.accent
                opacity: 0.94
                border.color: "#f5fbff"
                border.width: 1
            }
            onClicked: sessionMenu.open()
        }
    }

    Menu {
        id: sessionMenu
        Repeater {
            model: sessionModel
            MenuItem {
                text: model.name
                checkable: true
                checked: index === root.sessionIndex
                onTriggered: root.sessionIndex = index
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateClock()
    }

    Component.onCompleted: {
        root.updateClock()
        if (!root.otherUserMode) {
            passwordInput.forceActiveFocus()
        } else {
            usernameInput.forceActiveFocus()
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            statusLabel.text = "Logowanie nie powiodło się. Sprawdź hasło."
            passwordInput.selectAll()
            passwordInput.forceActiveFocus()
        }
    }
}
