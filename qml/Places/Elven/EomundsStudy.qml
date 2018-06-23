import QtQuick 2.0
import "../"

Item {
    id: eomundsstudy
    anchors.fill: parent

    Place{
        name: "Eomund's Study"
        introText: "You gently knock on the wooden door. It slowly creaks open, revealing an old elf leaning back in a sturdy chair, with an old scroll in his hands. He looks up at you, without a trace of affection nor hostility."
        links:["TheLibrary"]
        linkAltText: ["Leave"]
        worldLocation: "Elven"
        npcList: ["Eomund"]
    }

}
