import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQml 2.15

Item {
    id: control

    property int trackWidth: 20
    property int handleWidth: 20
    property int handleHeight: 20
    property int handleRadius: 10

    property real startAngle: 0
    property real endAngle: 360
    property real minValue: 0
    property real maxValue: 100
    property real value: 0
    readonly property real angle: internal.mapFromValue(minValue, maxValue, startAngle, endAngle, control.value)

    property int penStyle: Qt.RoundCap
    property color dialColor: "#FF005050"
    property color progressColor: "#FFA51BAB"
    property bool wheelEnabled: false
    property Component handle: null

    implicitWidth: 250
    implicitHeight: 250

    Binding {
        target: control
        property: "value"
        value: internal.mapFromValue(startAngle, endAngle, minValue, maxValue, internal.angleProxy)
        when: internal.setUpdatedValue
        restoreMode: Binding.RestoreBinding
    }

    QtObject {
        id: internal

        property var centerPt: Qt.point(width / 2, height / 2)
        property real baseRadius: Math.min(control.width / 2, control.height / 2)
        property real radiusOffset: control.trackWidth / 2
        property real actualSpanAngle: control.endAngle - control.startAngle
        property color transparentColor: "transparent"
        property color dialColor: control.dialColor
        property bool setUpdatedValue: false
        property real angleProxy: control.startAngle

        function mapFromValue(inMin, inMax, outMin, outMax, inValue) {
            return (inValue - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
        }

        function updateAngle(angleVal) {
            if (angleVal < 0)
                angleVal += 360;

            if ((angleVal >= control.startAngle) && (angleVal <= control.endAngle)) {
                internal.setUpdatedValue = true;
                internal.angleProxy = Qt.binding(function() {
                    return angleVal;
                });
                internal.setUpdatedValue = false;
            }
        }
    }

    // Dial Shapes
    Shape {
        id: shape

        width: control.width
        height: control.height
        layer.enabled: true
        layer.samples: 8
        clip: false

        ShapePath {
            id: pathDial

            strokeColor: control.dialColor
            fillColor: internal.transparentColor
            strokeWidth: control.trackWidth
            capStyle: control.penStyle

            PathAngleArc {
                radiusX: internal.baseRadius - internal.radiusOffset
                radiusY: internal.baseRadius - internal.radiusOffset
                centerX: control.width / 2
                centerY: control.height / 2
                startAngle: control.startAngle - 90
                sweepAngle: internal.actualSpanAngle
            }
        }

        ShapePath {
            id: pathProgress

            strokeColor: control.progressColor
            fillColor: internal.transparentColor
            strokeWidth: control.trackWidth
            capStyle: control.penStyle

            PathAngleArc {
                radiusX: internal.baseRadius - internal.radiusOffset
                radiusY: internal.baseRadius - internal.radiusOffset
                centerX: control.width / 2
                centerY: control.height / 2
                startAngle: control.startAngle - 90
                sweepAngle: control.angle - control.startAngle
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var outerRadius = internal.baseRadius;
            var innerRadius = internal.baseRadius - control.trackWidth;
            var clickedDistance = (mouseX - internal.centerPt.x) * (mouseX - internal.centerPt.x) + (mouseY - internal.centerPt.y) * (mouseY - internal.centerPt.y);
            var innerRadius2 = (innerRadius * innerRadius);
            var outerRadius2 = (outerRadius * outerRadius);
            var isOutOfInnerRadius = clickedDistance > innerRadius2;
            var inInSideOuterRadius = clickedDistance <= outerRadius2;
            if (inInSideOuterRadius && isOutOfInnerRadius) {
                var angleDeg = Math.atan2(mouseY - internal.centerPt.y, mouseX - internal.centerPt.x) * 180 / Math.PI + 90;
                internal.updateAngle(angleDeg);
            }
        }
    }

    /// Wheel Event handler
    WheelHandler {
        enabled: control.wheelEnabled
        onWheel: {
            var angleDeg = internal.angleProxy;
            if (event.angleDelta.y > 0)
                angleDeg += 1;
            else
                angleDeg -= 1;
            if (angleDeg < control.startAngle)
                angleDeg = control.endAngle;

            if (angleDeg > control.endAngle)
                angleDeg = control.startAngle;

            if ((angleDeg >= control.startAngle) && (angleDeg <= control.endAngle))
                internal.updateAngle(angleDeg);
        }
    }

    // Handle Item
    Item {
        id: handleItem

        x: control.width / 2 - width / 2
        y: control.height / 2 - height / 2
        width: control.handleWidth
        height: control.handleHeight
        antialiasing: true
        transform: [
            Translate {
                y: -(Math.min(control.width, control.height) / 2) + control.trackWidth / 2
            },
            Rotation {
                angle: control.angle
                origin.x: handleItem.width / 2
                origin.y: handleItem.height / 2
            }
        ]

        MouseArea {
            id: trackMouse

            function getVal() {
                var handlePoint = mapToItem(control, Qt.point(trackMouse.mouseX, trackMouse.mouseY));
                // angle in degrees
                var angleDeg = Math.atan2(handlePoint.y - internal.centerPt.y, handlePoint.x - internal.centerPt.x) * 180 / Math.PI + 90;
                internal.updateAngle(angleDeg);
            }

            anchors.fill: parent
            onPositionChanged: getVal()
            onClicked: getVal()
            cursorShape: Qt.SizeAllCursor
        }

        Loader {
            id: handleLoader

            sourceComponent: control.handle ? handle : handleComponent
        }
    }

    /// Default handle component
    Component {
        id: handleComponent

        Rectangle {
            width: control.handleWidth
            height: control.handleHeight
            color: "#17a8fa"
            radius: width / 2
            antialiasing: true
        }
    }

    Label {
        anchors.centerIn: parent
        color: "grey"
        text: Number(control.value).toFixed() + " - " + Number(control.angle).toFixed()
        rotation: -control.rotation
    }
}
