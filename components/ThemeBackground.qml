import QtQuick 2.15

Item {
    id: root

    property color baseColor: "#80D4D9"
    property color lightColor: "#f7fcff"
    property color darkColor: "#398fc9"

    Rectangle {
        anchors.fill: parent
        color: root.baseColor
    }

    Rectangle {
        width: Math.max(root.width, root.height) * 0.72
        height: width
        radius: width / 2
        x: root.width * 0.58
        y: -height * 0.54
        color: root.lightColor
        opacity: 0.22
    }

    Rectangle {
        width: Math.max(root.width, root.height) * 0.64
        height: width
        radius: width / 2
        x: -width * 0.27
        y: root.height * 0.62
        color: root.darkColor
        opacity: 0.12
    }

    Rectangle {
        width: Math.max(root.width, root.height) * 0.3
        height: width
        radius: width / 2
        x: root.width * 0.78
        y: root.height * 0.72
        color: root.lightColor
        opacity: 0.2
    }
}
