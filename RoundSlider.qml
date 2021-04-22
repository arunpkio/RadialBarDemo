import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Controls 2.15
import QtQml 2.15

Item {
    id: control

    implicitWidth: 300
    implicitHeight: 300

    property var centerPt: Qt.point(width / 2, height / 2)
    property real angle: mapFromValue(minValue, maxValue, startAngle, endAngle, control.value)

    readonly property alias actAngle: control.angle
    property int dialWidth: 20

    property real startAngle: 0
    property real endAngle: 360
    property real minValue: 0
    property real maxValue: 100
    property real value: 0
    property real newAngleValue: startAngle
    property bool setUpdatedValue: false
    property real handleOffset: 0.5

    property bool wheelEnabled: false

    property Component handle: null

    function mapFromValue(inMin, inMax, outMin, outMax, inValue) {
        return (inValue - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
    }

    function updateAngle(angleVal) {
        control.setUpdatedValue = true
        control.newAngleValue = Qt.binding(function() { return angleVal })
        control.setUpdatedValue = false
    }

    Binding {
        target: control
        property: "value"
        value: mapFromValue(startAngle, endAngle, minValue, maxValue, control.newAngleValue)
        when: control.setUpdatedValue
        restoreMode: Binding.RestoreBinding
    }

    Binding {
        target: control
        property: "angle"
        value: mapFromValue(minValue, maxValue, startAngle, endAngle, control.value)
        restoreMode: Binding.RestoreBinding
        when: control.setUpdatedValue
    }

    RadialBarShape {
        anchors.fill: parent
        value: control.angle - control.startAngle
        dialWidth: control.dialWidth
        minValue: 0
        maxValue: 360
        startAngle: 90 + control.startAngle
        progressColor: "#ff8d00"
        penStyle: Qt.FlatCap
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
                if((angleDeg >= control.startAngle) && (angleDeg <= control.endAngle)) {
                    control.updateAngle(angleDeg)
                }
            }
        }
    }

    /// Wheel Event handler
    WheelHandler {
        enabled: control.wheelEnabled
        onWheel: {
            var angleDeg = control.newAngleValue

            if(event.angleDelta.y > 0)
                angleDeg += 1
            else
                angleDeg -= 1

            if (angleDeg < control.startAngle)
                angleDeg = control.endAngle
            if(angleDeg > control.endAngle)
                angleDeg = control.startAngle
            if((angleDeg >= control.startAngle) && (angleDeg <= control.endAngle)) {
                control.updateAngle(angleDeg)
            }
        }
    }

    Item {
        id: handleContainer
        anchors.fill: parent

        transform: [
            Translate {
                x: Math.min(control.width, control.height) * control.handleOffset - handleLoader.width / 2
            },
            Rotation {
                angle: control.angle
                origin.x: control.width / 2
                origin.y: control.height / 2
            }
        ]
        Loader {
            id: handleLoader
            sourceComponent: control.handle ? handle : handleComponent
        }

        Item {
            parent: handleLoader
            x: control.width / 2 - width / 2
            y: control.height / 2 - height / 2
            width: handleLoader.width
            height: handleLoader.height

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
                    if((angleDeg >= control.startAngle) && (angleDeg <= control.endAngle)) {
                        control.updateAngle(angleDeg)
                    }
                }
            }
        }
    }

    /// Default handle component
    Component {
        id: handleComponent

        Rectangle {
            id: handleItem
            x: control.width / 2 - width / 2
            y: control.height / 2 - height / 2
            width: control.dialWidth
            height: control.dialWidth
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
