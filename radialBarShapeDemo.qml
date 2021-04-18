import QtQuick 2.15
import QtQuick.Window 2.2
import CustomControls 1.0
import QtQuick.Controls 2.15
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15

Window {
    id: root
    visible: true
    color: "#282a36"
    width: 1024
    height: 600
    title: qsTr("RadialBarShape Demo")

//    property int radius: 100

//        Rectangle {
//            id: circle
//            width: 200 //* radius
//            height: 200 //* radius
//            radius: width/2 //root.radius

//            color: 'blue'
//        }

//        Rectangle {
//            id: mark
//            width: 20
//            height: 20
//            x: (dragObj.dragRadius <= root.radius ? dragObj.x : root.radius + ((dragObj.x - root.radius) * (root.radius / dragObj.dragRadius))) - 10
//            y: (dragObj.dragRadius <= root.radius ? dragObj.y : root.radius + ((dragObj.y - root.radius) * (root.radius / dragObj.dragRadius))) - 10
//            color: 'red'

//            MouseArea {
//                id: markArea
//                anchors.fill: parent
//                drag.target: dragObj
//                onPressed: {
//                    dragObj.x = mark.x + 10
//                    dragObj.y = mark.y + 10
//                }
//            }
//        }

//        Item {
//            id: dragObj
//            readonly property real dragRadius: Math.sqrt(Math.pow(x - root.radius, 2) + Math.pow(y - root.radius, 2))
//            x: root.radius
//            y: root.radius

//            onDragRadiusChanged: console.log(dragRadius)
//        }

    QtObject {
        id: feeder

        property real value: 0

        SequentialAnimation on value {
            loops: Animation.Infinite
            NumberAnimation { to: 100; duration: 2000 }
            NumberAnimation { to: 0; duration: 2000 }
        }
    }


    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            RadialBarShape {
                value: feeder.value
            }
            RadialBarShape {
                Layout.preferredHeight: 300
                Layout.preferredWidth: 300
                progressColor: "#e6436d"
                value: feeder.value
                spanAngle: 270
                dialType: RadialBarShape.DialType.FullDial
                backgroundColor: "#6272a4"
                penStyle: Qt.FlatCap
                dialColor: "transparent"
            }
            RadialBarShape {
                progressColor: "#8be9fd"
                value: feeder.value
                spanAngle: 270
                dialType: RadialBarShape.DialType.NoDial
                dialColor: Qt.darker("#8be9fd", 3.8)
                penStyle: Qt.SquareCap
                dialWidth: 10
            }
            RadialBarShape {
                id: newone
                progressColor: "#50fa7b"
                value: feeder.value
                startAngle: 90
                spanAngle: 270
                dialType: RadialBarShape.DialType.MinToMax
                backgroundColor: "#6272a4"
                dialWidth: 5
            }
//            visible: false
        }
    }

    ColumnLayout {
        spacing: 20
        anchors.centerIn: parent

        RadialBarShape {
            id: progress
            value: slider.value
            Layout.alignment: Qt.AlignHCenter

            Item {
                id: triangleContainer
                width: 20
                height: parent.height / 2 + progress.dialWidth
                x: parent.width / 2 - width / 2
                y: -progress.dialWidth - 10

                Shape {
                    id: triangle
                    width: parent.width
                    height: width

                    ShapePath {
                        startX: triangle.width / 2
                        startY: 0
                        fillColor: "orange"
                        strokeColor: "orange"
                        PathLine { x: 0; y: 0 }
                        PathLine { x: triangle.width; y: 0 }
                        PathLine { x: triangle.width/2; y: triangle.height}
                        PathLine { x: 0; y: 0}

                    }
                }

                transform: Rotation {
                    id: minuteRotation
                    origin.x: triangleContainer.width / 2
                    origin.y: triangleContainer.height + 10
//                    angle: progress.angle
                    angle: tracker.value
                    Behavior on angle {
                        SpringAnimation { spring: 2; damping: 0.2}
                    }
                }
            }
        }

        Slider {
            id: slider
            Layout.fillWidth: true
            minimumValue: 0
            maximumValue: 100
        }

        Dial {
            id: control
            background: Rectangle {
                x: control.width / 2 - width / 2
                y: control.height / 2 - height / 2
                width: Math.max(0, Math.min(control.width, control.height))
                height: width
                color: "transparent"
                radius: width / 2
                border.color: control.pressed ? "#17a81a" : "#21be2b"
                opacity: control.enabled ? 1 : 0.3
            }

            handle: Rectangle {
                id: handleItem
                x: control.background.x + control.background.width / 2 - width / 2
                y: control.background.y + control.background.height / 2 - height / 2
                width: 16
                height: 16
                color: control.pressed ? "#17a81a" : "#21be2b"
                radius: 8
                antialiasing: true
                opacity: control.enabled ? 1 : 0.3
                transform: [
                    Translate {
                        y: -Math.min(control.background.width, control.background.height) * 0.5 + handleItem.height / 2
                    },
                    Rotation {
                        angle: control.angle
                        origin.x: handleItem.width / 2
                        origin.y: handleItem.height / 2
                    }
                ]
            }
        }
    }

    RoundSlider {
        x: 20
        y: 20
//        visible: false
    }

    Dial {
        x: 200
        y: 400
    }

    Rectangle {
        id: tracker
        width: 20
        height: 20
        color: "green"
        x: 200
        y: 400

        property real value: 0

//        SequentialAnimation on value {
//            running: true
//            NumberAnimation { from: 0; to: 10; duration: 4000 }
//        }

        onValueChanged: {
//            tracker.x = (300 + Math.cos(tracker.value) * 100)
//            tracker.y= (400 + Math.sin(tracker.value) * 100)
            console.log("val = " + value)
        }

        DragHandler {

        }

        onXChanged: calculateAngle()
        onYChanged: calculateAngle()

        function calculateAngle() {
            var delta = Qt.point(tracker.x, tracker.y)
            console.log(delta)
            var radians = tracker.circularPositionAt(delta)
//            console.log(radians * (180/Math.PI))
            tracker.value = radians * (180/Math.PI)
        }

        PropertyChanges {
            target: tracker
            x: (300 + Math.cos(tracker.value) * 100)
            y: (400 + Math.sin(tracker.value) * 100)
        }


        MouseArea {
            anchors.fill: parent
            property var buttonPressPosition: "1,1"
            onPressed: buttonPressPosition  = Qt.point(mouse.x,mouse.y)
            enabled: false
            onPositionChanged: {
                var delta = Qt.point(tracker.x, tracker.y) //Qt.point(mouse.x-buttonPressPosition.x, mouse.y-buttonPressPosition.y)
                var center = Qt.point(300, 400)
                var pt = Qt.point(delta.x() - center.x(), delta.y() - center.y())
                console.log(pt)
                var radians = tracker.circularPositionAt(delta)
//                console.log(radians * (180/Math.PI))
                tracker.value = radians * (180/Math.PI)
            }
        }

        function circularPositionAt(point)
        {
            var startAngleRadians = 0//(Math.PI * 2.0) * (4.0 / 6.0);
            var endAngleRadians = 3.14// (Math.PI * 2.0) * (5.0 / 6.0);
            var yy = height / 2.0 - point.y;
            var xx = point.x - width / 2.0;
            var angle = (xx || yy) ? Math.atan2(yy, xx) : 0;
            if (angle < Math.PI / -2)
                angle = angle + Math.PI * 2;
            var normalizedAngle = (startAngleRadians - angle) / endAngleRadians;
//            console.log("angle = " + angle)
            return normalizedAngle;
        }

    }
}
