import QtQuick 2.0
import "../"

Rectangle {
    id: punch
    property string name: "Punch"
    property string displayName: "Punch"
    property string cardClass: "Neutral"
    property string condition: "None"
    property int power: 1
    property string cost: "Energy - 1"
    property string effect: "Deal 1(+Strength) damage to a single enemy."
    property string effectForParser: "DAMAGE:10+STRENGTH*1"
    property string cardType: "Spell"
    property string useCardText: "You land a quick punch on the &ENEMY& for &DAMAGE& damage."
    property int cardNumber: 1
    property bool selfCast: false

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
        punch.destroy();
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
