import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQml 2.15

Item {
    id: control

    /*!
        \qmlproperty real CircularSlider::trackWidth
        This property holds the width of the track arc.
    */
    property int trackWidth: 20

    /*!
        \qmlproperty real CircularSlider::progressWidth
        This property holds the width of the progress arc.
    */
    property int progressWidth: 10

    /*!
        \qmlproperty real CircularSlider::handleWidth
        This property holds the width of the default slider handle.
    */
    property int handleWidth: 20

    /*!
        \qmlproperty real CircularSlider::handleHeight
        This property holds the height of the default slider handle.
    */
    property int handleHeight: 20

    /*!
        \qmlproperty real CircularSlider::handleRadius
        This property holds the corner radius used to draw a rounded rectangle for the slider handle.
    */
    property int handleRadius: 10

    /*!
        \qmlproperty real CircularSlider::startAngle
        This property holds the start angle of the slider.
        The range is from \c 0 degrees to \c 360 degrees.
    */
    property real startAngle: 0

    /*!
        \qmlproperty real CircularSlider::endAngle
        This property holds the end angle of the slider.
        The range is from \c 0 degrees to \c 360 degrees.
    */
    property real endAngle: 360

    /*!
        \qmlproperty real CircularSlider::minimumValue
        This property holds the minimum value of the slider.
        The default value is \c{0.0}.
    */
    property real minValue: 0.0

    /*!
        \qmlproperty real CircularSlider::maximumValue
        This property holds the minimum value of the slider.
        The default value is \c{1.0}.
    */
    property real maxValue: 1.0

    /*!
        \qmlproperty real CircularSlider::value
        This property holds the current value of the slider.
        The default value is \c{0.0}.
    */
    property real value: 0.0

    /*!
        \qmlproperty real CircularSlider::angle
        \readonly
        This property holds the angle of the handle.
        The range is from \c 0 degrees to \c 360 degrees.
    */
    readonly property real angle: internal.mapFromValue(minValue, maxValue, startAngle, endAngle, control.value)

    /*!
      \qmlproperty enumeration CircularSlider::capStyle
      This property defines how the end points of lines are drawn. The default value is ShapePath.SquareCap.
     */
    property int capStyle: Qt.SquareCap

    /*!
      \qmlproperty real CircularSlider::trackColor
      This property holds the fill color for the track.
    */
    property color trackColor: "#FF005050"

    /*!
      \qmlproperty real CircularSlider::progressColor
      This property holds the fill color for the progress.
    */
    property color progressColor: "#FFA51BAB"


    /*!
      \qmlproperty bool CircularSlider::wheelEnabled
      This property determines whether the control handles wheel events. The default value is false.
    */
    property bool wheelEnabled: false

    /*!
      \qmlproperty real CircularSlider::handle
      This property holds the custom handle of the dial.
    */
    property Component handle: null

    /*!
        \qmlproperty bool CircularSlider::pressed
        \readonly
        This property indicates whether the slider handle is being pressed.
    */
    readonly property alias pressed: trackMouse.pressed

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
        property real baseRadius: Math.min(control.width / 2, control.height / 2) - Math.max(control.trackWidth, control.progressWidth) / 2
        property real actualSpanAngle: control.endAngle - control.startAngle
        property color transparentColor: "transparent"
        property color trackColor: control.trackColor
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
            id: trackShape

            strokeColor: control.trackColor
            fillColor: internal.transparentColor
            strokeWidth: control.trackWidth
            capStyle: control.capStyle

            PathAngleArc {
                radiusX: internal.baseRadius
                radiusY: internal.baseRadius
                centerX: control.width / 2
                centerY: control.height / 2
                startAngle: control.startAngle - 90
                sweepAngle: internal.actualSpanAngle
            }
        }

        ShapePath {
            id: progressShape

            strokeColor: control.progressColor
            fillColor: internal.transparentColor
            strokeWidth: control.progressWidth
            capStyle: control.capStyle

            PathAngleArc {
                radiusX: internal.baseRadius
                radiusY: internal.baseRadius
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
