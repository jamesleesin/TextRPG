import QtQuick 2.0
import "../"

Item {
    id: eleren
    anchors.fill: parent

    Place{
        name: "Eleren"
        introText: "You approach the old wooden gate leading to the village where you were born, Eleren. The two guards at the gate raise their spears, always wary of strangers, but lower them once recognizing you.\n\nThe small village is quiet, except for the sound of the gentle breeze.\n\nTo the left you see the single tavern in town, The Crossed Arrows, a favourite for hunters returning from a day's work. Behind you is trail that leads to The Fang Hills, known as a training ground for anyone wishing to hone their combat skills."
        links:["TheCrossedArrows", "TheFangHills"]
        linkAltText: ["The Crossed Arrows", "The Fang Hills"]
        worldLocation: "Elven"
    }
}
