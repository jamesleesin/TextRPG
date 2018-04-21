import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0


import "Monsters"
import "Cards"
import "Places"

Rectangle {
    id: root
    property string textColor: "black"
    property string textFont: "Sans Serif"
    property int tinestFontSize: 8
    property int tinyFontSize: 10
    property int smallFontSize: 12
    property int mediumFontSize: 14
    property int largeFontSize: 16

    // color codes for different stats
    property string strengthColor: "#DDAAAA"
    property string dexterityColor: "#D2AADD"
    property string spellpowerColor: "#86A4E7"
    property string resilienceColor: "#D2AB82"
    property string luckColor: "#82D286"

    property bool characterCreated: false
    property bool tutorialCompleted: false

    property bool inCombat: false
    property bool handSelected: false
    property variant cardSelected: null
    property variant cardHovered: null
    property bool inInventory: false
    property bool inHandPicking: false

    // player hand and player deck. We make copies for easier handling
    property variant playerHand:[]
    property variant playerDeck:[]

    property string location: "Global"

    // signals called from ProgressingText
    signal updateValue(string param, string value)
    signal enterCombat(string monster)

    // call this to add to combat log
    signal addToCombatLog(string combatText)
    // call to load starting hand
    signal loadStartingHand(variant hand)
    signal openHandPicker()
    // when user hovers on a card to preview it
    signal previewCard(variant card)
    signal stopPreviewCard()

    signal selectCard(variant card)
    // click enemy to target
    signal targetEnemy(variant enemy)
    signal monsterKilled(variant monster, int droppedGold, variant droppedLoot, variant droppedResources, int droppedExperience)
    signal showLootGained()
    // or click ally to target
    signal targetAlly(variant ally)
    // monster AI
    signal doMonsterActions(int monsterNum)
    // player turn
    signal startPlayerTurn()
    property bool isPlayerTurn: false

    // inventory signals
    signal openInventory(variant playerInventory)
    signal addToInventory(variant itemString)

    // set location sets the world location, e.g. Global, Elven etc.
    signal setLocation(string loc)
    // change location sets more in detail locations, e.g. Eleren, TheCrossedArrows
    signal changeLocation(string loc)

    /* Return functions for player information */
    function getPlayerName(){
        return player.name;
    }
    function getPlayerLevel(){
        return player.level;
    }
    function getPlayerPower(){
        return player.currentDeckPower;
    }
    function getPlayerGold(){
        return player.gold;
    }
    function getPlayerLuck(){
        return player.luck;
    }

    Component.onCompleted: {
       // var locationString = "qrc:/qml/Places/Global/GameIntro.qml";
        var locationString = "qrc:/qml/Places/Elven/TheFangHills.qml";
        var loc = Qt.createComponent(locationString);
        var newLoc = loc.createObject(place_container);
    }

    Timer{
        id: monster_attack_timer
        property int currentMonster: 0
        repeat: true
        interval: 500
        onTriggered: {
            if (currentMonster < combat_enemies.children.length){
                root.doMonsterActions(currentMonster);
                currentMonster++;
            }
            else{
                currentMonster = 0;
                stop();
                root.startPlayerTurn();
            }
        }
    }

    Rectangle{
        id: errorDialog
        anchors.centerIn: parent
        anchors.fill: root
        visible: false
        z: 10
        color: "#99111111"
        border.width: 2
        border.color: "black"

        MouseArea{
            id: blockClicks
            anchors.fill: parent
            propagateComposedEvents: false
        }

        Rectangle{
            id: errorDialogContainer
            width: 300
            height: 200
            anchors.centerIn: parent
            border.width: 2
            border.color: "black"

            Text{
                id: errorDialogText
                text: ""
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.textColor
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 20
                font.bold: true
                width: parent.width-50
            }

            // confirm
            Rectangle{
                id: confirmRead
                width: confirmReadText.width+12
                height: confirmReadText.height+10
                color: "white"
                border.width: 1
                border.color: "black"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20

                Text{
                    id: confirmReadText
                    text: "Got it!"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        errorDialog.visible = false;
                    }
                    onEntered: {
                        parent.color = "lightgrey";
                        blockClicks.propagateComposedEvents = true;
                    }
                    onExited: {
                        parent.color = "white";
                        blockClicks.propagateComposedEvents = false;
                    }
                }
            }
        }


    }

    PlayerProgress{
        id: playerProgress
    }

    Rectangle{
        id: stats_panel
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 200
        color: "#eeeeee"
        border.width: 2
        border.color: "black"

        Column{
            id: stats_column
            anchors.fill: parent
            spacing: 5
            anchors.leftMargin: 20
            anchors.topMargin: 20

            Text{
                id: playerName
                text: player.name
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.textColor
            }

            Text{
                id: playerLevel
                text: "Level: " + player.level
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.textColor
            }
            Text{
                id: playerExp
                text: "Exp Req.: " + player.experienceToNextLevel
                font.pointSize: root.tinyFontSize
                font.family: root.textFont
                color: root.textColor
            }

            // divider
            Rectangle{
                height: 30
                width: 100
                color: "transparent"

                Rectangle{
                    height: 1
                    border.width: 2
                    border.color: "black"
                    color: "transparent"
                    width: parent.width
                    anchors.centerIn: parent
                }
            }

            Text{
                id: playerRace
                text: "Race: " + player.race
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.textColor
            }

            Text{
                id: playerPower
                text: "Power: " + player.currentDeckPower
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.textColor
            }

            // divider
            Rectangle{
                height: 30
                width: 100
                color: "transparent"

                Rectangle{
                    height: 1
                    border.width: 2
                    border.color: "black"
                    color: "transparent"
                    width: parent.width
                    anchors.centerIn: parent
                }
            }

            Text{
                id: playerStrength
                text: "Strength: " + player.strength
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.inInventory ? root.strengthColor : root.textColor
                font.bold: root.inInventory ? true : false
            }

            Text{
                id: playerDexterity
                text: "Dexterity: " + player.dexterity
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.inInventory ? root.dexterityColor : root.textColor
                font.bold: root.inInventory ? true : false
            }

            Text{
                id: playerSpellpower
                text: "Spellpower: " + player.spellpower
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.inInventory ? root.spellpowerColor : root.textColor
                font.bold: root.inInventory ? true : false
            }

            Text{
                id: playerResilience
                text: "Resilience: " + player.resilience
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.inInventory ? root.resilienceColor : root.textColor
                font.bold: root.inInventory ? true : false
            }

            Text{
                id: playerLuck
                text: "Luck: " + player.luck
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.inInventory ? root.luckColor : root.textColor
                font.bold: root.inInventory ? true : false
            }

            // divider
            Rectangle{
                height: 30
                width: 100
                color: "transparent"

                Rectangle{
                    height: 1
                    border.width: 2
                    border.color: "black"
                    color: "transparent"
                    width: parent.width
                    anchors.centerIn: parent
                }
            }
            Text{
                id: playerHp
                text: "HP: " + player.hp + "/" + player.maxHp
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.textColor
            }

            Text{
                id: playerEnergy
                text:  "Energy: " + player.energy + "/" + player.maxEnergy
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.textColor
            }

            Text{
                id: playerGold
                text: "Gold: " + player.gold
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: root.textColor
            }

            // divider
            Rectangle{
                height: 30
                width: 100
                color: "transparent"

                Rectangle{
                    height: 1
                    border.width: 2
                    border.color: "black"
                    color: "transparent"
                    width: parent.width
                    anchors.centerIn: parent
                }
            }

            Row{
                height: inventory_button.height
                spacing: 5

                Rectangle{
                    id: levelup_button
                    color: "transparent"
                    visible: player.numUnspentPoints == 0 ? false: true
                    height: stats_column.width/5
                    width: stats_column.width/5
                    property bool hovered: false

                    Image{
                        id: levelup_icon
                        anchors.fill: parent
                        source: "Icons/Levelup.png"
                        visible: levelup_button.hovered ? false : true
                    }

                    ColorOverlay{
                        anchors.fill: levelup_icon
                        source: levelup_icon
                        color: levelup_button.pressed ? "#80000000" : "#50000000"
                        visible: levelup_button.hovered ? true : false
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:{
                            if (levelup_container.visible){
                                levelup_container.visible = false;
                            }
                            else{
                                levelup_container.visible = true;
                                levelup_box.tempUnspentPoints = player.numUnspentPoints;
                            }
                        }
                        onEntered: {
                            levelup_button.hovered = true;
                        }
                        onExited: {
                            levelup_button.hovered = false;
                        }
                    }
                }
                Rectangle{
                    id: inventory_button
                    color: "transparent"
                    visible: root.inHandPicking ? false: true
                    height: stats_column.width/5
                    width: stats_column.width/5
                    property bool hovered: false

                    Image{
                        id: inventory_icon
                        anchors.fill: parent
                        source: "Icons/Inventory.png"
                        visible: inventory_button.hovered ? false : true
                    }

                    ColorOverlay{
                        anchors.fill: inventory_icon
                        source: inventory_icon
                        color: inventory_button.pressed ? "#80000000" : "#50000000"
                        visible: inventory_button.hovered ? true : false
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:{
                            if (!root.inInventory){
                                console.log("Open inventory");
                                root.inInventory = true;
                                root.openInventory(player.playerInventory);
                            }
                            else{
                                // check if deck power > max deck power
                                if (player.currentDeckPower > player.maxDeckPower){
                                    errorDialogText.text = "Your deck is too powerful to use."
                                    errorDialog.visible = true;
                                }
                                else if (player.playerDeck.length < 20){
                                    errorDialogText.text = "Your deck must have at least 20 cards!"
                                    errorDialog.visible = true;
                                }
                                else{
                                    root.inInventory = false;
                                }
                            }
                        }
                        onEntered: {
                            inventory_button.hovered = true;
                        }
                        onExited: {
                            inventory_button.hovered = false;
                        }
                    }
                }
                Rectangle{
                    id: quests_button
                    color: "transparent"
                    visible: root.inHandPicking ? false: true
                    height: stats_column.width/5
                    width: stats_column.width/5
                    property bool hovered: false

                    Image{
                        id: quests_icon
                        anchors.fill: parent
                        source: "Icons/Quests.png"
                        visible: quests_button.hovered ? false : true
                    }

                    ColorOverlay{
                        anchors.fill: quests_icon
                        source: quests_icon
                        color: quests_button.pressed ? "#80000000" : "#50000000"
                        visible: quests_button.hovered ? true : false
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:{
                        }
                        onEntered: {
                            quests_button.hovered = true;
                        }
                        onExited: {
                            quests_button.hovered = false;
                        }
                    }
                }
                Rectangle{
                    id: settings_button
                    color: "transparent"
                    visible: root.inHandPicking ? false: true
                    height: stats_column.width/5
                    width: stats_column.width/5
                    property bool hovered: false

                    Image{
                        id: settings_icon
                        anchors.fill: parent
                        source: "Icons/Settings.png"
                        visible: settings_button.hovered ? false : true
                    }

                    ColorOverlay{
                        anchors.fill: settings_icon
                        source: settings_icon
                        color: settings_button.pressed ? "#80000000" : "#50000000"
                        visible: settings_button.hovered ? true : false
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:{
                            if (settings_container.visible){
                                settings_container.visible = false;
                            }
                            else{
                                settings_container.visible = true;
                            }
                        }
                        onEntered: {
                            settings_button.hovered = true;
                        }
                        onExited: {
                            settings_button.hovered = false;
                        }
                    }
                }
            }

            // divider
            Rectangle{
                height: 30
                width: 100
                color: "transparent"

                Rectangle{
                    height: 1
                    border.width: 2
                    border.color: "black"
                    color: "transparent"
                    width: parent.width
                    anchors.centerIn: parent
                }
            }

            Text{
                id: tooltip_1
                text: {
                    if (root.inInventory){
                        return "Deck Size: " + player.playerDeck.length + "/20";
                    }
                    else if (root.inHandPicking){
                        return "Hand Size: " + player.startingHand.length + "/6"
                    }
                    return "";
                }
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: {
                    if (root.inInventory){
                        return player.playerDeck.length > 20 ? "red" : "green";
                    }
                    else if(root.inHandPicking){
                        return player.startingHand.length > 6 ? "red" : "green";
                    }
                    return root.textColor;
                }
            }
            Text{
                id: tooltip_2
                text: {
                    if (root.inInventory){
                        return "Power: " + player.currentDeckPower + "/" + player.maxDeckPower;
                    }
                    else if (root.inHandPicking){
                        return "Power: " + player.currentHandPower + "/" + player.maxStartingHandPower;
                    }
                    return "";
                }
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                color: {
                    if (root.inInventory){
                        return player.currentDeckPower > player.maxDeckPower ? "red" : "green";
                    }
                    else if (root.inHandPicking){
                        return player.currentHandPower > player.maxStartingHandPower ? "red" : "green";
                    }
                    return root.textColor;
                }
            }
        }
    }

    // places with buttons and no progressing text
    Rectangle{
        id: place_container
        anchors.left: stats_panel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#ffffff"
        border.width: 2
        border.color: "black"
        visible: !combat_outcome.visible && !root.inInventory && !root.inHandPicking && !root.inCombat ? true : false
    }

    // combat interface. top is enemies, middle is a preview pane, bottom is hand, right is chat log
    Rectangle{
        id: combat_interface
        anchors.left: stats_panel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "white"
        border.width: 2
        border.color: "black"
        visible: root.inCombat ? true : false

        Rectangle{
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: chat_log.left
            anchors.bottom: player_hand_container.top
            color: "white"
            border.width: 2
            border.color: "black"

            // special combat frame
            Rectangle{
                id: combat_enemies_container
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: root.height/5
                color: "transparent"

                Row{
                    id: combat_enemies
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 50
                }
            }

            Rectangle{
                id: combat_tooltip_container
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: combat_enemies_container.bottom
                anchors.bottom: combat_allies_container.top
                color: "transparent"

                Text{
                    id: combat_tooltip
                    text: ""
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                    visible: combat_tooltip.text == "" ? false : true
                }
            }

            // allies container
            Rectangle{
                id: combat_allies_container
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: root.height/5
                color: "transparent"

                Row{
                    id: combat_allies
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 50

                    // the actual player and it's representation on the board
                    Player{
                        id: player
                        name: "Unnamed Hero"
                        race: ""
                        level: 0
                        experienceToNextLevel: 100
                        strength: 0
                        dexterity: 0
                        spellpower: 0
                        resilience: 0
                        luck: 0
                        maxHp: 0
                        maxEnergy: 10
                        hp: 0
                        energy: 0
                        gold: 0
                        startingHand: []
                        playerDeck: []
                        playerInventory: ["Neutral/Punch", "Neutral/Kick", "Neutral/Block", "Neutral/Focus", "Neutral/LesserHealingPotion"]

                        playerResourceCount: [0, 0, 1, 0, 0]
                    }
                }
            }
        }

        Rectangle{
            id: player_hand_container
            anchors.left: parent.left
            anchors.right: chat_log.left
            anchors.bottom: parent.bottom
            height: root.height/4
            color: "white"
            border.width: 2
            border.color: "black"

            Row{
                id: player_hand
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 30
            }
        }

        Rectangle{
            id: chat_log
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 250
            color: "white"
            border.width: 2
            border.color: "black"

            Column{
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.topMargin: 20

                Text{
                    id: combat_log_label
                    text: "Combat Log\n"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle{
                    color: "transparent"
                    width: parent.width
                    height: parent.height - combat_log_label.height - 10
                    clip: true

                    Text{
                        id: combat_log
                        text: ""
                        font.pointSize: root.tinyFontSize
                        font.family: root.textFont
                        color: root.textColor
                        wrapMode: Text.WordWrap
                        width: chat_log.width-40
                        horizontalAlignment: Text.AlignHCenter
                        anchors.bottom: combat_log.height > parent.height ? parent.bottom : parent.top
                        anchors.bottomMargin: combat_log.height > parent.height ? 0 : -combat_log.height
                    }
                }
            }
        }
    }

    // dialog for combat outcome
    Rectangle{
        id: combat_outcome
        anchors.left: stats_panel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "white"
        border.width: 2
        border.color: "black"
        visible: false
        property bool victory: false
        property int goldGain: 0
        property variant lootSoFar: []
        property variant resourcesSoFar: [0, 0, 0, 0, 0]
        property int experienceGained: 0
        property bool fromDungeon: false
        property bool bossKilled: false

        Column{
            anchors.centerIn: parent
            spacing: 20

            Text{
                id: combat_outcome_text
                text: {
                    if (combat_outcome.fromDungeon){
                        if (combat_outcome.bossKilled){ return "Dungeon Cleared!"; }
                        else return "You leave the dungeon early...";
                    }
                    else{
                        if (combat_outcome.victory){ return "You won the fight!"; }
                        else return "You collapse, defeated...";
                    }
                }
                font.pointSize: root.mediumFontSize
                font.family: root.textFont
                color: root.textColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                id: combat_loot_gold
                text: combat_outcome.victory ? "You gain " + combat_outcome.goldGain + " gold!" : "You lose " + combat_outcome.goldGain + " gold."
                font.pointSize: root.mediumFontSize
                font.family: root.textFont
                color: root.textColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                id: combat_loot_experience
                text: combat_outcome.victory ? "You gain " + combat_outcome.experienceGained + " experience." : ""
                font.pointSize: root.mediumFontSize
                font.family: root.textFont
                color: root.textColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text{
                id: combat_loot_resources
                text: {
                    if (combat_outcome.victory){
                        // look for last resource dropped
                        var last = [];
                        for (var a = 0; a < combat_outcome.resourcesSoFar.length; a++){
                            if (combat_outcome.resourcesSoFar[a] > 0){ last.push(a); }
                        }

                        // make the text string
                        var resourcesDropped = "The enemy dropped ";
                        for (var i = 0; i < combat_outcome.resourcesSoFar.length; i++){
                            if (combat_outcome.resourcesSoFar[i] > 0){
                                if (last.length > 1){
                                    if (i === last[last.length-1]){ resourcesDropped += ", and "; }
                                    else if (i !== last[0]){ resourcesDropped += ", "; }
                                }

                                if (combat_outcome.resourcesSoFar[i] === 1){
                                    resourcesDropped += "1 " + player.resourceSingular[i];
                                }
                                else{
                                    resourcesDropped += combat_outcome.resourcesSoFar[i] + " " + player.resourcePlurals[i];
                                }
                            }
                        }
                        return resourcesDropped;
                    }
                    else return "";
                }
                font.pointSize: root.mediumFontSize
                font.family: root.textFont
                color: root.textColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Row{
                spacing: 30
                visible: combat_outcome.victory ? true : false

                Rectangle{
                    id: combat_loot_items_container
                    width: 300
                    height: 400
                    color: "white"
                    border.width: 2
                    border.color: "black"

                    ScrollView{
                        anchors.fill: parent
                        anchors.margins: 10
                        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                        GridLayout{
                            id: combat_loot_items
                            width: combat_loot_items_container.width - 30
                            columns: 2
                            columnSpacing: -10
                            rowSpacing: 30
                        }
                    }
                }
                Rectangle{
                    id: combat_loot_item_details
                    width: 300
                    height: 400
                    color: "white"
                    border.width: 2
                    border.color: "black"

                    property string name: "None"
                    property string cardType: ""
                    property string cardClass: ""
                    property string condition: ""
                    property int power: 0
                    property string cost: ""
                    property string effect: ""
                    property bool cardSelected: false

                    Column{
                        id: combat_loot_card_stats
                        spacing: 5
                        anchors.centerIn: parent
                        visible: combat_loot_item_details.cardSelected ? true : false
                        width: parent.width

                        Text{
                            text: {
                                // add a space before capital letters
                                var newStr = combat_loot_item_details.name[0];
                                for (var i = 1; i < combat_loot_item_details.name.length; i++){
                                    if (combat_loot_item_details.name.charAt(i) == combat_loot_item_details.name.charAt(i).toUpperCase()){ newStr += " " + combat_loot_item_details.name.charAt(i); }
                                    else{ newStr += combat_loot_item_details.name.charAt(i); }
                                }
                                return newStr;
                            }
                            font.pointSize: root.smallFontSize
                            font.family: root.textFont
                            color: root.textColor
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text{
                            text: combat_loot_item_details.cardClass
                            font.pointSize: root.tinyFontSize
                            font.family: root.textFont
                            color: root.textColor
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text{
                            text: combat_loot_item_details.condition
                            font.pointSize: root.tinyFontSize
                            font.family: root.textFont
                            color: root.textColor
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text{
                            text: combat_loot_item_details.cost
                            font.pointSize: root.tinyFontSize
                            font.family: root.textFont
                            color: root.textColor
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text{
                            text: combat_loot_item_details.effect
                            font.pointSize: root.tinyFontSize
                            font.family: root.textFont
                            color: root.textColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            width: parent.width-50
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
            // ok button
            Rectangle{
                id: confirm_loot_button
                width: confirm_loot_button_text.width+10
                height: confirm_loot_button_text.height+8
                color: "white"
                border.width: 1
                border.color: "black"
                anchors.horizontalCenter: parent.horizontalCenter

                Text{
                    id: confirm_loot_button_text
                    text: "Accept"
                    font.pointSize: root.largeFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        console.log("Accept Loot");
                        root.addToInventory(combat_outcome.lootSoFar);
                        player.gold += combat_outcome.goldGain;
                        player.experienceToNextLevel -= combat_outcome.experienceGained;
                        // add resources
                        for (var r = 0; r < combat_outcome.resourcesSoFar.length; r++){
                            player.playerResourceCount[r] += combat_outcome.resourcesSoFar[r];
                        }
                        // show next line in the story
                        if (combat_outcome.victory){
                            place_container.children[0].children[0].victory();
                        }
                        else{
                            // load last save or resurrect in
                            place_container.children[0].children[0].defeat();
                        }
                        combat_outcome.visible = false;
                        combat_outcome.victory = false;
                        combat_outcome.goldGain = 0;
                        combat_outcome.lootSoFar = [];
                        combat_outcome.resourcesSoFar = [0, 0, 0, 0, 0];
                        combat_outcome.experienceGained = 0;
                        combat_outcome.fromDungeon = false;
                        for (var c = 0; c < combat_loot_items.children.length; c++){
                            combat_loot_items.children[c].destroy();
                        }

                        root.inCombat = false;
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

    Rectangle{
        id: resources_interface
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 220
        color: "white"
        border.width: 2
        border.color: "black"
        visible: root.inInventory || root.inHandPicking ? true : false

        Column{
            id: resource_list
            anchors.fill: parent
            spacing: 10
            anchors.leftMargin: 10
            anchors.rightMargin: 5
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                id: resource_label
                text: "Resource List"
                font.pointSize: root.mediumFontSize
                font.family: root.textFont
                color: root.textColor
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
            }
            Row{
                height: icon_metal.height
                spacing: 10
                Image{
                    id: icon_metal
                    source: "Icons/Metal.png"
                    width: 40
                    height: 40
                }
                Text{
                    text: resources_interface.visible ? player.playerResourceNames[0] + ": " +  player.playerResourceCount[0] : ""
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                }
            }
            Row{
                height: icon_fur.height
                spacing: 10
                Image{
                    id: icon_fur
                    source: "Icons/Fur.png"
                    width: 40
                    height: 40
                }
                Text{
                    text: resources_interface.visible ? player.playerResourceNames[1] + ": " +  player.playerResourceCount[1] : ""
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                }
            }
            Row{
                height: icon_herb.height
                spacing: 10
                Image{
                    id: icon_herb
                    source: "Icons/Herb.png"
                    width: 40
                    height: 40
                }
                Text{
                    text: resources_interface.visible ? player.playerResourceNames[2] + ": " +  player.playerResourceCount[2] : ""
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                }
            }
            Row{
                height: icon_arrow.height
                spacing: 10
                Image{
                    id: icon_arrow
                    source: "Icons/Arrow.png"
                    width: 40
                    height: 40
                }
                Text{
                    text: resources_interface.visible ? player.playerResourceNames[3] + ": " +  player.playerResourceCount[3] :""
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                }
            }
            Row{
                height: icon_crystal.height
                spacing: 10
                Image{
                    id: icon_crystal
                    source: "Icons/Crystal.png"
                    width: 40
                    height: 40
                }
                Text{
                    text: resources_interface.visible ? player.playerResourceNames[4] + ": " +  player.playerResourceCount[4] :""
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                }
            }
        }
    }

    // inventory management
    Rectangle{
        id: inventory_interface
        anchors.left: stats_panel.right
        anchors.right: resources_interface.left
        anchors.rightMargin: -2
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "white"
        border.width: 2
        border.color: "black"
        visible: root.inInventory || root.inHandPicking ? true : false

        Text{
            id: inventory_label
            text: root.inInventory ? "Inventory" : "Deck"
            font.pointSize: root.mediumFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        TextField{
            id: inventory_search
            text: ""
            font.pointSize: root.smallFontSize
            font.family: root.textFont
            smooth: true
            width: parent.width/4
            placeholderText: "Search"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            onTextChanged: {
                console.log("Search for: ", text);
                var matchArray = [];
                for(var c = 0; c < inventory_tracker.children.length; c++){
                    var card = inventory_tracker.children[c];
                    // inject spaces back into card name
                    var nameWithSpaces = card.name[0];
                    for (var i = 1; i < card.name.length; i++){
                        if (card.name.charAt(i) == card.name.charAt(i).toUpperCase()){ nameWithSpaces += " " + card.name.charAt(i); }
                        else{ nameWithSpaces += card.name.charAt(i); }
                    }
                    var searchString = new RegExp(text, "i");
                    // search for while ignoring case
                    if (nameWithSpaces.match(searchString) || card.cardClass.match(searchString)
                            || card.condition.match(searchString) || String(card.power).match(searchString)
                            || card.cost.match(searchString) || card.effect.match(searchString)){
                        matchArray.push(card.cardClass + "/" + card.name);
                    }
                }
                // clean
                for (var v = 0; v < card_list.children.length; v++){
                    card_list.children[v].destroy();
                }
                for (var x = 0; x < matchArray.length; x++){
                    var itemString = "qrc:/qml/Cards/" + matchArray[x] + ".qml";
                    var item = Qt.createComponent(itemString);
                    var newItem = item.createObject(card_list);
                }
            }
        }

        Rectangle{
            id: inventory_container
            anchors.top: inventory_label.bottom
            anchors.bottom: inventory_buttons.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            color: "white"

            ScrollView{
                anchors.fill: parent
                anchors.leftMargin: 20

                // the card list for both the inventory and the deck (if on hand picking)
                GridLayout{
                    id: card_list
                    width: card_list.children.length * 150 > inventory_container.width - 50 ? inventory_container.width - 50 : card_list.children.length * 150
                    columns: width/150
                    columnSpacing: 20
                    rowSpacing: 30
                }
            }
            Rectangle{
                id: inventory_tracker
                visible: false
            }
        }

        Row{
            id: inventory_buttons
            anchors.bottom: deck_list_container.top
            anchors.right: parent.right
            anchors.margins: 5
            anchors.topMargin: 0
            anchors.rightMargin: 10
            spacing: 10

            // Add to deck, doubles as a add to hand button
            Rectangle{
                id: addToDeckButton
                width: addToDeckButtonText.width+10
                height: addToDeckButtonText.height+8
                color: "white"
                border.width: 1
                border.color: "black"

                Text{
                    id: addToDeckButtonText
                    text: root.inInventory ? "Add To Deck" : "Add To Hand"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        if (cardSelected != null){
                            if (root.inInventory){
                                // limit number of a card based on power
                                var searchForCard = cardSelected.cardClass + "\/" + cardSelected.name;
                                var countCardsDeck = 0;
                                for (var c = 0; c < player.playerDeck.length; c++){
                                    if (player.playerDeck[c] === searchForCard){ countCardsDeck++; }
                                }
                                var cardLimit = 6 - cardSelected.power;
                                if (countCardsDeck < cardLimit){
                                    player.playerDeck.push(cardSelected.cardClass + "/" + cardSelected.name);
                                    var cardToAddString = "qrc:/qml/Cards/" + cardSelected.cardClass + "/" + cardSelected.name + ".qml";
                                    // create new card and load it into deck
                                    var deckCard = Qt.createComponent(cardToAddString);
                                    var newDeckCard = deckCard.createObject(deck_list);
                                    console.log("Deck is now: " + player.playerDeck);
                                    tooltip_1.text = "Deck Size: " + player.playerDeck.length + "/20";

                                    // update deck power
                                    player.currentDeckPower += cardSelected.power;
                                }
                                else{
                                    errorDialogText.text = "You are not allowed any more of this card in your deck."
                                    errorDialog.visible = true;
                                }
                            }
                            else if (root.inHandPicking){
                                var searchForCardDeck = cardSelected.cardClass + "\/" + cardSelected.name;
                                var countCardsInDeck = 0;
                                for (var q = 0; q < player.playerDeck.length; q++){
                                    if (player.playerDeck[q] === searchForCardDeck){ countCardsInDeck++; }
                                }
                                var countCardsInHand = 0;
                                for (var z = 0; z < player.startingHand.length; z++){
                                    if (player.startingHand[q] === searchForCardDeck){ countCardsInHand++; }
                                }
                                if (countCardsInHand < countCardsInDeck){
                                    player.startingHand.push(cardSelected.cardClass + "/" + cardSelected.name);
                                    var cardToAddToHandString = "qrc:/qml/Cards/" + cardSelected.cardClass + "/" + cardSelected.name + ".qml";
                                    // create new card and load it into hand
                                    var handCard = Qt.createComponent(cardToAddToHandString);
                                    var newHandCard = handCard.createObject(deck_list);
                                    console.log("Hand is now: " + player.startingHand);

                                    // update hand power
                                    player.currentHandPower += cardSelected.power;
                                }
                            }
                        }
                    }
                    onEntered: {
                        parent.color = "lightgrey";
                    }
                    onExited: {
                        parent.color = "white";
                    }
                }
            }
            // remove from deck, doubles as a remove from hand button
            Rectangle{
                id: removeFromDeckButton
                width: removeFromDeckButtonText.width+10
                height: removeFromDeckButtonText.height+8
                color: "white"
                border.width: 1
                border.color: "black"

                Text{
                    id: removeFromDeckButtonText
                    text: root.inInventory ? "Remove From Deck" : "Remove From Hand"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        if (cardSelected != null){
                            if (root.inInventory){
                                var cardToRemoveString = cardSelected.cardClass + "/" + cardSelected.name;
                                var index = player.playerDeck.indexOf(cardToRemoveString);
                                // search deck for a card matching this name and remove an instance of it
                                player.playerDeck.splice(index, 1);
                                deck_list.children[index].destroy();
                                player.currentDeckPower -= cardSelected.power;
                                console.log("Deck is now "+ player.playerDeck);
                                tooltip_1.text = "Deck Size: " + player.playerDeck.length + "/20";
                            }
                            else if (root.inHandPicking){
                                var cardToRemoveFromHandString = cardSelected.cardClass + "/" + cardSelected.name;
                                var indexHand = player.startingHand.indexOf(cardToRemoveFromHandString);
                                // search hand for a card matching this name and remove an instance of it
                                player.startingHand.splice(indexHand, 1);
                                deck_list.children[indexHand].destroy();
                                player.currentHandPower -= cardSelected.power;
                                console.log("Hand is now "+ player.startingHand);
                            }
                        }
                    }
                    onEntered: {
                        parent.color = "lightgrey";
                    }
                    onExited: {
                        parent.color = "white";
                    }
                }
            }
            // save hand
            Rectangle{
                id: saveHandButton
                width: saveHandButtonText.width+10
                height: saveHandButtonText.height+8
                color: "white"
                border.width: 1
                border.color: "black"
                visible: root.inHandPicking ? true : false

                Text{
                    id: saveHandButtonText
                    text: "Confirm Hand"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                    font.bold: true
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        // count starting hand power
                        if (player.currentHandPower > player.maxStartingHandPower){
                            errorDialogText.text = "Your hand is too powerful to use."
                            errorDialog.visible = true;
                        }
                        else if (player.startingHand.length > 6){
                            errorDialogText.text = "Your maximum hand size is 6."
                            errorDialog.visible = true;
                        }
                        else if (player.startingHand.length < 1){
                            errorDialogText.text = "You must start with at least 1 card in your hand!"
                            errorDialog.visible = true;
                        }
                        else{
                            root.inHandPicking = false;
                            loadStartingHand(player.startingHand)
                            // show combat area
                            inCombat = true;
                        }
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

        Rectangle{
            id: deck_list_container
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            height: 200
            border.width: 2
            border.color: "black"
            color: "white"

            Rectangle{
                anchors.fill: parent
                anchors.margins: 10
                color: "transparent"
                clip: true

                // called deck_list but really holds the deck and the hand depending on state
                Row{
                    id: deck_list
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 10
                    anchors.topMargin: 15
                    height: deck_list_container.height
                    spacing: 10
                }
            }

            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onWheel:{
                    if (deck_list.width > deck_list_container.width){
                        if (wheel.angleDelta.y > 0){
                            if (deck_list.width + deck_list.anchors.leftMargin + 10 > deck_list_container.width){
                                deck_list.anchors.leftMargin -= wheel.angleDelta.y/4;
                            }
                        }
                        else{
                            deck_list.anchors.leftMargin -= wheel.angleDelta.y/4;
                        }
                        if (deck_list.anchors.leftMargin > 10){ deck_list.anchors.leftMargin = 10; }
                    }
                }
            }
        }
    }

    Rectangle{
        id: card_details
        anchors.fill: parent
        color: "#aa444444"
        visible: root.cardHovered == null ? false : true

        Rectangle{
            id: card_preview
            anchors.centerIn: parent
            height: 480
            width: 360
            color: "white"
            border.width: 2
            border.color: "black"

            Column{
                id: card_stats
                spacing: 5
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 20
                anchors.topMargin: 20
                width: parent.width-20

                Text{
                    text: root.cardHovered == null ? "" : root.cardHovered.displayName
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    font.bold: true
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
                Text{
                    text: root.cardHovered == null ? "" : root.cardHovered.cardClass
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
                Text{
                    text: root.cardHovered == null ? "" : root.cardHovered.condition
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
                Text{
                    text: root.cardHovered == null ? "" : root.cardHovered.cost
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
                Text{
                    text: root.cardHovered == null ? "" : root.cardHovered.effect
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }
        }
    }


    Rectangle{
        id: levelup_container
        anchors.centerIn: parent
        anchors.fill: root
        visible: false
        z: 9
        color: "#99111111"
        border.width: 2
        border.color: "black"

        MouseArea{
            id: blockClicksLevelup
            anchors.fill: parent
            propagateComposedEvents: false
            onClicked: {
                levelup_container.visible = false;
                for (var i = 0; i < levelup_box.tempStats.length; i++){ levelup_box.tempStats[i] = 0; }
            }
        }

        Rectangle{
            id: levelup_box
            border.width: 2
            border.color: "black"
            color: "white"
            width: 350
            height: 350
            anchors.centerIn: parent
            property int tempUnspentPoints: 0
            property variant tempStats:[0, 0, 0, 0, 0]

            MouseArea{
                anchors.fill: parent
            }

            Column{
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.topMargin: 30
                spacing: 13

                Text{
                    text: "Allocate Stat Points!"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                }
                Text{
                    text: "Points Remaining: " + levelup_box.tempUnspentPoints
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Row{
                    spacing: 25
                    anchors.left: parent.left
                    anchors.leftMargin: 70
                    Button{
                        text: "+"
                        height: levelup_strength.height
                        width: levelup_strength.height
                        onClicked: {
                            if (levelup_box.tempUnspentPoints > 0){
                                levelup_box.tempUnspentPoints--;
                                levelup_box.tempStats = [levelup_box.tempStats[0]+1, levelup_box.tempStats[1], levelup_box.tempStats[2], levelup_box.tempStats[3], levelup_box.tempStats[4]];
                            }
                       }
                    }
                    Text{
                        id: levelup_strength
                        text: "Strength: " + player.strength + " (+" + levelup_box.tempStats[0] + ")"
                        font.pointSize: root.smallFontSize
                        font.family: root.textFont
                        color: root.textColor
                    }
                }
                Row{
                    spacing: 25
                    anchors.left: parent.left
                    anchors.leftMargin: 70
                    Button{
                        text: "+"
                        height: levelup_dexterity.height
                        width: levelup_dexterity.height
                        onClicked: {
                            if (levelup_box.tempUnspentPoints > 0){
                                levelup_box.tempUnspentPoints--;
                                levelup_box.tempStats = [levelup_box.tempStats[0], levelup_box.tempStats[1]+1, levelup_box.tempStats[2], levelup_box.tempStats[3], levelup_box.tempStats[4]];
                            }
                        }
                    }
                    Text{
                        id: levelup_dexterity
                        text: "Dexterity: " + player.dexterity + " (+" + levelup_box.tempStats[1] + ")"
                        font.pointSize: root.smallFontSize
                        font.family: root.textFont
                        color: root.textColor
                    }
                }
                Row{
                    spacing: 25
                    anchors.left: parent.left
                    anchors.leftMargin: 70
                    Button{
                        text: "+"
                        height: levelup_spellpower.height
                        width: levelup_spellpower.height
                        onClicked: {
                            if (levelup_box.tempUnspentPoints > 0){
                                levelup_box.tempUnspentPoints--;
                                levelup_box.tempStats = [levelup_box.tempStats[0], levelup_box.tempStats[1], levelup_box.tempStats[2]+1, levelup_box.tempStats[3], levelup_box.tempStats[4]];
                            }
                        }
                    }
                    Text{
                        id: levelup_spellpower
                        text: "Spellpower: " + player.spellpower + " (+" + levelup_box.tempStats[2] + ")"
                        font.pointSize: root.smallFontSize
                        font.family: root.textFont
                        color: root.textColor
                    }
                }
                Row{
                    spacing: 25
                    anchors.left: parent.left
                    anchors.leftMargin: 70
                    Button{
                        text: "+"
                        height: levelup_resilience.height
                        width: levelup_resilience.height
                        onClicked: {
                            if (levelup_box.tempUnspentPoints > 0){
                                levelup_box.tempUnspentPoints--;
                                levelup_box.tempStats = [levelup_box.tempStats[0], levelup_box.tempStats[1], levelup_box.tempStats[2], levelup_box.tempStats[3]+1, levelup_box.tempStats[4]];
                            }
                        }
                    }
                    Text{
                        id: levelup_resilience
                        text: "Resilience: " + player.resilience + " (+" + levelup_box.tempStats[3] + ")"
                        font.pointSize: root.smallFontSize
                        font.family: root.textFont
                        color: root.textColor
                    }
                }
                Row{
                    spacing: 25
                    anchors.left: parent.left
                    anchors.leftMargin: 70
                    Button{
                        text: "+"
                        height: levelup_luck.height
                        width: levelup_luck.height
                        onClicked: {
                            if (levelup_box.tempUnspentPoints > 0){
                                levelup_box.tempUnspentPoints--;
                                levelup_box.tempStats = [levelup_box.tempStats[0], levelup_box.tempStats[1], levelup_box.tempStats[2], levelup_box.tempStats[3], levelup_box.tempStats[4]+1];
                            }
                        }
                    }
                    Text{
                        id: levelup_luck
                        text: "Luck: " + player.luck + " (+" + levelup_box.tempStats[4] + ")"
                        font.pointSize: root.smallFontSize
                        font.family: root.textFont
                        color: root.textColor
                    }
                }
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 30
                    // cancel
                    Rectangle{
                        id: cancel_stat_button
                        width: cancel_stat_text.width+12
                        height: cancel_stat_text.height+10
                        color: "white"
                        border.width: 1
                        border.color: "black"

                        Text{
                            id: cancel_stat_text
                            text: "Cancel"
                            font.pointSize: root.tinyFontSize
                            font.family: root.textFont
                            color: root.textColor
                            anchors.centerIn: parent
                        }
                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked:{
                                levelup_container.visible = false;
                                for (var i = 0; i < levelup_box.tempStats.length; i++){ levelup_box.tempStats[i] = 0; }
                            }
                            onEntered: {
                                parent.color = "lightgrey";
                            }
                            onExited: {
                                parent.color = "white";
                            }
                        }
                    }
                    // confirm stats
                    Rectangle{
                        id: confirm_stat_button
                        width: confirm_stat_text.width+12
                        height: confirm_stat_text.height+10
                        color: "white"
                        border.width: 1
                        border.color: "black"

                        Text{
                            id: confirm_stat_text
                            text: "Confirm"
                            font.pointSize: root.tinyFontSize
                            font.family: root.textFont
                            color: root.textColor
                            anchors.centerIn: parent
                        }
                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked:{
                                levelup_container.visible = false;
                                player.strength += levelup_box.tempStats[0];
                                player.dexterity += levelup_box.tempStats[1];
                                player.spellpower += levelup_box.tempStats[2];
                                player.resilience += levelup_box.tempStats[3];
                                player.luck += levelup_box.tempStats[4];
                                for (var i = 0; i < levelup_box.tempStats.length; i++){ levelup_box.tempStats[i] = 0; }
                                player.numUnspentPoints = levelup_box.tempUnspentPoints;
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
        }
    }

    Rectangle{
        id: settings_container
        anchors.centerIn: parent
        anchors.fill: root
        visible: false
        z: 10
        color: "#99111111"
        border.width: 2
        border.color: "black"

        MouseArea{
            id: blockClicksSettings
            anchors.fill: parent
            propagateComposedEvents: false
            onClicked: {
                settings_container.visible = false;
            }
        }

        Rectangle{
            id: settings_box
            border.width: 2
            border.color: "black"
            color: "white"
            width: 150
            height: 150
            anchors.centerIn: parent

            MouseArea{
                anchors.fill: parent
            }

            Column{
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.topMargin: 10
                spacing: 10

                Text{
                    text: "Options"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                }
                // save game
                Rectangle{
                    id: save_game_button
                    width: save_game_text.width+12
                    height: save_game_text.height+10
                    color: "white"
                    border.width: 1
                    border.color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text{
                        id: save_game_text
                        text: "Save Game"
                        font.pointSize: root.tinyFontSize
                        font.family: root.textFont
                        color: root.textColor
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:{
                            playerProgress.saveGame();
                        }
                        onEntered: {
                            parent.color = "lightgrey";
                        }
                        onExited: {
                            parent.color = "white";
                        }
                    }
                }
                // load game
                Rectangle{
                    id: load_game_button
                    width: load_game_text.width+12
                    height: load_game_text.height+10
                    color: "white"
                    border.width: 1
                    border.color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text{
                        id: load_game_text
                        text: "Load Game"
                        font.pointSize: root.tinyFontSize
                        font.family: root.textFont
                        color: root.textColor
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:{
                            playerProgress.loadGame();
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
    }

    Connections{
        target: root

        // enter combat
        onEnterCombat:{
            /* can do it this way as well
            var qmlString = "import QtQuick 2.0; import 'Monsters'; Goblin {}";
            var newMonster = Qt.createQmlObject(qmlString, combat_enemies);
            */
            // clean chat log
            combat_log.text = "";

            // clean enemies container
            for (var m = 0; m < combat_enemies.children.length; m++){
                combat_enemies.children[m].destroy();
            }
            // read from the monster string and load monsters
            var monsterArray = monster.split("*");
            for (var i = 0; i < monsterArray.length; i++){
                var monsterString = "qrc:/qml/Monsters/" + location + "/" + monsterArray[i] + ".qml";
                console.log(monsterString);
                // create new monster and load it into combat_enemies
                var component = Qt.createComponent(monsterString);
                var newMonster = component.createObject(combat_enemies);

                // add to combat log
                var combatLogIntro = "You're fighting the " + newMonster.name + "!";
                root.addToCombatLog(combatLogIntro);
            }

            root.openHandPicker();
        }
        onOpenHandPicker:{
            player.startingHand = []
            player.currentHandPower = 0;

            // clean player deck_list which holds the players hand
            for (var d = 0; d < deck_list.children.length; d++){
                deck_list.children[d].destroy();
            }
            for (var t = 0; t < inventory_tracker.children.length; t++){
                inventory_tracker.children[t].destroy();
            }
            // clean inventory first
            for (var card = 0; card < card_list.children.length; card++){
                card_list.children[card].destroy();
            }
            // load in the deck into the inventory space
            if (player.playerDeck.length != 0){
                var deckArray = player.playerDeck;
                for (var j = 0; j < deckArray.length; j++){
                    var deckString = "qrc:/qml/Cards/" + deckArray[j] + ".qml";
                    // create new card and load it into hand
                    var deckCard = Qt.createComponent(deckString);
                    var newDeckCard = deckCard.createObject(card_list);
                }
            }

            root.inHandPicking = true;
        }
        // load starting hand
        onLoadStartingHand:{
            // clear player_hand
            for (var q = 0; q < player_hand.children.length; q++){
                player_hand.children[q].destroy();
            }

            // copy starting hand into playerHand
            playerHand = [];
            for (var h = 0; h < hand.length; h++){
                playerHand.push(hand[h]);
            }
            for (var i = 0; i < playerHand.length; i++){
                var cardString = "qrc:/qml/Cards/" + playerHand[i] + ".qml";
                // create new card and load it into hand
                var component = Qt.createComponent(cardString);
                var newCard = component.createObject(player_hand);
            }
            // set up deck as well
            playerDeck = [];
            for (var d = 0; d < player.playerDeck.length; d++){
                playerDeck.push(player.playerDeck[d]);
            }
            // then remove the cards in the player's hand from the deck
            for (var c = 0; c < playerHand.length; c++){
                var index = playerDeck.indexOf(playerHand[c]);
                playerDeck.splice(index, 1);
            }
            // now shuffle the deck. do this by splicing the deck randomly and pushing the element into a new array
            var unshuffledDeck = playerDeck;
            var shuffledDeck = [];
            while (unshuffledDeck.length > 0){
                var randIndex = Math.floor(Math.random() * unshuffledDeck.length);
                shuffledDeck.push(unshuffledDeck[randIndex]);
                unshuffledDeck.splice(randIndex, 1);
            }

            playerDeck = shuffledDeck;
            root.isPlayerTurn = true;
        }
        // player turn start
        onStartPlayerTurn:{
            root.isPlayerTurn = true;
            // draw a card. If no cards left, lose combat and lose 10% of gold
            if (playerDeck.length <= 0){
                console.log("Player decked out!");
                combat_outcome.goldGain = Math.round(player.gold * -0.1);
                combat_outcome.goldGain += droppedGold;
                combat_outcome.victory = false;
                combat_outcome.visible = true;
                inCombat = false;
            }
            else{
                var drawCard = playerDeck[0];
                playerDeck.splice(0, 1); // remove top card
                var cardString = "qrc:/qml/Cards/" + drawCard + ".qml";
                // create new card and load it into hand
                var component = Qt.createComponent(cardString);
                var newCard = component.createObject(player_hand);
            }
            if (playerDeck.length == 1){
                root.addToCombatLog("A sharp pain shoots through your head. You rack your brain for ideas, but nothing new comes to you!");
            }
            else if (playerDeck.length == 5){
                root.addToCombatLog("You feel mentally exhausted. You should end this fight soon...");
            }
            else if (playerDeck.length == 10){
                root.addToCombatLog("You start find it harder and harder to focus.");
            }
        }
        // hover and display stats in preview frame
        onPreviewCard:{
            root.cardHovered = card;
        }
        onStopPreviewCard:{
            root.cardHovered = null;
        }
        // select card, change to targetting mode
        onSelectCard:{
            root.cardSelected = card;
            combat_tooltip.text = "Select target.";
        }
        // when player targets an ally with the spell
        onTargetAlly:{
            if (root.cardSelected != null && root.isPlayerTurn){
                if ((!root.cardSelected.selfCast && ally.id !== player.id) || (root.cardSelected.selfCast && ally.id === player.id)){
                    if (root.cardSelected.attemptUseCard()){
                        // use card effect
                        var cardEffectArray = root.cardSelected.effectForParser.split(",");
                        for (var i = 0; i < cardEffectArray.length; i++){
                            var cardEffect = cardEffectArray[i];
                            var cardType = cardEffect.split(":")[0]; // e.g. DAMAGE
                            var amount = cardEffect.split(":")[1];  // e.g. 1+STRENGTH*1
                            var baseAmount = amount.split("+")[0];
                            var totalAmount;
                            var specialScaling = amount.split("+").length === 1 ? amount.split("+")[0] : amount.split("+")[1]; // either 0 or e.g. STRENGTH*1
                            var scaledAmount = 0;
                            if (amount.split("+").length === 1){
                                scaledAmount = specialScaling;
                                totalAmount = baseAmount;
                            }
                            else{
                                var scalingStat = specialScaling.split("*")[0];
                                var scalingMultiplier = specialScaling.split("*")[1];
                                if (scalingStat === "STRENGTH"){ scaledAmount = player.strength; }
                                else if (scalingStat === "DEXTERITY"){ scaledAmount = player.dexterity; }
                                else if (scalingStat === "SPELLPOWER"){ scaledAmount = player.spellpower; }
                                else if (scalingStat === "RESILIENCE"){ scaledAmount = player.resilience; }
                                else if (scalingStat === "LUCK"){ scaledAmount = player.luck; }
                                scaledAmount *= scalingMultiplier;
                                totalAmount = Number(scaledAmount) + Number(baseAmount);
                            }

                            var combatLogText;
                            // reduce damage
                            if (cardType === "REDUCE"){
                                combatLogText = root.cardSelected.useCardText;
                                // replace placeholder strings with values
                                root.addToCombatLog(combatLogText);

                                var statusEffect = ["REDUCE",totalAmount,1];
                                ally.statusEffects.push(statusEffect);
                            }
                            else if (cardType === "HEAL"){
                                combatLogText = root.cardSelected.useCardText;
                                // replace placeholder strings with values
                                root.addToCombatLog(combatLogText);
                                var newHp = Number(ally.hp) + Number(totalAmount);
                                ally.hp = newHp > ally.maxHp ? ally.maxHp : newHp;
                            }
                            else if (cardType === "ENERGY"){
                                combatLogText = root.cardSelected.useCardText;
                                // replace placeholder strings with values
                                root.addToCombatLog(combatLogText);
                                var newEnergy = Number(ally.energy) + Number(totalAmount);
                                ally.energy = newEnergy > ally.maxEnergy ? ally.maxEnergy : newEnergy;
                            }

                        }
                        root.cardSelected.useCard();
                        root.cardSelected = null;
                        combat_tooltip.text = "";
                        // pass turn to the monsters
                        root.isPlayerTurn = false;
                        monster_attack_timer.start();
                    }
                    else{
                        combat_tooltip.text = "Not enough energy or resources to use this card.";
                    }
                }
            }
        }
        // select enemy to target
        onTargetEnemy:{
            if (root.cardSelected != null && root.isPlayerTurn){
                if (!root.cardSelected.selfCast){
                    if (root.cardSelected.attemptUseCard()){
                        // use card effect
                        var cardEffectArray = root.cardSelected.effectForParser.split(",");
                        for (var i = 0; i < cardEffectArray.length; i++){
                            var cardEffect = cardEffectArray[i];
                            var cardType = cardEffect.split(":")[0]; // e.g. DAMAGE
                            var amount = cardEffect.split(":")[1];  // e.g. 1+STRENGTH*1
                            var baseAmount = amount.split("+")[0];
                            var totalAmount;
                            var specialScaling = amount.split("+").length === 1 ? amount.split("+")[0] : amount.split("+")[1]; // either 0 or e.g. STRENGTH*1
                            var scaledAmount = 0;
                            if (amount.split("+").length === 1){
                                scaledAmount = specialScaling;
                                totalAmount = baseAmount;
                            }
                            else{
                                var scalingStat = specialScaling.split("*")[0];
                                var scalingMultiplier = specialScaling.split("*")[1];
                                if (scalingStat === "STRENGTH"){ scaledAmount = player.strength; }
                                else if (scalingStat === "DEXTERITY"){ scaledAmount = player.dexterity; }
                                else if (scalingStat === "SPELLPOWER"){ scaledAmount = player.spellpower; }
                                else if (scalingStat === "RESILIENCE"){ scaledAmount = player.resilience; }
                                else if (scalingStat === "LUCK"){ scaledAmount = player.luck; }
                                scaledAmount *= scalingMultiplier;
                                totalAmount = Number(scaledAmount) + Number(baseAmount);
                            }

                            var combatLogText;
                            if (cardType === "DAMAGE"){
                                console.log("Target " + enemy.name + " with " + cardEffect);
                                combatLogText = root.cardSelected.useCardText;

                                var damageActuallyTaken = enemy.calculateDamageMitigation(totalAmount);

                                // replace placeholder strings with values
                                combatLogText = combatLogText.replace(/&ENEMY&/g, enemy.name);
                                combatLogText = combatLogText.replace(/&DAMAGE&/g, damageActuallyTaken);
                                root.addToCombatLog(combatLogText);

                                enemy.hp -= damageActuallyTaken;
                            }

                        }
                        root.cardSelected.useCard();
                        root.cardSelected = null;
                        combat_tooltip.text = "";
                        // pass turn to the monsters
                        root.isPlayerTurn = false;
                        monster_attack_timer.start();
                    }
                    else{
                        combat_tooltip.text = "Not enough energy or resources to use this card.";
                    }
                }
            }
        }
        // perform monster turns
        onDoMonsterActions:{
            var m = monsterNum;
            if (m < combat_enemies.children.length){
                var monster = combat_enemies.children[m].children[0];
                // if the monster object isnt destroyed yet, they might attack! so put an extra check here
                if (monster.hp > 0){
                    var monsterAction = monster.monsterAttack();
                    var actionType = monsterAction.split(":")[0];
                    var amountRange = monsterAction.split(":")[1];
                    var monsterActionText = monsterAction.split(":")[2];
                    if (actionType === "MISS"){
                        monsterActionText = monsterAction.split(":")[1];
                        monsterActionText = monsterActionText.replace(/&ENEMY&/g, monster.name);
                        root.addToCombatLog(monsterActionText);
                    }
                    else if (actionType === "DAMAGE"){
                        var difference = Number(amountRange.split("-")[1]) - Number(amountRange.split("-")[0]);
                        // roll for amount of damage
                        var amount = Math.round(Math.random()*difference + Number(amountRange.split("-")[0]));

                        // pick a target from combat_allies. Always target lowest %HP member.
                        var lowestHpIndexSoFar = 0;
                        var lowestHpPercent = 1;    // 100%
                        for (var t = 0; t < combat_allies.children.length; t++){
                            if (combat_allies.children[t].hp/combat_allies.children[t].maxHp < lowestHpPercent){
                                lowestHpPercent = combat_allies.children[t].hp/combat_allies.children[t].maxHp;
                                lowestHpIndexSoFar = t;
                            }
                        }
                        var target = combat_allies.children[lowestHpIndexSoFar];
                        // deal damage to target
                        var damageActuallyTaken = target.calculateDamageMitigation(amount);
                        monsterActionText = monsterActionText.replace(/&DAMAGE&/g, damageActuallyTaken);
                        monsterActionText = monsterActionText.replace(/&ENEMY&/g, monster.name);
                        root.addToCombatLog(monsterActionText);

                        target.hp -= damageActuallyTaken;
                    }
                }
            }
        }
        // on monster death
        onMonsterKilled:{
            var combatLogText = monster.name + " was defeated! ";
            root.addToCombatLog(combatLogText);
            // add obtained loot to lootSoFar
            combat_outcome.goldGain += droppedGold;
            for (var q = 0; q < droppedLoot.length; q++){
                combat_outcome.lootSoFar.push(droppedLoot[q]);
            }
            for (var r = 0; r < droppedResources.length; r++){
                var newArray = [];
                var indexToAdd = -1;
                if (droppedResources[r] === "Metal"){ indexToAdd = 0; }
                else if (droppedResources[r] === "Fur"){ indexToAdd = 1; }
                else if (droppedResources[r] === "Medicinal Herb"){ indexToAdd = 2; }
                else if (droppedResources[r] === "Arrow"){ indexToAdd = 3; }
                else if (droppedResources[r] === "Magic Crystal"){ indexToAdd = 4; }
                for (var w = 0; w < player.playerResourceNames.length; w++){
                    if (w === indexToAdd){ newArray.push(combat_outcome.resourcesSoFar[w]+1); }
                    else { newArray.push(combat_outcome.resourcesSoFar[w]); }
                }
                combat_outcome.resourcesSoFar = newArray;
            }
            combat_outcome.experienceGained += droppedExperience;
            console.log("Gold: " + combat_outcome.goldGain + ", Loot: " + combat_outcome.lootSoFar);

            // check if all monsters are dead. This is called before monster
            // is destroyed, so we check for length of 1 instead of 0.
            if (combat_enemies.children.length === 1){
                combat_outcome.victory = true;
                inCombat = false;

                showLootGained();
            }
        }
        onShowLootGained:{
            combat_outcome.visible = true;

            // load loot into combat_loot_items
            if (combat_outcome.lootSoFar.length > 0){
                var itemArray = combat_outcome.lootSoFar;
                for (var i = 0; i < itemArray.length; i++){
                    var itemString = "qrc:/qml/Cards/" + itemArray[i] + ".qml";
                    // create new card and load it into loot items
                    var item = Qt.createComponent(itemString);
                    var newCard = item.createObject(combat_loot_items);
                }
            }
        }

        // add items to inventory if there are no duplicates
        onAddToInventory:{
            var itemArray = itemString;
            for (var i = 0; i < itemArray.length; i++){
                var exists = false;
                for (var check = 0; check < player.playerInventory.length; check++){
                    if (player.playerInventory[check] === itemArray[i]){ exists = true; }
                }
                if (!exists){
                    player.playerInventory.push(itemArray[i]);
                }
            }
        }

        // change location
        onChangeLocation:{
            place_container.children[0].destroy();
            var locationString = "qrc:/qml/Places/" + root.location + "/" + loc + ".qml";
            //console.log(locationString);
            var newLocation = Qt.createComponent(locationString);
            var newLoc = newLocation.createObject(place_container);
        }
        // set location
        onSetLocation:{
            root.location = loc;
            //console.log("World location changed to " + root.location);
        }
        // update a value: param, value
        onUpdateValue:{
            // no way to change property without calling it directly, so use a switch
            switch(param){
                case "name":
                    player.name = value;break;
                case "race":
                    player.race = value;break;
                case "level":
                    player.level = value;break;
                case "strength":
                    player.strength = value;break;
                case "dexterity":
                    player.dexterity = value;break;
                case "spellpower":
                    player.spellpower = value;break;
                case "resilience":
                    player.resilience = value;break;
                case "luck":
                    player.luck = value;break;
                case "maxHp":
                    player.maxHp = value;break;
                case "hp":
                    player.hp = value;break;
                case "maxEnergy":
                    player.maxEnergy = value;break;
                case "energy":
                    player.energy = value;break;
                case "gold":
                    player.gold = value;break;
            }
        }
        onAddToCombatLog:{
            combat_log.text += combatText + "\n\n";
        }

        // inventory stuff
        onOpenInventory:{
            // clean inventory first
            for (var card = 0; card < card_list.children.length; card++){
                card_list.children[card].destroy();
            }
            for (var t = 0; t < inventory_tracker.children.length; t++){
                inventory_tracker.children[t].destroy();
            }
            // load in all the cards the player owns
            var inventoryArray = playerInventory;
            for (var i = 0; i < inventoryArray.length; i++){
                var itemString = "qrc:/qml/Cards/" + inventoryArray[i] + ".qml";
                // create new card and load it into hand
                var item = Qt.createComponent(itemString);
                var newItem = item.createObject(card_list);
                var copy = item.createObject(inventory_tracker);
            }
            // clean player deck_list
            for (var d = 0; d < deck_list.children.length; d++){
                deck_list.children[d].destroy();
            }
            // load player deck
            player.currentDeckPower = 0;
            if (player.playerDeck.length != 0){
                var deckArray = player.playerDeck;
                for (var j = 0; j < deckArray.length; j++){
                    var deckString = "qrc:/qml/Cards/" + deckArray[j] + ".qml";
                    // create new card and load it into hand
                    var deckCard = Qt.createComponent(deckString);
                    var newDeckCard = deckCard.createObject(deck_list);
                    player.currentDeckPower += newDeckCard.power;
                }
            }
        }
    }
}
