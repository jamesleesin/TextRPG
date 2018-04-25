import QtQuick 2.0
import "../"

Rectangle {
    id: alva
    property string name: "Alva"
    property string greeting: "Hello there!"
    property string questOffered: "Elven/HerbCollecting"

    width: parent.width
    height: npc.height
    border.width: 2
    border.color: "black"
    color: "#ffffff"

    NPC{
        id: npc
        name: parent.name
        greeting: parent.greeting
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
