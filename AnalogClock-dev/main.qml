import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import "qrc:/AnalogClockComponents" as Clock

Window {
    width: 900
    height: 700
    visible: true
    title: qsTr("Assignment v1.0")
    id:mainwindow

    // Add a property to track the clock mode
    property bool manualMode: false
    property bool playTime: true

    // Add properties for manual time
    property int manualHours:12
    property int manualMinutes:0
    property int manualSeconds:0


    Component.onCompleted: {
        setSystemTime();
        playTimeFromManualPosition();
        // This code will run when the QML component is fully created and ready.
        console.log("QML page has started.");
        // Add your initialization code here.
    }
    function switchtomanual() {
        playTime = false;
        if (timerid.running) {
            timerid.stop();
        }

        manualMode = true;
    }

    function updateAmPm() {
        var currentHour = analogClockQML.hours;
        analogClockQML.amPm = currentHour > 11 ? "PM" : "AM";
    }

    function setSystemTime() {
        manualMode = false;
        analogClockQML.isHourSelected = false;
        analogClockQML.isMinuteSelected = false;
        analogClockQML.isSecondSelected = false;


        var currentDateTime = new Date();

        var hours24 = currentDateTime.getHours();
        var hours12 = hours24 > 12 ? hours24 - 12 : hours24;
        var amPm = hours24 >= 12 ? "PM" : "AM";

        analogClockQML.minutes = currentDateTime.getMinutes();
        analogClockQML.hours = hours12;
        analogClockQML.seconds = currentDateTime.getSeconds();
        analogClockQML.amPm = amPm;
        playTimeFromManualPosition();
    }
    function playTimeFromManualPosition() {
        analogClockQML.isTimerRunning = true;
        if (playTime) {
            if (!timerid.running) {
                // Start the timer
                timerid.start();

            }
        } else {
            if (timerid.running) {
                // Stop the timer
                timerid.stop();
            }
        }
    }


    RowLayout {
        anchors.fill: parent
        Clock.AnalogClock {
            id: analogClockQML
            Layout.fillHeight: true
            Layout.fillWidth: true


        }

        Timer {
            id: timerid
            interval: 1000 // 1 second interval
            repeat: true
            running: true // Start the timer

            onTriggered: {
                updateAmPm(); // Update the AM/PM indicator
                //(analogClockQML.seconds % 60) * 360 / 60;
                // Increment the time
                analogClockQML.seconds++;
                if (analogClockQML.seconds >= 60) {
                    analogClockQML.seconds = 0;
                    analogClockQML.minutes++;
                    if (analogClockQML.minutes >= 60) {
                        analogClockQML.minutes = 0;
                        analogClockQML.hours++;
                        if (analogClockQML.hours >= 12) {
                            analogClockQML.hours = 0;
                        }
                    }
                }

            }
        }


        Rectangle {
            width: mainwindow.width * 0.02
        }
        Rectangle {
            height: mainwindow.height * 0.50
            width: mainwindow.width * 0.30
            radius: 5
            border.color: "black" // Set the border color to black
            border.width: 2 // Set the border width (optional)

            ColumnLayout {
                anchors.centerIn: parent // Center the ColumnLayout within the parent item
                Text {
                    id: currentTime
                    font.pointSize: 24
                    text: "Time Now  \n " +
                    (analogClockQML.hours == 0 ? "12" : analogClockQML.hours.toString()) +
                    ":" +
                    analogClockQML.minutes.toString().padStart(2, '0') +
                    ":" +
                    analogClockQML.seconds.toString().padStart(2, '0') +
                    " " +
                    analogClockQML.amPm
                    font.family: "Broadway"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    //anchors.fill: parent // This ensures the Text element fills its parent
                }
                RowLayout {
                    spacing: 10 // Adjust the spacing between items as needed

                    Rectangle {
                        id : systemTime
                        width: 100
                        height: 50
                        radius: 5
                        color: "White" // Change color in auto mode
                        border.color: "black"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: setSystemTime();
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Reset"
                            font.pixelSize: 10
                        }
                    }

                    Rectangle {
                        id : playfromManual
                        width: 100
                        height: 50
                        radius: 5
                        color: playTime == true ? "Green" : "White" // Change color in auto mode
                        border.color: "black"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                playTime = !playTime;
                                if (playTime==false) {
                                    timerid.stop();
                                }
                                manualMode = false;
                                analogClockQML.isHourSelected = false;
                                analogClockQML.isMinuteSelected = false;
                                analogClockQML.isSecondSelected = false;
                                playTimeFromManualPosition();

                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Play Time"
                            font.pixelSize: 10
                        }
                    }
                }



            }
        }
        Rectangle {
            width: mainwindow.width * 0.02
        }

    }
}
