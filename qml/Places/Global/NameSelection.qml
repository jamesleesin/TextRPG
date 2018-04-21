import QtQuick 2.0
import "../"

Item {
    id: nameselection
    anchors.fill: parent

    Place{
        id: place
        name: ""
        introText: "What is your character's name?"
        links:[""]
        requireTextEntry: "Enter Name"
        worldLocation: "Global"
        setCallback: true
    }

    Connections{
        target: place
        onPlaceCallback:{
            root.changeLocation("TutorialCombat");
        }
    }
}
