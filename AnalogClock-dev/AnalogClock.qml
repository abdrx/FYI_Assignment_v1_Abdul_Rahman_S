import QtQuick
import QtQuick.Layouts

Rectangle {
    id: equalWindowSizeRect
    property color clockBgColor: "White"
    property real hours: 0
    property real minutes: 0
    property real seconds: 0
    property string amPm: 'AM'

    property bool isHourSelected: false
    property bool isMinuteSelected: false
    property bool isSecondSelected: false
    property bool isTimerRunning: false


    function calculateTime() {
        var totalMinutesInClock = 12 * 60; // 12 hours on the clock, 60 minutes per hour
        var totalSecondsInClock = 60;


        //if(!isTimerRunning){
        // Calculate the hours, minutes, and seconds based on the angle rotations
        hours = Math.floor((hourHand.angleRotate / 360) * 12) % 12;
        minutes = Math.floor((minHand.angleRotate / 360) * 60) % 60;
        seconds = Math.floor((secondangle/ 360) * 60) % 60;

        // Check if the current time format is 12-hour
        var is12HourFormat = true; // Change this based on your logic

    }
    // Function to synchronize time and angles
    function synchronizeTimeAndAngles() {
        var hoursFraction = hours + minutes / 60; // Calculate the fraction of hours
        hourHand.angleRotate = (hoursFraction % 12) * 360 / 12;
        minHand.angleRotate = (minutes % 60) * 360 / 60;
        second.angleRotate = (seconds % 60) * 360 / 60;
    }

    // Example of when to call the synchronization function
    Component.onCompleted: {
        // Call this function when your application starts or when the user finishes setting the time
        //synchronizeTimeAndAngles();
    }




    Row {
        width: Math.min(equalWindowSizeRect.height, equalWindowSizeRect.width) * 1.2
        anchors.centerIn: parent
        spacing: 10 // optional: spacing between child elements
        Timer {
            id:jkjjk
            repeat: true
            interval: 1000
            running: true// Only run the timer in auto mode
            onTriggered: synchronizeTimeAndAngles();

            //print(manualSeconds);

        }

        Rectangle {
            id: clockRoot
            width: Math.min(equalWindowSizeRect.height, equalWindowSizeRect.width)
            height: width
            radius: width / 2
            anchors.centerIn: parent
            color: "White"
            border.color: "Black"
            border.width: 8

            NumberRepeater {
                id: repeaterNumbers
                anchors.fill: parent
                allTimeNumbers: true
            }

            QtObject {
                id: props
                property real handFactorGama: 0.4
            }

            MouseArea {
                anchors.fill: parent
                onMouseXChanged: {
                    if (isMinuteSelected||isHourSelected||isSecondSelected) {
                        switchtomanual();
                    }
                    var centerX = clockRoot.width / 2;
                    var centerY = clockRoot.height / 2;
                    var mouseX = mouse.x;
                    var mouseY = mouse.y;

                    var angleRad = Math.atan2(mouseY - centerY, mouseX - centerX);
                    var angleDeg = ((angleRad * 180 / Math.PI + 360 + 90) % 360 + 360) % 360;

                    if (isHourSelected) {
                        // Calculate the new angle for the hour hand based on its existing angle and minute hand movement
                        var newHourAngle = hourHand.angleRotate + (angleDeg - hourHand.angleRotate);

                        // Update the hour hand
                        hourHand.angleRotate = newHourAngle;

                        // Calculate the new angle for the minute hand based on the hour hand movement
                        minHand.angleRotate = newHourAngle * 12; // 12 times faster
                        second.angleRotate = newHourAngle * 360; // 60 times faster
                    } else if (isMinuteSelected) {
                        // Update the minute hand
                        minHand.angleRotate = angleDeg;

                        // Calculate the new angle for the hour hand based on its existing angle and minute hand movement
                        //hourHand.angleRotate += angleDeg > 357 ?  10 : 0.2;

                        // Calculate the new angle for the second hand based on the minute hand movement
                        second.angleRotate = angleDeg * 60; // 5 times faster
                    } else if (isSecondSelected) {
                        // Update the second hand
                        second.angleRotate = angleDeg;
                        minHand.angleRotate = second.angleRotate * 0.6;
                        secondangle  = angleDeg;
                    }
                    var totalMinutesInClock = 12 * 60; // 12 hours on the clock, 60 minutes per hour
                    var totalSecondsInClock = 60;

                    // Calculate the hours, minutes, and seconds based on the angle rotations
                    hours = Math.floor((hourHand.angleRotate / 360) * 12) % 12;
                    minutes = Math.floor((minHand.angleRotate / 360) * 60) % 60;
                    seconds = Math.floor((second.angleRotate / 360) * 60) % 60;


                    console.log("Angle (degrees): " + angleDeg);
                }
            }


            ClockHand {
                id: second
                anchors.horizontalCenter: clockRoot.horizontalCenter
                y: clockRoot.height / 2 - second.height
                width: clockRoot.width * 0.08
                height: clockRoot.height * 0.50
                angleRotate: equalWindowSizeRect.seconds * 360 / 60; // 12 hours format
                bgColor: isSecondSelected ? "green" : "red"
                TapHandler {
                    onTapped: {
                        switchtomanual();
                        isHourSelected = false;
                        isMinuteSelected = false;
                        isSecondSelected = true;
                        console.log("Second hand clicked");
                    }
                }
            }

            ClockHand {
                id: minHand
                anchors.horizontalCenter: clockRoot.horizontalCenter
                y: clockRoot.height / 2 - minHand.height
                width: clockRoot.width * 0.08
                height: clockRoot.height * 0.4
                angleRotate: equalWindowSizeRect.minutes * 360 / 60; // 12 hours format
                bgColor: isMinuteSelected ? "green" : "black"
                TapHandler {
                    onTapped: {
                        switchtomanual();
                        isHourSelected = false;
                        isMinuteSelected = true;
                        isSecondSelected = false;
                        console.log("Minute hand clicked");
                    }
                }
            }

            ClockHand {
                id: hourHand
                anchors.horizontalCenter: clockRoot.horizontalCenter
                y: clockRoot.height / 2 - hourHand.height
                width: minHand.width
                height: minHand.height * props.handFactorGama * 1.5
                angleRotate: equalWindowSizeRect.hours * 360 / 12; // 12 hours format
                bgColor: isHourSelected ? "green" : "black"
                TapHandler {
                    onTapped: {
                        switchtomanual();
                        isHourSelected = true;
                        isMinuteSelected = false;
                        isSecondSelected = false;
                        console.log("Hour hand clicked");


                    }}

            }

            Rectangle {
                width: 1
                height: 1
                radius: width / 1.5
                anchors.centerIn: parent
                color: "black"
            }

            Rectangle {
                width: Math.min(equalWindowSizeRect.height, equalWindowSizeRect.width) * 0.13
                height: Math.min(equalWindowSizeRect.height, equalWindowSizeRect.width) * 0.13
                radius: width / 1.5
                anchors.centerIn: parent
                color: "black"
            }

            Rectangle {
                width: Math.min(equalWindowSizeRect.height, equalWindowSizeRect.width) * 0.06
                height: Math.min(equalWindowSizeRect.height, equalWindowSizeRect.width) * 0.06
                radius: width / 1.5
                anchors.centerIn: parent
                color: "grey"
            }


        }


    }
}
