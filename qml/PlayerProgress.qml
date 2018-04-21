import QtQuick 2.0

Item {
    id: playerProgress

    // store variables and values about the state of the game
    property bool doneTutorial: false


    // player stats
    property string name: ""
    property string race: ""
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
    property int gold: 0
    property int currentDeckPower: 0
    property int currentHandPower: 0
    property int maxDeckPower: 20 + level*5
    property int maxStartingHandPower: 3 + Math.floor(spellpower/3)
    property variant startingHand: []
    property variant playerDeck: []
    property variant playerInventory: []
    property variant statusEffects:[]

    // save the game by writing everything into a text file
    function saveGame(){
        var saveString = [];
        saveString.push(player.name);
        saveString.push(player.race);
        saveString.push(player.level);
        var deckList = "";
        for (var c = 0; c < player.playerDeck.length; c++){
            deckList += player.playerDeck[c] + "*";
        }
        deckList = deckList.substring(0, deckList.length-1);   // remove last *
        saveString.push(deckList);

        FileIO.saveGame(saveString);
    }

    // set player variables to values from the save file
    function loadGame(){
        var loadData = FileIO.loadGame();
        player.name = loadData[0];
        player.race = loadData[1];
        player.level = loadData[2];

        var deckList = [];
        var loadedDeck = loadData[3].split("*");
        for (var c = 0; c < loadedDeck.length; c++){
            deckList.push(loadedDeck[c]);
        }
        player.playerDeck = deckList;
    }
}
