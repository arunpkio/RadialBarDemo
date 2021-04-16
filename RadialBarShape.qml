import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    id: control

    implicitWidth: 200
    implicitHeight: 200

    enum DialType {
        FullDial,
        MinToMax,
        NoDial
    }

    property real startAngle: 0
    property real spanAngle: 360
    property real minValue: 0
    property real maxValue: 100
    property real value: 0
    property int dialWidth: 15

    property color backgroundColor: "transparent"
    property color dialColor: "#FF505050"
    property color progressColor: "#FFA51BAB"

    property int penStyle: Qt.RoundCap
    property int dialType: RadialBarShape.DialType.FullDial

    QtObject {
        id: internals

        property bool isFullDial: control.dialType === RadialBarShape.DialType.FullDial
        property bool isNoDial: control.dialType === RadialBarShape.DialType.NoDial

        property real baseRadius: Math.min(control.width / 2, control.height / 2)
        property real radiusOffset: internals.isFullDial ? control.dialWidth / 2
                                                         : control.dialWidth / 2
        property real actualSpanAngle: internals.isFullDial ? 360 : control.spanAngle

        property color transparentColor: "transparent"
        property color dialColor: internals.isNoDial ? internals.transparentColor
                                                     : control.dialColor
    }

    Shape {
        id: shape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 8

        ShapePath {
            id: pathBackground
            strokeColor: internals.transparentColor
            fillColor: control.backgroundColor
            capStyle: control.penStyle

            PathAngleArc {
                radiusX: internals.baseRadius - control.dialWidth
                radiusY: internals.baseRadius - control.dialWidth
                centerX: control.width / 2
                centerY: control.height / 2
                startAngle: 0
                sweepAngle: 360
            }
        }

        ShapePath {
            id: pathDial
            strokeColor: control.dialColor
            fillColor: internals.transparentColor
            strokeWidth: control.dialWidth
            capStyle: control.penStyle

            PathAngleArc {
                radiusX: internals.baseRadius - internals.radiusOffset
                radiusY: internals.baseRadius - internals.radiusOffset
                centerX: control.width / 2
                centerY: control.height / 2
                startAngle: control.startAngle - 90
                sweepAngle: internals.actualSpanAngle
            }
        }

        ShapePath {
            id: pathProgress
            strokeColor: control.progressColor
            fillColor: internals.transparentColor
            strokeWidth: control.dialWidth
            capStyle: control.penStyle

            PathAngleArc {
                radiusX: internals.baseRadius - internals.radiusOffset
                radiusY: internals.baseRadius - internals.radiusOffset
                centerX: control.width / 2
                centerY: control.height / 2
                startAngle: control.startAngle - 90
                sweepAngle: (internals.actualSpanAngle / control.maxValue * control.value)
            }
        }
    }
}
