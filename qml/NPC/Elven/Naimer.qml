import QtQuick 2.0
import "../"

Rectangle {
    id: alva
    property string name: "Naimer"
    property string greeting: "The old man looks up as you approach him."
    property string doneQuestText: ""
    property string questOffered: "Elven/NaimersLostBow"

    width: parent.width
    height: npc.height
    border.width: 2
    border.color: "black"
    color: "transparent"

    NPC{
        id: npc
        name: parent.name
        greeting: parent.greeting
        doneQuestText: parent.doneQuestText
        questOffered: parent.questOffered
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
