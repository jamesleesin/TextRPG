import QtQuick 2.0
import "../"

Item {
    id: thecrossedarrows
    anchors.fill: parent

    Place{
        name: "The Crossed Arrows"
        introText: "The small pub is empty as always, save for the occasional hunters returning from their expeditions."
        links:["Eleren"]
        linkAltText: ["Back Outside"]
        worldLocation: "Elven"
        npcList: ["Naimer"]
    }

}
