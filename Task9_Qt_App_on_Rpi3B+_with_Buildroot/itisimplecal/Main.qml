import QtQuick
import QtQuick.Controls
ApplicationWindow {
    id: root
    width: 400
    height: 500
    visible: true
    title: qsTr("Abdelfattah's Calculator")
    color: "#1a1a2e"


    //
    property string displayText: "0"
    property string currentExpression: ""
    //
    property real firstOperand: 0
    property real secondOperand: 0
    property real result: 0


    property string currentOperator: ""
    property bool waitingForOperand: false

    Column{
        id: mainlayout
        anchors.fill: parent
        spacing: 10


        Rectangle{
            id: display
            width: parent.width
            height: root.height *.25
            color: "#16213e"
            radius: 15

            Text {
                id: txtExpression
                text: root.currentExpression
                color: "#a0a0b0"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 20
                anchors.topMargin: 15
                font.pixelSize: 18
                font.bold: true
            }
            Text {
                id: txtDisplay
                text: root.displayText
                color: "white"
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
                anchors.bottomMargin: 15
                font.pixelSize: 42
                font.bold: true
            }

        }
        Rectangle{
            id: buttons
            width: parent.width
            height: root.height * .65
            color: "transparent"


            Grid{
                columns: 4
                spacing: 8
                anchors.centerIn: parent
                //Row 1
                CalcButton{ label: "C" ; btnColor: "#533483" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "⌫" ; btnColor: "#533483" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "%" ; btnColor: "#e94560" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "÷" ; btnColor: "#e94560" ; onClicked: {root.buttonPressed(label)} }
                //Row 2
                CalcButton{ label: "7" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "8" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "9" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "×" ; btnColor: "#e94560" ; onClicked: {root.buttonPressed(label)} }
                //Row 3
                CalcButton{ label: "4" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "5" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "6" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "-" ; btnColor: "#e94560" ; onClicked: {root.buttonPressed(label)} }
                //Row 4
                CalcButton{ label: "1" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "2" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "3" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "+" ; btnColor: "#e94560" ; onClicked: {root.buttonPressed(label)} }
                //Row 5
                CalcButton{ label: "0" ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "." ; btnColor: "#0f3460" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "=" ; btnColor: "#e94560" ; onClicked: {root.buttonPressed(label)} }
                CalcButton{ label: "ITI" ; btnColor: "#e94560" ; onClicked: {root.buttonPressed(label)} }


            }

        }


    }

    function buttonPressed(value){
        console.log("Pressed: "+value)
        if (value !== "+" && value !== "-" && value !== "×" &&
            value !== "÷" && value !== "%" && value !== "=" &&
            value !== "C" && value !== "⌫" && value !== "ITI"){
            if(waitingForOperand === true){
                displayText = value
                waitingForOperand = false
            }
            else if(displayText === "0"){
                displayText = value;
            }
            else{
                    displayText = displayText+value;
                }

        }
        else if(value === "C"){
            displayText="0"
            currentExpression = ""
            firstOperand = 0
            currentOperator = ""
            waitingForOperand = false
        }
        else if (value === "⌫") {
            // line 1: remove last character
            displayText = displayText.slice(0, -1)
            // line 2: check if it became empty, if yes set to "0"
            if(displayText.length == 0){
                displayText = "0"
            }
        }
        else if (value === "+" || value === "-" || value === "×" ||
                 value === "÷" || value === "%") {
            firstOperand = parseFloat(displayText)
            currentOperator = value
            currentExpression = displayText + value
            waitingForOperand = true
        }
        else if (value === "=") {
            secondOperand = parseFloat(displayText)
            currentExpression = currentExpression + displayText
            if (currentOperator === "+") {
                    result = firstOperand + secondOperand
                }
            else if(currentOperator === "-"){
                result = firstOperand - secondOperand
            }
            else if(currentOperator === "%"){
                result = firstOperand % secondOperand
            }
            else if(currentOperator === "×"){
                result = firstOperand * secondOperand
            }
            else if(currentOperator === "÷"){
                result = firstOperand / secondOperand
            }
            displayText=result.toString()
            currentExpression = firstOperand + " " + currentOperator + " " + secondOperand + " ="
            currentOperator = ""

        }
    }
}
