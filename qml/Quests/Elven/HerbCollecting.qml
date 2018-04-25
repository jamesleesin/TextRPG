import QtQuick 2.0
import "../"

Rectangle {
    id: herbcollecting
    property string name: "HerbCollecting"
    property string displayName: "Herb Collecting"
    property string shortDescription: "Collect 5 Medicinal Herbs."
    property string fullDescription: "Always be prepared before going out to hunt! Collect 5 Medicinal Herbs and bring them to Alva."
    property string reward: "10g"

    width: 500
    height: 160
    radius: 8
    border.width: 3
    border.color: "black"
    color: "#ffffff"

    QuestContainer{
        id: quest_container
        name: parent.name
        displayName: parent.displayName
        shortDescription: parent.shortDescription
        fullDescription: parent.fullDescription
        reward: parent.reward
    }
}
