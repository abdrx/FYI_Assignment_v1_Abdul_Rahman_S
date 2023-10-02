import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
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
    //time
    property var timer ;

    Component.onCompleted: {
        setsystemTime();
        playTimeFromManualPosition();
            // This code will run when the QML component is fully created and ready.
            console.log("QML page has started.");
            // Add your initialization code here.
        }
    function switchtomanual() {
        manualHours = analogClockQML.hours;
        manualMinutes = analogClockQML.minutes;
        manualSeconds =analogClockQML.seconds;
        manualMode = true;
    }

    function updateCurrentTime() {
        if (manualMode) {
            // Update the clock time manually
           // analogClockQML.minutes = manualMinutes
           // analogClockQML.hours = manualHours
            //analogClockQML.seconds = manualSeconds
        }
    }

    function setsystemTime(){
        var currentDateTime = new Date();

        var hours24 = currentDateTime.getHours();
        var hours12 = hours24 > 12 ? hours24 - 12 : hours24;
        var amPm = hours24 >= 12 ? "PM" : "AM";

        analogClockQML.minutes = currentDateTime.getMinutes();
        analogClockQML.hours = hours12;
        analogClockQML.seconds = currentDateTime.getSeconds();
        analogClockQML.amPm = amPm; // Store AM/PM indicator

        manualHours = analogClockQML.hours;
        manualMinutes = analogClockQML.minutes;
        manualSeconds =analogClockQML.seconds;


        playTime = true;

    }

    //var timer; // Declare the timer as a global variable

    function playTimeFromManualPosition() {
        if (playTime && !timer) { // Check if playTime is true and there's no existing timer
            // Save the manual position
            var savedManualMinutes = manualMinutes;
            var savedManualHours = manualHours;
            var savedManualSeconds = manualSeconds;

            // Update the clock time manually to the saved position
            analogClockQML.minutes = savedManualMinutes;
            analogClockQML.hours = savedManualHours;
            analogClockQML.seconds = savedManualSeconds;

            // Create and start a timer to increment the time automatically

            timer = Qt.createQmlObject('import QtQuick 2.15; Timer {}', mainwindow);
            timer.interval = 1000; // 1 second interval
            timer.repeat = true;
            timer.triggered.connect(function () {
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
            });

            // Start the timer
            timer.start();
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
            repeat: true
            interval: 50
            running: true//!manualMode // Only run the timer in auto mode
            onTriggered: {
                //updateClockTime();
                updateCurrentTime();
                playTimeFromManualPosition();

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
                           analogClockQML.amPm ;
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
                        color: "White"  // Change color in auto mode
                        border.color: "black"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: setsystemTime();
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
                        color: playTime == true ? "Green" : "White"  // Change color in auto mode
                        border.color: "black"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                playTime = !playTime;
                                if(playTime==false){
                                timer.destroy();
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
