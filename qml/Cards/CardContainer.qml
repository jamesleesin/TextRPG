import QtQuick 2.0

Item {
    id: cardContainer
    property string name: ""
    property string displayName: ""
    property string cardClass: ""
    property string condition: ""
    property int power: 0
    property string cost: ""
    property string effect: ""
    property string effectForParser: ""
    property string cardType: ""
    property string cardColor: getCardColor()
    property string useCardText: ""
    property bool selected: false
    property int cardNumber: 0
    property bool selfCast: false

    property variant resourceNames: ["Metal", "Fur", "Medicinal Herb", "Arrow", "Magic Crystal"]

    Timer{
        id: hoverTimer
        interval: 250
        running: false
        onTriggered: {
            root.previewCard(cardContainer);
        }
    }

    Component{
        id: single_cost

        Row{
            id: singleCost
            property string src: ""
            property int amt: 0
            height:30
            spacing: 5

            Image{
                id: icon
                source: singleCost.src
                width: 30
                height: 30
            }
            Text{
                id: cardCost
                text: singleCost.amt
                font.pointSize: root.tinyFontSize
                font.family: root.textFont
                color: root.textColor
                height: 30
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    function getCardColor(){
        var colorString = "";
        // different colors based on scaling
        if (effectForParser.indexOf("STRENGTH") >= 0){
            colorString += root.strengthColor + ":";
        }
        if (effectForParser.indexOf("DEXTERITY") >= 0){
            colorString += root.dexterityColor + ":";
        }
        if (effectForParser.indexOf("SPELLPOWER") >= 0){
            colorString += root.spellpowerColor + ":";
        }
        if (effectForParser.indexOf("RESILIENCE") >= 0){
            colorString += root.resilienceColor + ":";
        }
        if (effectForParser.indexOf("LUCK") >= 0){
            colorString += root.luckColor + ":";
        }
        colorString = colorString.substring(0, colorString.length-1);
        if (colorString === ""){
            colorString += "#ffffff";
        }
        return colorString;
    }

    function getGradientColor1(){
        return cardContainer.cardColor.split(":")[0];
    }
    function getGradientColor2(){
        var colStr = cardContainer.cardColor.split(":");
        return colStr.length === 1 ? colStr[0] : colStr[1];
    }

    // check costs
    function attemptUseCard(){
        var costString = cost.split(",");
        for (var c = 0; c < costString.length; c++){
            var amt = costString[c].split(" - ")[1];
            var resource = costString[c].split(" - ")[0];
            if (resource === "Energy"){
                if (player.energy - amt < 0){ return false; }
            }
            for (var r = 0; r < resourceNames.length; r++){
                if (resource === resourceNames[r]){
                    if (player.playerResourceCount[r] - amt < 0){ return false; }
                }
            }
        }
        return true;
    }

    // destroy the card after used
    function useCard(){
        var costString = cost.split(",");
        for (var c = 0; c < costString.length; c++){
            var amt = costString[c].split(" - ")[1];
            var resource = costString[c].split(" - ")[0];
            if (resource === "Energy"){
                player.energy -= amt;
            }
            for (var r = 0; r < resourceNames.length; r++){
                if (resource === resourceNames[r]){
                    player.playerResourceCount[r] -= amt;
                }
            }
        }
        cardContainer.destroy();
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked:{
            root.selectCard(cardContainer);
            selected = true;
        }
        onEntered:{
            parent.cardColor = "#afafaf";
            hoverTimer.start();
        }
        onExited: {
            parent.cardColor = getCardColor();
            hoverTimer.stop();
            root.stopPreviewCard();
        }
    }

    Column{
        id: stats
        anchors.fill: parent
        spacing: 5
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 5

        Text{
            id: cardName
            text: displayName
            font.pointSize: text.length > 10 ? root.tinestFontSize : root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            width: parent.width-10
            font.bold: true
        }
        Text{
            id: card_type
            text: cardType
            font.pointSize: root.tinestFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text{
            id: card_class
            text: cardClass
            font.pointSize: root.tinestFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle{
            color: "transparent"
            width: 10
            height: 1
        }
        Row{
            id: card_costs
            height: 30
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Component.onCompleted: {
        var costString = cost.split(", ");
        var iconNames = ["Metal", "Fur", "Herb", "Arrow", "Crystal"];
        for (var c = 0; c < costString.length; c++){
            var amt = costString[c].split(" - ")[1];
            var resource = costString[c].split(" - ")[0];
            if (resource === "Energy"){

            }
            for (var r = 0; r < resourceNames.length; r++){
                if (resource === resourceNames[r]){
                    var newCost = single_cost.createObject(card_costs);
                    newCost.amt = amt;
                    newCost.src = "../Icons/" + iconNames[r] + ".png";
                }
            }
        }
    }

    Rectangle{
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 10
        width: 20
        height: 20
        radius: width/2
        border.color: "black"
        border.width: 1
        color: {
            if (power == 0){

            }
            else if(power == 1){
                return "#663300";
            }
            else if(power == 2){

            }
            else if(power == 3){

            }
            else if(power == 4){

            }
            else if(power == 5){

            }
        }
    }
    Text{
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10
        text: "#" + cardNumber
        font.pointSize: root.tinyFontSize
        font.family: root.textFont
        color: root.textColor
    }

    Connections{
        target: root
        onSelectCard:{
            selected = false;
        }
    }
}
