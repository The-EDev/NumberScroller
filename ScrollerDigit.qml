import QtQuick
import QtQuick.Window

Rectangle {

    id: digit
    //anchors.centerIn: parent
    width: center.font.pixelSize*0.75
    height: width*1.5
    //color: "lightblue"
    clip: true

    property int _increment: 0;
    property bool _continue: false;
    property int initial_value: 0;
    property int value: initial_value;
    property int duration: 300;
    property double fontSize: 32;

    Text {
        id: above
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: digit.fontSize
        text: digit.initial_value != 0 ? digit.initial_value-1 : 9
    }
    Text {
        id: center
        anchors.top: digit.top
        anchors.bottom: digit.bottom
        anchors.horizontalCenter: digit.horizontalCenter
        font.pointSize: digit.fontSize
        text: digit.initial_value
    }
    Text {
        id: below
        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: digit.fontSize
        text: digit.initial_value != 9 ? digit.initial_value+1 : 0
    }

    states: [
    State {
            name: "decremented"
            AnchorChanges {target: above; anchors.top: digit.top; anchors.bottom: digit.bottom}
            AnchorChanges {target: center; anchors.top: digit.bottom; anchors.bottom: undefined}
        },
     State {
            name: "incremented"
            AnchorChanges {target: below; anchors.top: digit.top; anchors.bottom: digit.bottom}
            AnchorChanges {target: center; anchors.bottom: digit.top; anchors.top: undefined}
        },
    State {
        name: "default"
        AnchorChanges {target: above; anchors.top: undefined; anchors.bottom: digit.top; anchors.horizontalCenter: digit.horizontalCenter}
        AnchorChanges {target: center; anchors.top: digit.top; anchors.bottom: digit.bottom; anchors.horizontalCenter: digit.horizontalCenter}
        AnchorChanges {target: below; anchors.top: digit.bottom; anchors.bottom: undefined; anchors.horizontalCenter: digit.horizontalCenter}
    }
    ]

    transitions: Transition {
        AnchorAnimation {
            id: tran
            easing.type: Easing.InOutCubic
            duration: 0
        }

        onRunningChanged: {
            if (digit.state == "") {
                tran.duration = 0
                return
            }
            if ((digit.state != "default") && (!running)) {
                const inc = digit.state == 'incremented'
                center.text=inc? (center.text != 9 ? parseInt(center.text)+1 : 0) : (center.text != 0 ? parseInt(center.text)-1 : 9)
                below.text= inc? (below.text != 9 ? parseInt(below.text)+1 : 0)   : (below.text != 0 ? parseInt(below.text)-1 : 9)
                above.text= inc? (above.text != 9 ? parseInt(above.text)+1 : 0)   : (above.text != 0 ? parseInt(above.text)-1 : 9)
                tran.duration = 0
                digit.state = "default"
            }
            else  if (!running) {
                if (digit._increment != 0){
                    const inc = digit._increment > 0
                    digit.increment();
                    digit.state = inc ? "incremented" : "decremented"
                }
                else {
                    digit.state = ""
                }
            }
        }
    }

    function increment(){
        //console.log(digit._increment)
        // Refuse invalid values (only 0)
        if (digit._increment == 0) return

        const isOne = Math.abs(digit._increment) == 1
        //console.log(isOne)
        // Set appropriate easing
        if (isOne){
            // last element
            if (digit._continue) {
                tran.easing.type = Easing.OutCubic
                tran.duration = digit.duration
            }
            // only single element
            else {
                tran.easing.type = Easing.InOutCubic
                tran.duration = digit.duration
            }
        }
        else {
            // middle element
            if (digit._continue) {
                tran.easing.type = Easing.Linear
                tran.duration = digit.duration/3 // the linear continuation of an X^3 curve is approximately 3X (linear curve but 3 times sharper)
            }
            // first element
            else {
                tran.easing.type = Easing.InCubic
                tran.duration = digit.duration
            }
        }
        digit._continue = !isOne
        digit._increment > 0 ? digit._increment-- : digit._increment++
    }

    function calculateIncrement(){
        const currentVal = parseInt(center.text);
        const newVal = digit.value;
        const r = newVal - currentVal;
        const ar = Math.abs(r);

        if (r == 0) return;

        const f = ar > 5;

        digit._increment = f ? (10 - ar) * -r/ar : r;
    }

    onValueChanged: {
        digit._increment = 0
        calculateIncrement();
        digit.state = "default";
    }
}
