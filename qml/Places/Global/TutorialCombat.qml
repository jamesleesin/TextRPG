import QtQuick 2.0
import "../"

Item {
    id: tutorialcombat
    anchors.fill: parent

    Place{
        id: place
        name: "Combat!"
        introText: "You stumble across a goblin. He snarls and charges at you!"
        links:["Goblin*Goblin"]
        linkAltText: ["Fight!"]
        combatOutcomeLinks: []
        combatOutcomeLocation: "Elven"
        zoneDifficulty: 10
        worldLocation: "Global"

        Component.onCompleted: {
            if (player.race === "Elf"){
                combatOutcomeLinks.push("Eleren");
                combatOutcomeLinks.push("TheCrossedArrows");
            }
        }
    }
}
