import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2

/*
 * B for boss
 * E for normal enemy
 * S for start (entrance)
 * 1 for path
 * 0 for wall
 * C for treasure chest
*/

Item{
    id: dungeon
    anchors.fill: parent
    property string name: ""
    property int difficultyLevel: 0
    property variant dungeonMap: []
    property variant playerLocation: []
    signal exitedDungeon(int gold, variant loot)

    // combats
    property variant possibleCombats: []
    property variant possibleBosses: []
    property string worldLocation: ""
    property bool bossKilled: false

    // chests
    property double trapChance: 0
    property variant possibleLoot: []
    property variant trapList: []
    property string chestGold: ""

    // accumulated items
    property variant accumulatedLoot:[]
    property int accumulatedGold: 0

    Component{
        id: dungeon_button

        Button{
            id: button
            property string buttonText: ""
            property int enemyNum: -1
            property int bossNum: -1
            text: buttonText
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: (dungeon_buttons.width - (parent.height/16)*(dungeon_buttons.children.length))/dungeon_buttons.children.length
            style: ButtonStyle {
                label: Text {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family:  root.textFont
                    font.pointSize: root.mediumFontSize
                    text: control.text
                }
            }

            onClicked: {
                dungeon_action.text = "";
                if (buttonText === "Exit Dungeon"){
                    dungeon_action.text = "";
                    exitedDungeon(accumulatedGold, accumulatedLoot);
                }
                else if (buttonText === "Fight!"){
                    root.setLocation(worldLocation);
                    if (enemyNum > -1){
                        root.enterCombat(possibleCombats[enemyNum].split("-")[0]);
                    }
                    else if (bossNum > -1){
                        root.enterCombat(possibleBosses[bossNum].split("-")[0]);
                    }
                }
                else if (buttonText === "Open it!"){
                    attemptOpenChest();
                    dungeon_action.text += "";
                }
                else{
                    if (buttonText === "North"){
                        playerLocation = [playerLocation[0]-1, playerLocation[1]];
                    }
                    else if (buttonText === "South"){
                        playerLocation = [playerLocation[0]+1, playerLocation[1]];
                    }
                    else if (buttonText === "West"){
                        playerLocation = [playerLocation[0], playerLocation[1]-1];
                    }
                    else if (buttonText === "East"){
                        playerLocation = [playerLocation[0], playerLocation[1]+1];
                    }
                    dungeon_action.text += "You move " + buttonText + ".\n\n";
                    //dungeon_scroll.flickableItem.contentY += 1000;
                    createOptionButtons();
                    console.log(dungeon.playerLocation);
                    tileActions();
                }
            }
        }
    }

    Component{
        id: dungeon_tile

        Rectangle{
            id: tile
            border.width: 1
            border.color: "black"
            width: 20
            height: 20
            property string tileType: ""
            property int tileX: -1
            property int tileY: -1
            color: {
                if (tileType === "Path"){
                    return "#e5c4a6";
                }
                else if (tileType === "Enemy1" || tileType === "Enemy2"){
                    return "#e5c4a6";
                }
                else if (tileType === "Wall"){
                    return "#838b8b";
                }
                else if (tileType === "Chest"){
                    return "#fff400";
                }
                else if (tileType === "Boss"){
                    return "#ff0000";
                }
                else if (tileType === "Start"){
                    return "#00ff00";
                }
                else{
                    return "#ffffff";
                }
            }
            Rectangle{
                visible: tileY === playerLocation[0] && tileX === playerLocation[1] ? true : false
                anchors.centerIn: tile
                width: 14
                height: 14
                radius: 7
                color: "green"
            }
            Rectangle{
                visible: tileType.indexOf("Enemy") >= 0 ? true : false
                anchors.centerIn: tile
                width: 14
                height: 14
                radius: 7
                color: "red"
            }
        }

    }

    function victory(){
         dungeon_action.text += "You won the fight!"+ "\n\n";
         dungeonMap[playerLocation[0]][playerLocation[1]] = 1;
         createOptionButtons();
    }
    function defeat(){
         dungeon_action.text += "You lost the fight!"+ "\n\n";
    }

    // roll for trap chance and loot
    function attemptOpenChest(){
        var roll = Math.random();
        if (roll < trapChance){
            // traps all have equal chance
            var trapRoll = Math.floor(Math.random() * trapList.length);
            var trapDamageRange = trapList[trapRoll].split(":")[0];
            var trapText = trapList[trapRoll].split(":")[1];
            var difference = Number(trapDamageRange.split("-")[1]) - Number(trapDamageRange.split("-")[0]);
            var trapDamage = Math.round(Math.random()*difference + Number(trapDamageRange.split("-")[0]));
            var damagePostMitigation = player.calculateDamageMitigation(trapDamage);
            player.hp -= damagePostMitigation;
            trapText = trapText.replace("$DAMAGE$", damagePostMitigation);
            dungeon_action.text += trapText + "\n\n";
        }
        else{
            // roll for loot
            // get player luck
            var playerLuck = root.getPlayerLuck();
            // roll for loot drop
            var droppedLoot = [];
            for (var i = 0; i < possibleLoot.length; i++){
                var dropChance = possibleLoot[i].split("-")[0];
                var item = possibleLoot[i].split("-")[1];
                if (Math.random() < dropChance){
                    droppedLoot.push(item);
                }
            }
            var lootText = "";
            var goldRange = Number(chestGold.split("-")[1]) - Number(chestGold.split("-")[0]);
            var goldGain = Math.round(Math.random()*goldRange + Number(chestGold.split("-")[0]));
            accumulatedGold += goldGain;
            lootText += "You find " + goldGain + " gold inside! ";
            if (droppedLoot.length < 1){
                lootText += "You continue emptying out the chest, but find nothing else of interest.";
            }
            else{
                lootText += "You find the following items: " + droppedLoot[0].split("/")[1];
                for (var l = 1; l < droppedLoot.length; l++){
                    lootText += ", " + droppedLoot[l].split("/")[1];
                    accumulatedLoot += droppedLoot[l];
                }
                lootText += ".\n\n";
            }
             dungeon_action.text += lootText;
        }
    }

    // text and stuff that happens on a particular tile
    function tileActions(){
        if (dungeonMap[playerLocation[0]][playerLocation[1]] === "E1"){
            var combatText = possibleCombats[0].split("-")[1];
            dungeon_action.text += combatText + "\n\n";
        }
        if (dungeonMap[playerLocation[0]][playerLocation[1]] === 'B'){
            var bossText = possibleBosses[0].split("-")[1];
            dungeon_action.text += bossText + "\n\n";
        }
        if (dungeonMap[playerLocation[0]][playerLocation[1]] === 'C'){
            var chestText = "You carefully approach the shimmer and see an old box covered by some debris. Gently clearing off the top, you realize that there could be some loot you could take - or it could just be a cleverly disguised booby trap.";
            dungeon_action.text += chestText + "\n\n";
        }
    }

    // row, col
    function findPlayer(){
        for (var row = 0; row < dungeonMap.length; row++){
            for (var col = 0; col < dungeonMap[row].length; col++){
                if (dungeonMap[row][col] === 'S'){
                    var coord = []; coord.push(row); coord.push(col); return coord;
                }
            }
        }
    }

    // return the possible directions from a current location, as well
    // as add descriptions for what is in each direction.
    function possibleDirections(curRow, curCol){
        var directions = [0, 0, 0, 0]; // up, down, left, right
        // check up
        if (curRow !== 0){
            if (dungeonMap[curRow-1][curCol] !== 0){
                directions[0] = 1;
                addDungeonText(0, dungeonMap[curRow-1][curCol]);
            }
        }
        // check down
        if (curRow !== dungeonMap.length-1){
            if (dungeonMap[curRow+1][curCol] !== 0){
                directions[1] = 1;
                addDungeonText(1, dungeonMap[curRow+1][curCol]);
            }
        }
        // check left
        if (curCol !== 0){
            if (dungeonMap[curRow][curCol-1] !== 0){
                directions[2] = 1;
                addDungeonText(2, dungeonMap[curRow][curCol-1]);
            }
        }
        // check right
        if (curCol !== dungeonMap[curRow].length-1){
            if (dungeonMap[curRow][curCol+1] !== 0){
                directions[3] = 1;
                addDungeonText(3, dungeonMap[curRow][curCol+1]);
            }
        }
        return directions;
    }

    // describe the possible directions the player can take
    function addDungeonText(dirNum, thing){
        var dirNames = ["North","South","West","East"];
        var detailText = "";
        switch (thing){
            case 'S':
                detailText += "see the entrance to the dungeon.";
                break;
            case 'C':
                detailText += "spot a shimmer in the darkness.";
                break;
            case 'B':
                detailText += "sense a very dangerous aura.";
                break;
            case 'E1':
                detailText += "notice something moving in the shadows.";
                break;
            case 'E2':
                detailText += "catch a glimpse of... something.";
                break;
            case 1:
                detailText += "can see a path leading further into the dungeon.";
                break;
        }
        dungeon_action.text += "To the " + dirNames[dirNum] + " you " + detailText + "\n\n";
    }

    function createOptionButtons(){
        // clean buttons
        for (var i = 0; i < dungeon_buttons.children.length; i++){
            dungeon_buttons.children[i].destroy();
        }
        if (dungeonMap[playerLocation[0]][playerLocation[1]] === 'C'){
            // create open or leave it chest buttons
            var openBut = dungeon_button.createObject(dungeon_buttons);
            openBut.buttonText = "Open it!";
        }
        if (dungeonMap[playerLocation[0]][playerLocation[1]] === "E1"){
            var fightBut = dungeon_button.createObject(dungeon_buttons);
            fightBut.buttonText = "Fight!";
            fightBut.enemyNum = 0;
        }
        else if (dungeonMap[playerLocation[0]][playerLocation[1]] === 'B'){
            var bossBut = dungeon_button.createObject(dungeon_buttons);
            bossBut.buttonText = "Fight!";
            bossBut.bossNum = 0;
        }
        else{
            var dirNames = ["North","South","West","East"];
            var directions = possibleDirections(playerLocation[0], playerLocation[1]);
            for (var d = 0; d < directions.length; d++){
                if (directions[d] === 1){
                    var dirBut = dungeon_button.createObject(dungeon_buttons);
                    dirBut.buttonText = dirNames[d];
                }
            }
            if (dungeonMap[playerLocation[0]][playerLocation[1]] === 'S'){
                var exitBut = dungeon_button.createObject(dungeon_buttons);
                exitBut.buttonText = "Exit Dungeon";
            }
        }

        updateMinimap();
    }

    function updateMinimap(){
        // clean minimap
        for (var i = 0; i < dungeon_minimap.children.length; i++){
            dungeon_minimap.children[i].destroy();
        }
        var colStart = playerLocation[1] < 2 ? 0 : playerLocation[1]-2;
        var colEnd = playerLocation[1] >= dungeonMap[0].length-2 ? dungeonMap[0].length-1 : playerLocation[1]+2;
        var rowStart = playerLocation[0] < 2 ? 0 : playerLocation[0]-2;
        var rowEnd = playerLocation[0] >= dungeonMap.length-2 ? dungeonMap.length-1 : playerLocation[0]+2;
        dungeon_minimap.columns = colEnd-colStart+1;
        dungeon_minimap.rows = rowEnd-rowStart+1;
        for (var row = rowStart; row <= rowEnd; row++){
            for (var col = colStart; col <= colEnd; col++){
                var newTile = dungeon_tile.createObject(dungeon_minimap);
                newTile.tileX = col;
                newTile.tileY = row;
                if (dungeonMap[row][col] === 'S'){ newTile.tileType = "Start"; }
                else if (dungeonMap[row][col] === 1){ newTile.tileType = "Path"; }
                else if (dungeonMap[row][col] === 0){ newTile.tileType = "Wall"; }
                else if (dungeonMap[row][col] === 'C'){ newTile.tileType = "Chest"; }
                else if (dungeonMap[row][col] === 'B'){ newTile.tileType = "Boss"; }
                else if (dungeonMap[row][col] === "E1"){ newTile.tileType = "Enemy1"; }
                else if (dungeonMap[row][col] === "E2"){ newTile.tileType = "Enemy2"; }
            }
        }
    }

    Rectangle{
        anchors.fill: parent
        border.width: 2
        border.color: "black"

        Rectangle{
            id: dungeon_text
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: dungeon_options.top
            border.width: 2
            border.color: "black"
            color: "#D8C19D"

            ScrollView{
                id: dungeon_scroll
                anchors.fill: parent

                Column{
                    width: dungeon_text.width-30
                    spacing: 15
                    anchors.top: parent.top
                    anchors.topMargin: 15

                    Text{
                        id: dungeon_name
                        text: name
                        font.pointSize: root.mediumFontSize
                        font.family: root.textFont
                        color: root.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: dungeon_text.width-30
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        font.bold: true
                        visible: name == "" ? false : true
                    }
                    Text{
                        id: dungeon_action
                        text: ""
                        font.pointSize: root.smallFontSize
                        font.family: root.textFont
                        color: root.textColor
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        width: dungeon_text.width-60
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
        Rectangle{
            id: minimap_container
            anchors.right: parent.right
            anchors.bottom: dungeon_options.top
            anchors.margins: 20
            color: "#44444444"
            width: 180
            height: 180
            radius: 90

            GridLayout{
                id: dungeon_minimap
                anchors.centerIn: parent
                rows: 5
                columns: 5
                columnSpacing: 0
                rowSpacing: 0
            }
        }

        Rectangle{
            id: dungeon_options
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 200
            border.width: 2
            border.color: "black"

            // Button options
            GridLayout{
                id: dungeon_buttons
                anchors.fill: parent
                anchors.margins: 20
                rows: 3
                columns: 4
                columnSpacing: parent.height/16
                visible: dungeon_buttons.children.length > 0 ? true : false
            }
        }
    }
}
