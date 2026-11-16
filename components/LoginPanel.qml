import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: root

    property var usersModel
    property string rememberedUser: ""
    property string selectedUser: rememberedUser
    property bool otherUserMode: !rememberedUser
    property int sessionIndex: 0
    property color textColor: "#173d60"
    property color accentColor: "#dff3ff"
    property color fieldColor: "#eaf7ff"
    property color fieldBorderColor: "#b9e2fa"
    property color focusColor: "#408fc5"
    property string fontFamily: "Noto Sans"

    signal loginRequested(string username, string password, int sessionIndex)

    spacing: 12

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
        root.loginRequested(username, passwordInput.text, root.sessionIndex)
    }

    function showLoginFailure() {
        statusLabel.text = "Logowanie nie powiodło się. Sprawdź hasło."
        passwordInput.selectAll()
        passwordInput.forceActiveFocus()
    }

    Flow {
        width: parent.width
        visible: root.usersModel && root.usersModel.count > 0
        spacing: 8

        Repeater {
            model: root.usersModel

            Button {
                required property string name
                text: name
                checkable: true
                checked: !root.otherUserMode && root.selectedUser === name
                font.family: root.fontFamily
                font.pixelSize: 18
                onClicked: {
                    root.selectedUser = name
                    root.otherUserMode = false
                    passwordInput.clear()
                    statusLabel.text = ""
                }
                background: Rectangle {
                    radius: 16
                    color: parent.checked ? root.fieldColor : root.accentColor
                    opacity: 0.94
                    border.width: 1
                    border.color: parent.checked ? root.focusColor : "#f5fbff"
                }
                contentItem: Text {
                    text: parent.text
                    color: root.textColor
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 14
                    rightPadding: 14
                }
            }
        }

        Button {
            visible: root.usersModel && root.usersModel.count > 0
            text: root.otherUserMode ? "Wróć do kont" : "+ Inne konto"
            enabled: !root.otherUserMode || !!root.selectedUser
            font.family: root.fontFamily
            font.pixelSize: 16
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
                color: root.accentColor
                opacity: parent.enabled ? 0.9 : 0.45
                border.width: 1
                border.color: "#f5fbff"
            }
            contentItem: Text {
                text: parent.text
                color: root.textColor
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
        height: 68
        visible: root.otherUserMode
        placeholderText: "Nazwa użytkownika"
        color: root.textColor
        font.family: root.fontFamily
        font.pixelSize: 18
        leftPadding: 20
        background: Rectangle {
            radius: 18
            color: root.fieldColor
            opacity: 0.82
            border.width: 1
            border.color: usernameInput.activeFocus ? root.focusColor : root.fieldBorderColor
        }
        onAccepted: passwordInput.forceActiveFocus()
    }

    Rectangle {
        id: passwordBox
        width: parent.width
        height: 68
        radius: 24
        color: root.fieldColor
        opacity: 0.9
        border.width: 1
        border.color: passwordInput.activeFocus ? root.focusColor : root.fieldBorderColor

        TextField {
            id: passwordInput
            anchors.fill: parent
            anchors.rightMargin: 64
            leftPadding: 24
            placeholderText: "Hasło"
            echoMode: TextInput.Password
            color: root.textColor
            font.family: root.fontFamily
            font.pixelSize: 18
            background: Item {}
            onAccepted: root.startLogin()
        }

        RoundButton {
            width: 50
            height: 50
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: "›"
            font.family: "Noto Sans"
            font.pixelSize: 36
            font.weight: Font.Bold
            contentItem: Text {
                text: parent.text
                color: root.textColor
                font: parent.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: width / 2
                color: root.accentColor
                opacity: parent.down ? 0.65 : 1
            }
            onClicked: root.startLogin()
        }
    }

    Text {
        id: statusLabel
        width: parent.width
        color: root.textColor
        font.family: "Noto Sans"
        font.pixelSize: 15
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
    }

    Component.onCompleted: {
        if (!root.otherUserMode) {
            passwordInput.forceActiveFocus()
        } else {
            usernameInput.forceActiveFocus()
        }
    }
}
