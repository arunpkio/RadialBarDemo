import QtQuick 2.7
import QtQuick.Window 2.2
import CustomControls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Window {
    id: root
    visible: true
    color: "#282a36"
    width: 1024
    height: 600
    title: qsTr("RadialBarShape Demo")

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
        }
    }
}
