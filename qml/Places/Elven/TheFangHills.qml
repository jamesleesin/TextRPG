import QtQuick 2.0
import "../"

Item {
    id: thefanghills
    anchors.fill: parent

    Place{
        name: "The Fang Hills"
        introText: "Known to the elves as a training ground due to the abundance of beasts and wild game, The Fang Hills is a great place for any budding elf to gain some experience in combat.\n\nBehind you is the small winding path back to Eleren. In the distance, you can see the dark aura of The Dusk Jungle.\n\n"
        links:["Eleren", "TheDuskJungle"]
        linkAltText: ["Eleren", "The Dusk Jungle"]
        worldLocation: "Elven"
        canExplore: true
        combatChance: 0.7
        zoneDifficulty: 20
        possibleCombats: ["1-Wolf-You hear a low growl behind you. You spin around to see a wolf, fangs bared!"] // make sure this adds to 1
        combatOutcomeLinks: ["TheFangHills", "Eleren"]
        combatOutcomeLocation: "Elven"
    }
}
