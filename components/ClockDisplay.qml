import QtQuick 2.15

Column {
    id: root

    property color textColor: "#173d60"
    property string fontFamily: "Noto Sans"
    property real availableHeight: 768
    property real timeScale: 1.25
    property real dateScale: 0.9
    property int timeFontSize: Math.min(120, Math.max(48, availableHeight * 0.14)) * timeScale
    property int dateFontSize: Math.min(28, Math.max(20, availableHeight * 0.035)) * dateScale
    spacing: 5

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

    Text {
        id: timeLabel
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.textColor
        font.family: root.fontFamily
        font.pixelSize: root.timeFontSize
        text: ""
    }

    Text {
        id: dateLabel
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.textColor
        opacity: 0.88
        font.family: root.fontFamily
        font.pixelSize: root.dateFontSize
        text: ""
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateClock()
    }

    Component.onCompleted: root.updateClock()
}
