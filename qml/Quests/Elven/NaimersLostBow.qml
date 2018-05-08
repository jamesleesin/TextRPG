import QtQuick 2.0
import "../"

Rectangle {
    id: naimerslostbow
    property string name: "NaimersLostBow"
    property string displayName: "Naimer's Lost Bow"
    property string shortDescription: "Find Naimer's lost bow and return it to him."
    property string fullDescription: "The old man Naimer lost his precious bow many years ago on a hunting trip. He would like to hold it again. Find his bow and return it to him."
    property string reward: "25g, 40XP"
    property variant rewardForParser: [25,40]
    property bool repeatable: false
    property string questType: "FIND"
    property variant questObjective: ["Elven/NaimersBow"]
    property string redeemAt: "Naimer"

    onChildrenChanged: {
        naimerslostbow.destroy();
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
        anchors.fill: parent
    }
}
