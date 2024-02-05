import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.15


ApplicationWindow  {
    id: rootWindow;
    title: "Tape-Line"

    visible: true
    property real flags1: Qt.WA_NoSystemBackground | Qt.WA_TranslucentBackground |
                          Qt.FramelessWindowHint   | Qt.WA_NoBackground;
    property real flags2: Qt.WA_NoSystemBackground | Qt.WA_TranslucentBackground |
                          Qt.FramelessWindowHint   | Qt.WA_NoBackground          |
                          Qt.WindowTransparentForInput;

    Item{
        id: __color
        property color green: "#00FF00"
        property color black: "#000000"
    }

    property color green: "#00FF00"
    property bool state: true
    property point start: rootWindow.end
    property point mid: rootWindow.start
    property point end: rootWindow.mid
    property real ab: Math.sqrt(Math.pow((rootWindow.start.x - rootWindow.mid.x), 2) + Math.pow((rootWindow.start.y - rootWindow.mid.y), 2))
    property real bc: Math.sqrt(Math.pow((rootWindow.mid.x - rootWindow.end.x), 2) + Math.pow((rootWindow.mid.y - rootWindow.end.y), 2))
    property real ca: Math.sqrt(Math.pow((rootWindow.start.x - rootWindow.end.x), 2) + Math.pow((rootWindow.start.y - rootWindow.end.y), 2))
    property real angle: Math.acos((Math.pow(rootWindow.ab, 2) + Math.pow(rootWindow.bc, 2) - Math.pow(rootWindow.ca, 2)) / (2 * rootWindow.ab * rootWindow.bc)) * 180 / Math.PI
    property bool visibleLine: rootWindow.start !== Qt.point(0, 0) & rootWindow.mid !== Qt.point(0, 0) & rootWindow.end !== Qt.point(0, 0)
    property bool radiusMode: false

    color: "transparent"
    Material.theme: Material.Dark
    flags: Qt.WA_NoSystemBackground | Qt.WA_TranslucentBackground |
           Qt.FramelessWindowHint   | Qt.WindowStaysOnTopHint     |
           Qt.WA_NoBackground       | Qt.WindowTransparentForInput;

    Shortcut {
        sequence: "Ctrl+E"
        context: Qt.ApplicationShortcut
        onActivated: { rootWindow.state ? rootWindow.flags = rootWindow.flags1 : rootWindow.flags = rootWindow.flags2; rootWindow.state = !rootWindow.state }
    }

    Shortcut {
        sequence: StandardKey.Quit
        context: Qt.ApplicationShortcut
        onActivated: { Qt.quit() }
    }

    Component.onCompleted: {
        rootWindow.x = Qt.application.screens[1 % (Qt.application.screens.length)].virtualX
        rootWindow.y = Qt.application.screens[1 % (Qt.application.screens.length)].virtualY
        rootWindow.visibility = Window.FullScreen
        rootWindow.visible = true
    }

    MouseArea {
        acceptedButtons: Qt.LeftButton
        anchors.fill: parent
        onPressed: {
            if(rootWindow.start === Qt.point(0, 0)){
                 rootWindow.start = Qt.point(mouse.x, mouse.y)
            }else if(rootWindow.mid === rootWindow.start){
                rootWindow.mid = Qt.point(mouse.x, mouse.y)
            }else if(rootWindow.end === rootWindow.mid){
                rootWindow.end = Qt.point(mouse.x, mouse.y)
            }
        }
    }

    Rectangle{
        visible: rootWindow.start !== Qt.point(0, 0)
        x: rootWindow.start.x - width/2
        y: rootWindow.start.y - height/2
        z: 10
        color: "black"
        width: 10
        height: width
        radius: width/2
        onXChanged: {
            if(!dragArea1.drag.active)
                return
            rootWindow.start = Qt.point(x + width/2, y + height/2)
        }
        onYChanged: {
            if(!dragArea1.drag.active)
                return
            rootWindow.start = Qt.point(x + width/2, y + height/2)
        }
        MouseArea{
            id: dragArea1
            enabled: parent.visible
            visible: parent.visible
            acceptedButtons: Qt.LeftButton
            anchors.fill: parent
            drag.target: parent
        }
    }

    Rectangle{
        visible: rootWindow.mid !== rootWindow.start
        x: rootWindow.mid.x - width/2
        y: rootWindow.mid.y - height/2
        z: 10
        color: "black"
        width: 10
        height: width
        radius: width/2
        onXChanged: {
            if(!dragArea2.drag.active)
                return
            rootWindow.mid = Qt.point(x + width/2, y + height/2)
        }
        onYChanged: {
            if(!dragArea2.drag.active)
                return
            rootWindow.mid = Qt.point(x + width/2, y + height/2)
        }
        MouseArea{
            id: dragArea2
            enabled: parent.visible
            visible: parent.visible
            acceptedButtons: Qt.LeftButton
            anchors.fill: parent
            drag.target: parent
        }
    }

    Rectangle{
        visible: rootWindow.end !== rootWindow.mid && rootWindow.end !== rootWindow.start
        x: rootWindow.end.x - width/2
        y: rootWindow.end.y - height/2
        z: 10
        color: "black"
        width: 10
        height: width
        radius: width/2
        onXChanged: {
            if(!dragArea3.drag.active)
                return
            rootWindow.end = Qt.point(x + width/2, y + height/2)
        }
        onYChanged: {
            if(!dragArea3.drag.active)
                return
            rootWindow.end = Qt.point(x + width/2, y + height/2)
        }

        MouseArea{
            id: dragArea3
            enabled: parent.visible
            visible: parent.visible
            acceptedButtons: Qt.LeftButton
            anchors.fill: parent
            drag.target: parent
        }
    }

    ParamLabel{
        id: abText
        point1: rootWindow.start
        point2: Qt.point(0, 0)
        text: (rootWindow.ab).toFixed(2)
    }

    ParamLabel{
        id: angleText
        point1: rootWindow.mid
        point2: rootWindow.start
        text: (rootWindow.angle).toFixed(2) + " °"
    }

    ParamLabel{
        id: bcText
        point1: rootWindow.end
        point2: rootWindow.mid
        visible: rootWindow.end !== rootWindow.mid && rootWindow.end !== rootWindow.start
        text: (rootWindow.bc).toFixed(2)
    }

    Shape{
        visible: rootWindow.visibleLine
        ShapePath{
            strokeColor: rootWindow.green
            strokeWidth: 1
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"
            dashPattern: [80, 20]
            startX: rootWindow.start.x; startY: rootWindow.start.y
            PathLine{ x: rootWindow.mid.x; y: rootWindow.mid.y }
        }
    }

    Shape{
        visible: rootWindow.visibleLine
        ShapePath{
            strokeColor: rootWindow.green
            strokeWidth: 1
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"
            dashPattern: [80, 20]
            dashOffset: 1000
            startX: rootWindow.end.x; startY: rootWindow.end.y
            PathLine{ x: rootWindow.mid.x; y: rootWindow.mid.y }
        }
    }

    Shape{
        visible: rootWindow.visibleLine && rootWindow.radiusMode
        ShapePath{
            strokeColor: rootWindow.green
            strokeWidth: 1
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"
            dashPattern: [80, 20]
            dashOffset: 1000
            PathAngleArc{ centerX: rootWindow.mid.x; centerY: rootWindow.mid.y; radiusX: rootWindow.ab; radiusY: radiusX; startAngle: 180; sweepAngle: 360 }
        }
    }

    Shape{
        visible: rootWindow.visibleLine && rootWindow.radiusMode
        ShapePath{
            strokeColor: rootWindow.green
            strokeWidth: 1
            strokeStyle: ShapePath.DashLine
            fillColor: "transparent"
            dashPattern: [80, 20]
            dashOffset: 1000
            PathAngleArc{ centerX: rootWindow.mid.x; centerY: rootWindow.mid.y; radiusX: rootWindow.bc; radiusY: radiusX; startAngle: 180; sweepAngle: 360 }
        }
    }

    ToolBarQ {}
    component ToolBarQ: Window {
        id: control;
        width: 400;
        height: width/8;
        x: rootWindow.x
        y: rootWindow.y
        Material.theme: Material.Dark
        visible: true;
        flags: Qt.WA_NoSystemBackground | Qt.WA_TranslucentBackground |
               Qt.FramelessWindowHint   | Qt.WindowStaysOnTopHint     |
               Qt.WA_NoBackground;
        color: "#00000000";

        Rectangle{
            anchors.fill: parent
            color: "#6699CC"
            RowLayout{
                anchors.centerIn: parent
                Button {
                    Layout.fillWidth: true
                    focus: true
                    onClicked:{ rootWindow.state ? rootWindow.flags = rootWindow.flags1 : rootWindow.flags = rootWindow.flags2; rootWindow.state = !rootWindow.state }
                    text: rootWindow.state ? "UnPressed" : "Pressed"
                }
                CheckBox{
                    id: radiusMode
                    text: "Radius Mode"
                    onClicked: rootWindow.radiusMode = !rootWindow.radiusMode
                }
                Label{
                    background: Rectangle{ color: "#336699" }
                    text: !rootWindow.state ? "\"Press Ctrl + E\" for quit" : ""
                }
            }
        }
    }

    component ParamLabel : Label{
        required property point point1;
        required property point point2;
        visible: point1 !== point2
        x: point1.x
        y: point1.y
        padding: 5
        background: Rectangle{ border.width: 1 }
        color: "black"
    }
}
