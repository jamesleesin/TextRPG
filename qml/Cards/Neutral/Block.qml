import QtQuick 2.0
import "../"

Rectangle {
    id: block
    property string name: "Block"
    property string displayName: "Block"
    property string cardClass: "Neutral"
    property string condition: "None"
    property int power: 1
    property string cost: "Energy - 0"
    property string effect: "Reduce the next source of damage by 1(+Resilience)."
    property string effectForParser: "REDUCE:1+RESILIENCECE*1"
    property string cardType: "Spell"
    property string useCardText: "You enter a defensive stance."
    property int cardNumber: 3
    property bool selfCast: true

    width: 120
    height: 160
    radius: 8
    border.width: 3
    border.color: card_container != undefined ? card_container.selected ? "yellow" : "black" : "black"
    color: card_container != undefined ? card_container.cardColor : "#ffffff"

    // if card container is destroyed then destroy this as well
    onChildrenChanged: {
        block.destroy();
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
