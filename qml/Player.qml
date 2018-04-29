import QtQuick 2.0

Rectangle {
    id: player
    property string name: "Unnamed Hero"
    property string race: ""
    property int level: 0
    property int experienceToNextLevel: 0
    property int numUnspentPoints: 10

    // stats
    property int strength: 0
    property int dexterity: 0
    property int spellpower: 0
    property int resilience: 0
    property int luck: 0

    // player resources
    property int maxHp: 0
    property int hp: 0
    property int maxEnergy:0
    property int energy: 0
    property int gold: 0

    property int currentDeckPower: 0
    property int currentHandPower: 0
    property int maxDeckPower: 20 + level*5
    property int maxStartingHandPower: 3 + Math.floor(spellpower/3)

    property variant startingHand: []
    property variant playerDeck: []
    property variant playerInventory: []

    property variant playerResourceNames: ["Metal", "Fur", "Medicinal Herb", "Arrow", "Magic Crystal"]
    property variant resourceSingular: ["piece of metal", "chunk of fur", "medicinal herb", "arrow", "magic crystal"]
    property variant resourcePlurals: ["pieces of metal", "chunks of fur", "medicinal herbs", "arrows", "magic crystals"]
    property variant playerResourceCount: [0, 0, 0, 0, 0]

    // equipment slots
    // Head, Body, Gloves, Boots, Weapon, Accessory
    property variant playerEquipmentSlots: []

    // array of arrays in the for [effect,amount,turnsLeft]
    // [REDUCE,1,1] = +1 damage reduction for 1 use
    // [DAMAGE,2,2] = take 2 damage each turn for 2 turns
    property variant statusEffects:[]

    width: 200
    height: 100
    border.width: 2
    border.color: "black"
    color: "#ffffff"

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

    NumberAnimation on x {
        id: shake_animation
        loops: 3
        from: x-10; to: x
        duration: 125
    }

    onHpChanged: {
        shake_animation.start();

        if (hp <= 0){
            console.log("You died.");
        }
    }

    onExperienceToNextLevelChanged: {
        if (experienceToNextLevel <= 0){
            experienceToNextLevel = level * 100;
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked:{
            root.targetAlly(player);
        }
        onEntered:{
            player.color = "#afafaf";
        }
        onExited: {
            player.color = "#ffffff";
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
            id: playerName
            text: name
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
        }
        Text{
            id: playerLevel
            text: "Level " + level
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text{
            id: playerHp
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

    Connections{
        target: root
        onEquipItem:{
            // calculate passive bonuses from equipment
            var effect = card.effectForParser;
            var stat = effect.split(":")[0];
            var amt = effect.split(":")[1];
            if (stat === "MAXHP"){
                maxHp += Number(amt);
                hp += Number(amt);
            }
        }
        onUnequipItem:{
            // calculate passive bonuses from equipment
            var effect = card.effectForParser;
            var stat = effect.split(":")[0];
            var amt = effect.split(":")[1];
            if (stat === "MAXHP"){
                maxHp -= Number(amt);
                if (hp > maxHp){ hp = maxHp; }
            }
        }
    }

}
