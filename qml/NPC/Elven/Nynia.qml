import QtQuick 2.0
import "../"

Rectangle {
    id: nynia
    property string name: "Bartender Nynia"
    property string greeting: "How can I help you?"
    property string doneQuestText: "Isn't Eomund incredible? I don't know how he can just sit there and read all day. He might not look it, but he loves talking about Elvish history. Go see him again if you want to learn more!"
    property string questOffered: "Elven/LivingHistory"

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
