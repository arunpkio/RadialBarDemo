import QtQuick 2.7
import QtQuick.Window 2.2
import CustomControls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ApplicationWindow {
    id: appwnd
    visible: true
    width: 1200
    height: 720
    title: qsTr("Hello World")

    property int columns : 3
    property int rows : 2

    Rectangle {
        anchors.fill: parent
        color: "#1f225c"
    }

    GridView {
        id: grid
        anchors.fill: parent
        cellWidth: Math.max(width / 3, height/3);
        cellHeight: Math.max(width / 3, height/3)
        model: dashModel
        delegate : Rectangle {
            Layout.alignment: Layout.Center
            width: grid.cellWidth
            height: grid.cellHeight
            color: "#1d1d35"
            border.color: "#000000"
            border.width: 3

            Text {
                id: name
                text: tagName
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 10
                anchors.topMargin: 10
                font.pointSize: 13
                color: "#FAFAFA"
            }

            RadialBar {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                width: parent.width / 1.4
                height: width
                penStyle: Qt.RoundCap
                progressColor: "#00ffc1"
                foregroundColor: "#191a2f"
                dialWidth: 12
                minValue: minVal
                maxValue: maxVal
                value: actVal
                suffixText: suffix
                textFont {
                    family: "Halvetica"
                    italic: false
                    pointSize: 18
                }
                textColor: "#00ffc1"
            }
        }
        onWidthChanged: {
            grid.cellWidth = grid.width/appwnd.columns;
        }

        onHeightChanged: {
            grid.cellHeight = grid.height/appwnd.rows
        }
    }

    ListModel {
        id: dashModel
        ListElement {
            tagName: "Temperature"
            minVal: 0
            maxVal: 100
            actVal: 28
            suffix: "°"
        }
        ListElement {
            tagName: "Humidity"
            minVal: 0
            maxVal: 100
            actVal: 36
            suffix: "%"
        }
        ListElement {
            tagName: "Pressure"
            minVal: 0
            maxVal: 100
            actVal: 56
            suffix: " mBar"
        }
        ListElement {
            tagName: "Wind"
            minVal: 0
            maxVal: 200
            actVal: 12
            suffix: " MPH"
        }
        ListElement {
            tagName: "Battery"
            minVal: 0
            maxVal: 15
            actVal: 12.65
            suffix: " V"
        }
        ListElement {
            tagName: "Load"
            minVal: 0
            maxVal: 1000
            actVal: 425
            suffix: " mAmp"
        }
    }
}
