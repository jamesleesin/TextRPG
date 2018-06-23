import QtQuick 2.0
import "../"

Rectangle {
    id: livinghistory
    property string name: "LivingHistory"
    property string displayName: "Living History"
    property string shortDescription: "Find the old scrollkeeper Eomund and learn about Elven history."
    property string fullDescription: "Nynia seems to think that Eomund can teach you much about Elven history. Find him and talk to him."
    property string reward: "0g, 20XP"
    property variant rewardForParser: [0,20]
    property bool repeatable: false
    property string questType: "TALKTO"
    property variant questObjective: ["Eomund, Keeper of Scrolls"]
    property string redeemAt: "Eomund, Keeper of Scrolls"
    property bool talkedToNPCYet: false // for talkto quests

    onChildrenChanged: {
        livinghistory.destroy();
    }

    /////////////// dont change below here ///////////////////////////////
    property string gotQuestFrom: ""
    property string questProgress: ""
    property bool questComplete: false

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.rightMargin: 10
    height: children.length > 0 ? quest_container.height : 0
    radius: 8
    border.width: 3
    border.color: "black"
    color: "#ffffff"

    function updateProgress(){
        // returns true if quest is complete
        questComplete = quest_container.updateProgress();
    }

    QuestContainer{
        id: quest_container
        name: parent.name
        displayName: parent.displayName
        shortDescription: parent.shortDescription
        fullDescription: parent.fullDescription
        reward: parent.reward
        rewardForParser: parent.rewardForParser
        repeatable: parent.repeatable
        gotQuestFrom: parent.gotQuestFrom
        questProgress: parent.questProgress
        questType: parent.questType
        questObjective: parent.questObjective
        redeemAt: parent.redeemAt
        talkedToNPCYet: parent.talkedToNPCYet
        anchors.fill: parent
    }
}
