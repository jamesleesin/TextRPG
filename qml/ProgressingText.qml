import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: progressingText
    property var textArray: []
    property int shownIndex: -1
    property var variableArray: []

    function getContentHeight(){
        return shownText.contentHeight;
    }

    function addText(txt){
        textArray.push(txt);
    }

    function clearAll(){
        textArray = [];
        shownIndex = -1;
        shownText.text = "";
    }

    function showNext(){
        shownIndex++;
        if (shownIndex < textArray.length){
            // require user text input
            if (textArray[shownIndex] === "OPTION:TEXT_ENTRY"){
                // the next text entry will be the placeholder text
                shownIndex++;
                root.requireTextEntry(textArray[shownIndex].split(":")[1]);
            }
            // require user button press
            else if (textArray[shownIndex] === "OPTION:BUTTONS"){
                // the next entry will be button options
                shownIndex++;
                root.requireButtonSelect(textArray[shownIndex]);
            }
            // update a value automatically
            else if(textArray[shownIndex].indexOf("UPDATE:") >= 0){
                var str = textArray[shownIndex].split(":")[1];
                var param = str.split(",")[0];
                var value = str.split(",")[1];
                var variableIndex = value.split("_")[1];
                // get the value of the corresponding variable
                value = value.replace("$VARIABLE_" + variableIndex, getVariable(variableIndex-1));
                root.updateValue(param, value);
                // show next line because there is no text involved with this
                showNext();
            }
            // enter combat
            else if (textArray[shownIndex].indexOf("COMBAT:") >= 0){
                var monsterName = textArray[shownIndex].split(":")[1];
                root.enterCombat(monsterName);
            }
            else if (textArray[shownIndex].indexOf("PLACE:") >= 0){
                var place = textArray[shownIndex].split(":")[1];
                root.changeLocation(place);
            }
            // else just show text after replacing variable names
            else{
                // parse the text for placeholders and replace with appropriate info
                var stringToAdd = textArray[shownIndex];
                stringToAdd = stringToAdd.replace("$PLAYER_NAME", root.getPlayerName());
                stringToAdd = stringToAdd.replace("$PLAYER_GOLD", root.getPlayerGold());

                // replace variables
                for (var i = 0; i < variableArray.length; i++){
                    stringToAdd = stringToAdd.replace("$VARIABLE_" + (i+1), getVariable(i));
                }

                shownText.text += stringToAdd + "\n\n";
            }
        }
    }

    function addVariable(value){
        variableArray.push(value);
    }

    function getVariable(index){
        return variableArray[index];
    }

    Text{
        id: shownText
        font.pointSize: root.smallFontSize
        font.family: root.textFont
        color: root.textColor
        text: ""
        wrapMode: Text.WordWrap
        width: progressingText.width
    }
}
