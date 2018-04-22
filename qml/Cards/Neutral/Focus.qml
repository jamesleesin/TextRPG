import QtQuick 2.0
import "../"

Rectangle {
    id: focus
    property string name: "Focus"
    property string displayName: "Focus"
    property string cardClass: "Neutral"
    property string condition: "None"
    property int power: 1
    property string cost: "Energy - 0"
    property string effect: "Gain 2 Energy."
    property string effectForParser: "ENERGY:2"
    property string cardType: "Spell"
    property string useCardText: "You close your eyes and catch your breath, restoring 2 energy."
    property int cardNumber: 4
    property bool selfCast: true

    width: 120
    height: 160
    radius: 8
    border.width: 3
    border.color: card_container != undefined ? card_container.selected ? "yellow" : "black" : "black"
    gradient: Gradient{
        GradientStop { position: 0.0; color: card_container != undefined ? card_container.getGradientColor1() : "#ffffff" }
        GradientStop { position: 1.0; color: card_container != undefined ? card_container.getGradientColor2() : "#ffffff" }
    }

    // if card container is destroyed then destroy this as well
    onChildrenChanged: {
        focus.destroy();
    }

    CardContainer{
        id: card_container
        name: parent.name
        displayName: parent.displayName
        cardClass: parent.cardClass
        condition: parent.condition
        power: parent.power
        cost: parent.cost
        effect: parent.effect
        effectForParser: parent.effectForParser
        cardType: parent.cardType
        useCardText: parent.useCardText
        cardNumber: parent.cardNumber
        selfCast: parent.selfCast
        anchors.fill: parent
    }
}
