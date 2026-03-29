import QtQuick

Rectangle {
    id: btn
    width: 80
    height: 60
    radius: 12
    visible: true

    property string label: "0"
    property string btnColor: "#0f3460"
    signal clicked()

    // Color: lighter when hovered, even lighter when pressed
    color: mouseArea.pressed ? Qt.lighter(btnColor, 1.5) :
           mouseArea.containsMouse ? Qt.lighter(btnColor, 1.3) : btnColor

    // Scale: shrinks when pressed
    scale: mouseArea.pressed ? 0.95 : 1.0

    // Smooth animations
    Behavior on color {
        ColorAnimation { duration: 150 }
    }
    Behavior on scale {
        NumberAnimation { duration: 100 }
    }

    Text {
        id: btnTxt
        text: btn.label
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 22
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            btn.clicked()
        }
    }
}
