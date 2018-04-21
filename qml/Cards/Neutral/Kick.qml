import QtQuick 2.0
import "../"

Rectangle {
    id: kick
    property string name: "Kick"
    property string displayName: "Kick"
    property string cardClass: "Neutral"
    property string condition: "None"
    property int power: 1
    property string cost: "Energy - 2"
    property string effect: "Deal 2(+Strength) damage to a single enemy."
    property string effectForParser: "DAMAGE:2+STRENGTH*1"
    property string cardType: "Spell"
    property string useCardText: "You land a powerful roundhouse kick on the &ENEMY&, dealing &DAMAGE& damage."
    property int cardNumber: 2
    property bool selfCast: false

    width: 120
    height: 160
    border.width: 2
    border.color: card_container != undefined ? card_container.selected ? "yellow" : "black" : "black"
    color: card_container != undefined ? card_container.cardColor : "$ffffff"

    // if card container is destroyed then destroy this as well
    onChildrenChanged: {
        kick.destroy();
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
