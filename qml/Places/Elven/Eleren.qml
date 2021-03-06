import QtQuick 2.0
import "../"

Item {
    id: eleren
    anchors.fill: parent

    Place{
        name: "Eleren"
        introText: "You approach the old wooden gate leading to the village where you were born, Eleren. The two guards at the gate raise their spears, always wary of strangers, but lower them once recognizing you.\n\nThe small village is quiet, except for the sound of the gentle breeze.\n\nTo the left you see the single tavern in town, The Crossed Arrows, a favourite for hunters returning from a day's work.\n\nTo the right you see a small merchant store, called the Nature's Vault.\n\nIn front, The Library stands tall, welcoming all who wish to delve into the history of elvenkind.\n\nBehind you is a trail that leads to The Fang Hills, known as a training ground for anyone wishing to hone their combat skills."
        links:["TheCrossedArrows", "NaturesVault", "TheLibrary", "TheFangHills"]
        linkAltText: ["The Crossed Arrows", "Nature's Vault", "The Library", "The Fang Hills"]
        worldLocation: "Elven"
    }
}
