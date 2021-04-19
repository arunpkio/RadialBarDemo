import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Controls 2.15

Rectangle {
    id: control

    implicitWidth: 300
    implicitHeight: 300
    color: "grey"

    property var centerPt: Qt.point(width / 2, height / 2)
    property real angle: startAngle
    property int dialWidth: 20

    property real startAngle: 90
    property real endAngle: 320

    RadialBarShape {
        anchors.fill: parent
        value: control.angle - control.startAngle
        dialWidth: control.dialWidth
        minValue: 0
        maxValue: 360
        startAngle: 90 + control.startAngle
    }

    MouseArea {
        anchors.fill: parent

        onClicked:  {
            var outerRadius = control.width/2
            var innerRadius = control.width/2 - control.dialWidth
            var clickedDistance = (mouseX-centerPt.x)*(mouseX-centerPt.x) + (mouseY-centerPt.y)*(mouseY-centerPt.y)
            var innerRadius2 = (innerRadius * innerRadius)
            var outerRadius2 = (outerRadius * outerRadius)
            var isOutOfInnerRadius = clickedDistance > innerRadius2
            var inInSideOuterRadius = clickedDistance <= outerRadius2
            if (inInSideOuterRadius && isOutOfInnerRadius)
            {
                var angleDeg = Math.atan2(mouseY - centerPt.y, mouseX - centerPt.x) * 180 / Math.PI;
                if (angleDeg < 0) angleDeg = 360 + angleDeg;
                if((angleDeg >= control.startAngle) && (angleDeg <= control.endAngle))
                    control.angle = angleDeg
            }
        }
    }

    Rectangle {
        id: handleItem
        x: control.width / 2 - width / 2
        y: control.height / 2 - height / 2
        width: control.dialWidth
        height: control.dialWidth
        color: "#17a81a"
        radius: width / 2
        antialiasing: true
        opacity: control.enabled ? 1 : 0.3
        transform: [
            Translate {
                y: -Math.min(control.width, control.height) * 0.5 + handleItem.height / 2
            },
            Rotation {
                angle: control.angle + 90
                origin.x: handleItem.width / 2
                origin.y: handleItem.height / 2
            }
        ]

        MouseArea {
            id: trackMouse
            anchors.fill: parent
            onPositionChanged: getVal()
            onClicked: getVal()
            cursorShape: Qt.SizeAllCursor

            function getVal() {
                var handlePoint = mapToItem(control, Qt.point(trackMouse.mouseX, trackMouse.mouseY))

                // angle in degrees
                var angleDeg = Math.atan2(handlePoint.y - centerPt.y, handlePoint.x - centerPt.x) * 180 / Math.PI;
                if (angleDeg < 0) angleDeg = 360 + angleDeg;
                if((angleDeg >= control.startAngle) && (angleDeg <= control.endAngle))
                    control.angle = angleDeg
            }
        }
    }

    Label {
        anchors.centerIn: parent
        text: Number(control.angle).toFixed()
    }
}
