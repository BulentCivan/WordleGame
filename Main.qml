import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Fusion
import QtQuick.Window
import Game 1.0


Window {
    width: 500
    height: 650
    visible: true
    title: "Wordle"

    WordOperator { id: operator }

    //THEME
    property bool darkMode: false
    property color bgColor:      darkMode ? "#1a1b1e" : "#ffffff"
    property color textColor:    darkMode ? "#e7e7e7" : "#222222"
    property color cardColor:    darkMode ? "#2b2d30" : "#f3f5fa"
    property color borderColor:  darkMode ? "#4d4f52" : "#cdd2dd"
    property color accent:       darkMode ? "#4ea1ff" : "#1d75ff"

    color: bgColor

    property string targetWord: operator.getRandomWord()
    property int tryCount: 0
    property string resultDialogText: ""
    property string warningText: ""


    ListModel { id: historyModel }

    //Dark mode extension
    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 12
        anchors.rightMargin: 16
        spacing: 6

        Text {
            text: darkMode ? "🌙" : "☀"
            font.pixelSize: 20
            color: textColor
        }

        Switch {
            checked: darkMode
            scale: 0.9
            onToggled: darkMode = !darkMode
        }
    }

    //Submit Guess
    function submitGuess() {
        let g = input.text.toUpperCase()

        if (g.length < 5) {
            warningText = "Word must be five letters!"
            warningDialog.open()
            return
        }

        for (let i = 0; i < historyModel.count; i++) {
                if (historyModel.get(i).guess === g) {
                    warningText = "You entered this word before.\n Please try new words!"
                    warningDialog.open()
                    input.text = ""
                    return
                }
            }

        if(!operator.isValidWord(g)) {
            warningText = "You entered invalid word.\n Please try new words!"
            warningDialog.open()
            input.text = ""
            return
        }

        let r = operator.checkGuess(g, targetWord)
        historyModel.append({
            num: tryCount+1,
            guess: g,
            correct:   r.correct.length   ? r.correct.join(", ")   : "-",
            misplaced: r.misplaced.length ? r.misplaced.join(", ") : "-"
        })

        tryCount++
        input.text = ""

        if(g === targetWord)
            resultDialogText = "Congratulations 🎉\n Word: " + targetWord
        else if(tryCount >= 6)
            resultDialogText = "You Lose ❗\n Word: " + targetWord
        else return

        resultDialog.open()
    }

    function restartGame() {
        historyModel.clear()
        tryCount = 0
        targetWord = operator.getRandomWord()
        input.text = ""
        resultDialog.close()
    }

    //UI
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20
        width: parent.width * 0.82

        Text {
            text: "W O R D L E"
            font.pixelSize: 34
            font.bold: true
            color: accent
            horizontalAlignment: Text.AlignHCenter
            width: parent.width

            font.letterSpacing: 2
        }


        Text {
            text: "Remaining tries: " + (6 - tryCount)
            font.pixelSize: 17
            color: textColor
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }

        //Getting input from user
        Row {
            spacing: 12
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: input
                width: 160
                maximumLength: 5
                onTextChanged: text = text.toUpperCase()
                Keys.onEnterPressed: submitGuess()
                Keys.onReturnPressed: submitGuess()
                color: textColor
                font.pixelSize: 16
                background: Rectangle {
                    radius: 9
                    color: cardColor
                    border.color: borderColor
                    border.width: 1
                }
            }

            Button {
                text:"Guess"
                onClicked: submitGuess()
                font.pixelSize: 14
                background: Rectangle {
                    radius: 9
                    color: accent
                }
            }
        }


        //showing previus guesses
        ScrollView {
            width: parent.width
            height: 350

            ListView {
                model: historyModel
                width: parent.width

                delegate: Rectangle {
                    radius: 12
                    color: cardColor
                    border.width: 1
                    border.color: borderColor
                    anchors.margins: 6

                    Column {
                        id: c
                        spacing: 4
                        anchors.margins: 10

                        Text { text:"Guess " + num; color:textColor; font.bold:true }
                        Text { text:"Word: " + guess; color:textColor }
                        Text { text:"Right Place: " + correct; color:textColor }
                        Text { text:"Wrong Place: " + misplaced; color:textColor }
                    }

                    implicitHeight: c.implicitHeight + 14
                }
            }
        }
    }


    //End of game and restart
    Dialog {
        id: resultDialog
        modal: true
        anchors.centerIn: Overlay.overlay
        width: 300

        background: Rectangle {
            radius: 18
            color: cardColor
            border.color: accent
            border.width: 2
        }

        contentItem: Column {
            spacing: 14
            padding: 20
            Text {
                text: resultDialogText
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: textColor
                width: parent.width
            }

            Button {
                text:"Play Again"
                font.pixelSize: 16
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: restartGame()
                background: Rectangle { radius: 10; color: accent }
            }
        }
    }

    Dialog {
        id: warningDialog
        modal: true
        width: 250
        anchors.centerIn: Overlay.overlay

        background: Rectangle {
            color: darkMode ? "#333" : "#fff"
            radius: 12
            border.color: "#D9534F"
            border.width: 2
        }

        contentItem: Column {
            spacing: 10
            padding: 20
            Text {
                text: warningText
                font.pixelSize: 15
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                color: textColor
            }
            Button {
                text: "Ok"
                onClicked: warningDialog.close()
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
