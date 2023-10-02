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

    // Define properties for storing the angles of your clock hands
    property int hourHandangle: 0
    property int minHandangle: 0
    property int secondangle: 0



    function calculateTime() {
        var totalMinutesInClock = 12 * 60; // 12 hours on the clock, 60 minutes per hour
        var totalSecondsInClock = 60;

        // Calculate the hours, minutes, and seconds based on the angle rotations
        hours = Math.floor((hourHand.angleRotate / 360) * 12);
        minutes = Math.floor((minHand.angleRotate / 360) * 60);
        seconds = Math.floor((second.angleRotate / 360) * 60);

        // Check if the current time format is 12-hour
        var is12HourFormat = true; // Change this based on your logic





        // Store the current angle rotations
        hourHandangle = hourHand.angleRotate;
        minHandangle = minHand.angleRotate;
        secondangle = second.angleRotate;

        manualHours = hours;
        manualSeconds =seconds;
        manualMinutes =manualMinutes;
        //console.log("Hours: " + hours + " Minutes: " + minutes + " Seconds: " + seconds);

        return {
            hours: hours,
            minutes: minutes,
            seconds: seconds
        };
    }




    Row {
        width: Math.min(equalWindowSizeRect.height, equalWindowSizeRect.width) * 1.2
            anchors.centerIn: parent
        spacing: 10 // optional: spacing between child elements
    /*Timer {
        repeat: true
        interval: 5000
        running: true // Only run the timer in auto mode
        onTriggered: {
            calculateTime();
            //print(manualSeconds);
        }
    }*/

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
                var centerX = clockRoot.width / 2;
                var centerY = clockRoot.height / 2;
                var mouseX = mouse.x;
                var mouseY = mouse.y;

                var angleRad = Math.atan2(mouseY - centerY, mouseX - centerX);
                var angleDeg = ((angleRad * 180 / Math.PI + 360 + 90) % 360 + 360) % 360;

                if (isHourSelected) {
                    hourHand.angleRotate = angleDeg;
                } else if (isMinuteSelected) {
                    minHand.angleRotate = angleDeg;
                } else if (isSecondSelected) {
                    second.angleRotate = angleDeg;
                }
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
            /*TapHandler { onTapped: {
            switchtomanual();
            isHourSelected = true;
            isMinuteSelected = false;
            isSecondSelected = false;
            console.log("Hour hand clicked");


                }}*/

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


    } }

