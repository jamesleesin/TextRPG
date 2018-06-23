import QtQuick 2.0
import "../"

Item {
    id: thelibrary
    anchors.fill: parent

    Place{
        name: "The Library"
        introText: "The Elven Library is one of the oldest structures in Eleren. Dating back hundreds of years, it is said that the entirety of Elvish history is recorded in its sturdy oak walls."
        links:["EomundsStudy", "Eleren"]
        linkAltText: ["Eomund's Study", "Back Outside"]
        worldLocation: "Elven"
    }

}
