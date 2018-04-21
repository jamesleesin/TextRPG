import QtQuick 2.0

Item {
    id: monsterContainer
    property string name: ""
    property int level: 0

    // stats
    property int strength: 0
    property int dexterity: 0
    property int spellpower: 0
    property int resilience: 0
    property int luck: 0

    // resources
    property int maxHp: 0
    property int hp: 0
    property int maxMp:0
    property int mp: 0
    property int maxSp: 0
    property int sp: 0
    property string goldDrops: ""
    property string resourceDrops: ""
    property string lootDrops: ""
    property string basicAttack: ""
    property string missAttack: ""
    property variant specialAttackArray: []
    property string monsterColor: "#ffffff"

    property variant statusEffects:[]

    signal shake()

    /*function hpColor(){
        console.log(hp/maxHp);
        if (hp/maxHp > 0.5) return "#999999";
        else{
            var start = 153; // 99 in hex
            // set hp/maxHp = 0 to 255, and hp/maxHp = 0.5 to 153
            var col = -204*(hp/maxHp) + 255;
            // convert to hex string
            return "#" + col.toString(16) + "9999";
        }
    }*/

    // rolls for monster attack
    function monsterAttack(){
        var attackString = "";
        var playerLuck = root.getPlayerLuck();
        var missChance = missAttack.split("~")[0];
        var roll = Math.random();
        var thresholdPercentages = [missChance];
        // add in the special moves
        for (var t = 0; t < specialAttackArray.length; t++){
            thresholdPercentages.push(specialAttackArray[t].split("~")[0]);
        }
        var threshholdCounter = 0;
        var threshold = Number(thresholdPercentages[0]);
        while (attackString === ""){
            if (roll < threshold){
                if (threshholdCounter == 0){
                    attackString = missAttack.split("~")[1];
                }
                else if (threshholdCounter <= specialAttackArray.length){
                    attackString = specialAttackArray[threshholdCounter-1].split("~")[1];
                }
            }
            else{
                if (threshholdCounter < specialAttackArray.length){
                    threshholdCounter++;
                    threshold += Number(thresholdPercentages[threshholdCounter]);
                }
                else{
                    attackString = basicAttack;
                }
            }
        }
        return attackString;
    }

    // drop gold, based on a weighted roll.
    function dropGold(){
        var lowDrop = goldDrops.split("-")[0];
        var highDrop = goldDrops.split("-")[1];
        // roll for gold drop
        var droppedGold = lowDrop;
        var roll = Math.random();
        // ex. 3-5: 50% chance to get 3 gold, 1.5% chance to get high drop
        while(roll >= 0.5 && droppedGold < highDrop){
            roll = Math.random();
            droppedGold *= 1.1;
        }
        return Math.floor(droppedGold);
    }
    // drop loot randomly based on % chance of drop
    function dropLoot(){
        // get player luck
        var playerLuck = root.getPlayerLuck();
        // roll for loot drop
        var droppedLoot = [];
        var itemArray = lootDrops.split(", ");
        for (var i = 0; i < itemArray.length; i++){
            var dropChance = itemArray[i].split("-")[0];
            var item = itemArray[i].split("-")[1];
            if (Math.random() < dropChance){
                droppedLoot.push(item);
            }
        }
        return droppedLoot;
    }
    // drop resources
    function dropResources(){
        // get player luck
        var playerLuck = root.getPlayerLuck();
        // roll for loot drop
        var droppedResources = [];
        if (resourceDrops != ""){
            var resourceArray = resourceDrops.split(", ");
            for (var i = 0; i < resourceArray.length; i++){
                var dropChance = Number(resourceArray[i].split(":")[0]);
                var numRolls = Number(resourceArray[i].split(":")[1]);
                var item = resourceArray[i].split(":")[2];
                for (var r = 0; r < numRolls; r++){
                    if (Math.random() < dropChance){
                        droppedResources.push(item);
                    }
                }
            }
        }
        return droppedResources;
    }

    // calculate experience drop
    function dropExperience(){
        // get player level
        var playerLevel = root.getPlayerLevel();
        var baseExpDrop = 10 * Math.pow(monsterContainer.level, 1.1);
        // adjust exp drop based on difference in level
        var difference = playerLevel - monsterContainer.level;
        var expDrop = baseExpDrop;
        if (difference > 0){
            // 50% exp if player is 1 level higher, 25 for 2, 12.5 for 3 etc.
            expDrop *= Math.pow(0.5, difference);
            if (expDrop < 1){ expDrop = 1; }
        }
        else if (difference <= 0){
            // exp * 1.1^leveldifference.
            expDrop *= Math.pow(1.1, difference);
        }
        return Math.floor(expDrop);
    }

    // call this before adjusting hp
    function calculateDamageMitigation(damage){
        var damageAdjusted = damage;
        // parse status effects for anything affecting this damage
        for (var statusIndex = 0; statusIndex < statusEffects.length; statusIndex++){
            var status = statusEffects[statusIndex];
            var type = status[0];
            var amount = status[1];
            var numActivations = status[2];
            if (type === "REDUCE"){ // damage reduction
                damageAdjusted -= amount;
                if (numActivations === 1){    // used up
                    statusEffects.splice(statusIndex, 1);
                    statusIndex--;
                }
                else{
                    statusEffects[statusIndex][2]--;
                }
            }
        }
        return damageAdjusted > 0 ? damageAdjusted : 0;
    }

    onHpChanged: {
        shake();
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked:{
            root.targetEnemy(monsterContainer);
        }
        onEntered:{
            parent.monsterColor = "#afafaf";
        }
        onExited: {
            parent.monsterColor = "#ffffff";
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
            id: monsterName
            text: name
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
        }
        Text{
            id: monsterLevel
            text: "Level " + level
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text{
            id: monsterHp
            text: "HP: " + hp + "/" + maxHp
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle{
            id: healthbar_container
            width: 150
            height: 10
            anchors.horizontalCenter: parent.horizontalCenter
            color: "red"

            Rectangle{
                anchors.left: parent.left
                anchors.top:parent.top
                height: 10
                width: parent.width * (hp/maxHp)
                color: "green"
            }
        }
    }
}
