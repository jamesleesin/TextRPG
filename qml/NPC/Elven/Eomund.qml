import QtQuick 2.0
import "../"

Rectangle {
    id: eomund
    property string name: "Eomund, Keeper of Scrolls"
    property string greeting: "Greetings, friend."
    property string doneQuestText: ""
    property string questOffered: ""
    property bool hasTalkToQuest: true

    width: parent.width
    height: npc.height
    border.width: 2
    border.color: "black"
    color: "transparent"

    // Trigger a talk to quest event
    function checkForTalkToQuest(){
        root.checkForTalkToQuest(this);
    }

    NPC{
        id: npc
        name: parent.name
        greeting: parent.greeting
        doneQuestText: parent.doneQuestText
        hasTalkToQuest: parent.hasTalkToQuest
        questOffered: parent.questOffered
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
