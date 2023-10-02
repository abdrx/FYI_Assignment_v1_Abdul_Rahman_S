import QtQuick 2.0
import QtQuick.Shapes 1.2

Shape {
    id: handRoot
    // Properties for tracking dragging state
    property bool dragging: false
    property var dragStartPosition
    property real angleRotate: 0
    property color bgColor: "black"

    property int xValue: handRoot.angleRotate
    property var yValue


    transform: Rotation {
        origin.x: handRoot.width / 2;
        origin.y: handRoot.height;
        angle: handRoot.angleRotate
    }

    ShapePath {
        joinStyle: ShapePath.RoundJoin
        fillGradient: LinearGradient {
            x1: handRoot.width / 2; y1: 0
            x2: handRoot.width; y2: handRoot.height / 2
            GradientStop { position: 0; color: handRoot.bgColor }
        }
        startX: 0; startY: handRoot.height
        PathLine { x: handRoot.width / 2; y: 0 }
        PathLine { x: handRoot.width; y:  handRoot.height }
        PathLine { x: 0; y: handRoot.height }

    }

}
