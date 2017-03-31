import QtQuick 2.7
import QtQuick.Window 2.2
import CustomControls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Window {
    visible: true
    width: 1200
    height: 1100
    title: qsTr("Hello World")

    Rectangle {
        anchors.fill: parent
        color: "#1d1d35"
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 50
        RowLayout {
            id: layout
            spacing: 30
            RadialBar {
                width: 300
                height: 300
                penStyle: Qt.RoundCap
                dialType: RadialBar.FullDial
                progressColor: "#1dc58f"
                foregroundColor: "#191a2f"
                dialWidth: 30
                startAngle: 180
                spanAngle: 70
                minValue: 0
                maxValue: 100
                value: 50
                textFont {
                    family: "Halvetica"
                    italic: false
                    pointSize: 16
                }
                suffixText: "%"
                textColor: "#FFFFFF"
            }

            RadialBar {
                width: 300
                height: 300
                penStyle: Qt.RoundCap
                dialType: RadialBar.FullDial
                progressColor: "#c61e5d"
                foregroundColor: "#191a2f"
                dialWidth: 30
                startAngle: 180
                spanAngle: 180
                minValue: 0
                maxValue: 100
                value: 80
                textFont {
                    family: "Consolas"
                    italic: false
                    pointSize: 32
                }
                suffixText: "°"
                textColor: "#c61e5d"
            }

            RadialBar {
                width: 300
                height: 300
                penStyle: Qt.RoundCap
                dialType: RadialBar.FullDial
                progressColor: "#1e5dc6"
                foregroundColor: "#191a2f"
                dialWidth: 30
                startAngle: 180
                spanAngle: 280
                minValue: 0
                maxValue: 100
                value: 68
                textFont {
                    family: "Encode Sans"
                    italic: false
                    pointSize: 24
                }
                suffixText: "%"
                textColor: "#1e5dc6"
            }
        }

        RowLayout {
            id: layout1
            spacing: 30
            RadialBar {
                penStyle: Qt.FlatCap
                dialType: RadialBar.FullDial
                progressColor: "#e67f22"
                foregroundColor: "#bec3c7"
                dialWidth: 15
                startAngle: 180
                minValue: 0
                maxValue: 100
                value: 45
                textFont {
                    family: "Halvetica"
                    italic: false
                    pointSize: 22
                }
                suffixText: "%"
                textColor: "#7c8688"
            }

            RadialBar {
                width: 300
                height: 300
                penStyle: Qt.FlatCap
                dialType: RadialBar.FullDial
                progressColor: "#8e42ae"
                foregroundColor: "#bec3c7"
                dialWidth: 15
                startAngle: 180
                minValue: 0
                maxValue: 100
                value: 75
                textFont {
                    family: "Consolas"
                    italic: false
                    pointSize: 22
                }
                suffixText: "°"
                textColor: "#7c8688"
            }

            RadialBar {
                width: 300
                height: 300
                smooth: true
                penStyle: Qt.FlatCap
                dialType: RadialBar.FullDial
                progressColor: "#e84c3d"
                foregroundColor: "#bec3c7"
                dialWidth: 15
                startAngle: 180
                minValue: 0
                maxValue: 100
                value: 95
                textFont {
                    family: "Encode Sans"
                    italic: false
                    pointSize: 32
                }
                suffixText: "%"
                textColor: "#7c8688"
            }
        }

        RowLayout {
            id: layout2
            spacing: 30
            RadialBar {
                width: 300
                height: 300
                penStyle: Qt.FlatCap
                dialType: RadialBar.NoDial
                progressColor: "#3498db"
                backgroundColor: "#34495e"
                dialWidth: 20
                startAngle: 0
                spanAngle: 270
                minValue: 0
                maxValue: 100
                value: 30
                textFont {
                    family: "Consolas"
                    italic: false
                    pointSize: 32
                }
                suffixText: "%"
                textColor: "#FFFFFF"
            }

            RadialBar {
                width: 300
                height: 300
                penStyle: Qt.FlatCap
                dialType: RadialBar.NoDial
                progressColor: "#c61e5d"
                backgroundColor: "#34495e"
                dialWidth: 20
                startAngle: 0
                spanAngle: 180
                minValue: 0
                maxValue: 100
                value: 60
                textFont {
                    family: "Consolas"
                    italic: false
                    pointSize: 32
                }
                suffixText: "°"
                textColor: "#FFFFFF"
            }

            RadialBar {
                width: 300
                height: 300
                penStyle: Qt.FlatCap
                dialType: RadialBar.NoDial
                progressColor: "#e2801d"
                backgroundColor: "#34495e"
                dialWidth: 20
                startAngle: 0
                spanAngle: 320
                minValue: 0
                maxValue: 100
                value: 90
                textFont {
                    family: "Consolas"
                    italic: false
                    pointSize: 32
                }
                suffixText: "%"
                textColor: "#FFFFFF"
            }
        }
    }
}
