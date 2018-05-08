import QtQuick 2.0
import "../"

Rectangle {
    id: wolfhunter
    property string name: "WolfHunter"
    property string displayName: "Wolf Hunter"
    property string shortDescription: "Defeat 5 wolves."
    property string fullDescription: "The wolf population has grown too large of late. Help bring down the population a little to restore balance."
    property string reward: "50g, 50XP"
    property variant rewardForParser: [50,50]
    property bool repeatable: true
    property string questType: "KILL"
    property variant questObjective: ["Wolf:5"]
    property string redeemAt: "Alva"
    property variant numToKillRemaining: [5]

    onChildrenChanged: {
        wolfhunter.destroy();
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
        numToKillRemaining: parent.numToKillRemaining
        anchors.fill: parent
    }
}
