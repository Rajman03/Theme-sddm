import QtQuick 2.15
import "components"

Rectangle {
    id: root

    width: Screen.width
    height: Screen.height
    color: config.backgroundColor || "#80D4D9"

    property color inkColor: config.inkColor || "#173d60"
    property color accentColor: config.accentColor || "#dff3ff"
    property color fieldColor: config.fieldColor || "#eaf7ff"
    property color fieldBorderColor: config.fieldBorderColor || "#b9e2fa"
    property color focusColor: config.focusColor || "#408fc5"
    property color lightShapeColor: config.lightShapeColor || "#f7fcff"
    property color darkShapeColor: config.darkShapeColor || "#398fc9"
    property string displayFont: fredoka.status === FontLoader.Ready ? fredoka.name : "Noto Sans"
    property int sessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
    property real timeScale: Number(config.timeScale) || 1.25
    property real dateScale: Number(config.dateScale) || 0.9

    FontLoader {
        id: fredoka
        source: "FredokaOne.ttf"
    }

    ThemeBackground {
        anchors.fill: parent
        baseColor: root.color
        lightColor: root.lightShapeColor
        darkColor: root.darkShapeColor
    }

    ClockDisplay {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.height * 0.205
        textColor: root.inkColor
        fontFamily: root.displayFont
        timeScale: root.timeScale
        dateScale: root.dateScale
    }

    LoginPanel {
        id: loginPanel
        width: Math.min(430, root.width * 0.82)
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * 0.43
        usersModel: userModel
        rememberedUser: userModel.lastUser || ""
        sessionIndex: root.sessionIndex
        textColor: root.inkColor
        accentColor: root.accentColor
        fieldColor: root.fieldColor
        fieldBorderColor: root.fieldBorderColor
        focusColor: root.focusColor
        fontFamily: root.displayFont
        onLoginRequested: (username, password, selectedSession) =>
            sddm.login(username, password, selectedSession)
    }

    SessionControls {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 34
        anchors.bottomMargin: 34
        sessionsModel: sessionModel
        sessionIndex: root.sessionIndex
        textColor: root.inkColor
        buttonColor: root.accentColor
        fontFamily: root.displayFont
        powerOffEnabled: sddm.canPowerOff
        onPowerOffRequested: sddm.powerOff()
        onSessionSelected: index => root.sessionIndex = index
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            loginPanel.showLoginFailure()
        }
    }
}
