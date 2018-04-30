import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3


Item {
    id: questContainer
    property string name: ""
    property string displayName: ""
    property string shortDescription: ""
    property string fullDescription: ""
    property string reward: ""
    property variant rewardForParser: []
    property bool repeatable: false
    property string gotQuestFrom: ""
    property string questProgress: ""
    property string redeemAt: ""
    // parser stuff
    property string questType: ""
    property variant questObjective: []
    property bool questComplete: false

    height: desc.height+20

    // check on and update quest progress
    // updates it to something like (0/5) or 22%
    function updateProgress(){
        var returnProgress = "";
        if (questType === "COLLECT"){
            var complete = true; // set true first
            for (var q = 0; q < questObjective.length; q++){
                if (q != 0) returnProgress += ", ";
                var what = questObjective[q].split(":")[0];
                var quantityNeeded = questObjective[q].split(":")[1];
                var quantityHave = 0;
                returnProgress += what + " (";
                if (what === "Metal"){
                    quantityHave = player.playerResourceCount[0];
                }
                else if (what === "Fur"){
                    quantityHave = player.playerResourceCount[1];
                }
                else if (what === "Medicinal Herb"){
                    quantityHave = player.playerResourceCount[2];
                }
                else if (what === "Arrow"){
                    quantityHave = player.playerResourceCount[3];
                }
                else if (what === "Magic Crystal"){
                    quantityHave = player.playerResourceCount[4];
                }
                // set false if any of the quantities are not met
                if (quantityHave < quantityNeeded){ complete = false; }
                returnProgress += quantityHave + "/" + quantityNeeded + ")";
            }
            questComplete = complete;
            questProgress = returnProgress;

            return questComplete;
        }

        questProgress = returnProgress;
        return false;
    }


    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked:{

        }
        onEntered:{
        }
        onExited: {
        }
    }

    Rectangle{
        id: desc
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: getHeight()
        anchors.margins: 10
        color: "transparent"

        function getHeight(){
            var h1 = questName.height + questDescription.height + questName.anchors.topMargin + questDescription.anchors.topMargin + questProgressText.height + questProgressText.anchors.topMargin + questCompleteText.height + questCompleteText.anchors.topMargin;
            var h2 = rewardText.height + questIssuer.height + ditchQuest.height + rewardText.anchors.topMargin + questIssuer.anchors.topMargin + ditchQuest.anchors.topMargin;
            if (h1 > h2){ return h1; }
            return h2;
        }

        Text{
            id: questName
            text: displayName
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 5
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            width: parent.width/2
            font.bold: true
        }
        Text{
            id: questDescription
            text: shortDescription
            anchors.top: questName.bottom
            anchors.left: parent.left
            anchors.margins: 5
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            width: parent.width/2
        }
        Text{
            id: questProgressText
            text: "Progress: " + questProgress
            anchors.top: questDescription.bottom
            anchors.left: parent.left
            anchors.margins: 5
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            width: parent.width/2
        }
        Text{
            id: questCompleteText
            text: questComplete ? "Complete!" : ""
            anchors.top: questProgressText.bottom
            anchors.left: parent.left
            anchors.margins: 5
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            width: parent.width/2
            font.bold: true
        }


        Text{
            id: rewardText
            text: "Reward: " + reward
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 5
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            wrapMode: Text.WordWrap
            width: parent.width/2
            font.bold: true
            horizontalAlignment: Text.AlignRight
        }
        Text{
            id: questIssuer
            text: "Got quest from: " + gotQuestFrom
            anchors.top: rewardText.bottom
            anchors.right: parent.right
            anchors.margins: 5
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            wrapMode: Text.WordWrap
            width: parent.width/2
            horizontalAlignment: Text.AlignRight
        }
        Rectangle{
            id: ditchQuest
            width: ditchQuestText.width+10
            height: ditchQuestText.height+8
            color: "white"
            border.width: 1
            border.color: "black"
            anchors.top: questIssuer.bottom
            anchors.right: parent.right
            anchors.topMargin: 30
            anchors.rightMargin: 5

            Text{
                id: ditchQuestText
                text: "Abandon"
                font.pointSize: root.tinyFontSize
                font.family: root.textFont
                color: root.textColor
                anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked:{
                    questContainer.destroy();
                }
                onEntered: {
                    parent.color = "lightgrey";
                }
                onExited: {
                    parent.color = "white";
                }
            }
        }
    }
}
