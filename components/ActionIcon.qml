import QtQuick 2.15

Canvas {
    id: root

    property string iconName: "power"
    property color iconColor: "#173d60"

    onIconNameChanged: requestPaint()
    onIconColorChanged: requestPaint()

    onPaint: {
        const context = getContext("2d")
        context.clearRect(0, 0, width, height)
        context.strokeStyle = root.iconColor
        context.lineWidth = 2.2
        context.lineCap = "round"
        context.lineJoin = "round"

        if (root.iconName === "power") {
            context.beginPath()
            context.arc(width / 2, height / 2, width * 0.35, -Math.PI / 4, Math.PI * 1.25, false)
            context.stroke()

            context.beginPath()
            context.moveTo(width / 2, height * 0.08)
            context.lineTo(width / 2, height * 0.51)
            context.stroke()
            return
        }

        const centerX = width / 2
        const centerY = height / 2
        const radii = [width * 0.29, width * 0.29, width * 0.42, width * 0.42]

        context.beginPath()
        for (let point = 0; point < 32; point++) {
            const angle = -Math.PI / 2 + point * Math.PI / 16
            const radius = radii[point % radii.length]
            const x = centerX + Math.cos(angle) * radius
            const y = centerY + Math.sin(angle) * radius

            if (point === 0) {
                context.moveTo(x, y)
            } else {
                context.lineTo(x, y)
            }
        }
        context.closePath()
        context.stroke()

        context.beginPath()
        context.arc(centerX, centerY, width * 0.12, 0, Math.PI * 2, false)
        context.stroke()
    }
}
