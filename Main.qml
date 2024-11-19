import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {

    Component.onCompleted: {
    }

    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    SpinBox {
        id: numberField
        width: 150
        from: 0
        to: 99999
        stepSize: 1
        value: 0
    }

    // Button underneath the number input field
    Button {
        text: "Submit"
        anchors.top: numberField.bottom
        width: 150
        onClicked: {
            scroller.setValue(numberField.value)
        }
    }

    NumberScroller{
        id: scroller
        anchors.centerIn: parent
    }

}
