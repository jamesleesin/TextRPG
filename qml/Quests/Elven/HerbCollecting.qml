import QtQuick 2.0
import "../"

Rectangle {
    id: herbcollecting
    property string name: "HerbCollecting"
    property string displayName: "Herb Collecting"
    property string shortDescription: "Collect 5 Medicinal Herbs."
    property string fullDescription: "Always be prepared before going out to hunt! Collect 5 Medicinal Herbs and bring them to Alva."
    property string reward: "10g, 20XP"
    property variant rewardForParser: [10,20]
    property bool repeatable: false
    property string gotQuestFrom: ""
    property string questProgress: ""
    property string questType: "COLLECT"
    property variant questObjective: ["Medicinal Herb:5"]
    property string redeemAt: "Alva"
    property bool questComplete: false

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.rightMargin: 10
    height: children.length > 0 ? quest_container.height : 0
    radius: 8
    border.width: 3
    border.color: "black"
    color: "#ffffff"

    onChildrenChanged: {
        herbcollecting.destroy();
    }

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
