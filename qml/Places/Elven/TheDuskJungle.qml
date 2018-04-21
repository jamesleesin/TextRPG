import QtQuick 2.0
import "../"

Item {
    id: theduskjungle
    anchors.fill: parent

    Dungeon{
        id: dungeon
        name: "The Dusk Jungle"
        difficultyLevel: 3
        visible: false
        playerLocation: []
        dungeonMap: []
        possibleCombats: ["Wolf-You hear a low growl behind you. You spin around to see a wolf, fangs bared!"]
        possibleBosses: ["GiantBear-Stepping forward, you squint into the darkness. Suddenly, you see two yellow eyes light up a few steps in front of you! With a loud roar, a giant bear appears and charges at you!"]
        worldLocation: "Elven"
        trapChance: 0.3
        possibleLoot: ["0.1-Neutral/Kick","0.1-Neutral/Punch"]
        chestGold: "10-20"
        trapList: ["3-4:As you open the chest, arrows suddenly fly out from the wall beside you! You lose $DAMAGE$ hp."]
    }

    Place{
        id: place
        name: "The Dusk Jungle"
        introText: "You stand at the entrance of the jungle, hesitant to step inside. From a young age you were taught about the dangers of this place, and about how fools who entered were never to be heard from again.\n\nThe trees sway softly in the wind, as if beckoning you to explore its depths."
        links:["TheFangHills"]
        linkAltText: ["Back to The Fang Hills"]
        worldLocation: "Elven"
        isDungeon: true
    }

    Connections{
        target: place
        onEnteredDungeon:{
            place.visible = false;
            dungeon.visible = true;

            // push map
            dungeon.dungeonMap.push([0,0,0,0,0,0,0,0,0,0]);
            dungeon.dungeonMap.push([0,'B',0,0,0,0,'C',0,0,0]);
            dungeon.dungeonMap.push([0,1,0,0,0,1,1,1,0,0]);
            dungeon.dungeonMap.push([0,1,0,0,0,1,0,1,0,0]);
            dungeon.dungeonMap.push([0,1,1,1,1,1,0,1,1,0]);
            dungeon.dungeonMap.push([0,0,1,0,0,1,0,1,0,0]);
            dungeon.dungeonMap.push([0,0,1,1,0,"E1",1,1,0,0]);
            dungeon.dungeonMap.push([0,0,0,1,1,1,0,0,0,0]);
            dungeon.dungeonMap.push([0,0,0,0,0,'S',0,0,0,0]);

            dungeon.playerLocation = dungeon.findPlayer();
            dungeon.createOptionButtons();
            console.log(dungeon.playerLocation);
        }
    }
    Connections{
        target: dungeon
        onExitedDungeon:{
            dungeon.visible = false;
            dungeon.dungeonMap = [];
            place.visible = true;
            combat_outcome.fromDungeon = true;
            combat_outcome.victory = true;
            combat_outcome.goldGain += gold;
            combat_outcome.bossKilled = dungeon.bossKilled;
            combat_outcome.experienceGained = dungeon.bossKilled ? dungeon.difficultyLevel*10 : 0;
            for (var i = 0; i < loot.length; loot++){
                combat_outcome.lootSoFar.push(loot[i]);
            }
            root.showLootGained();
        }
    }
}
