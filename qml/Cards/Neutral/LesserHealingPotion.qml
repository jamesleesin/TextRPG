import QtQuick 2.0
import "../"

Rectangle {
    id: lesserHealingPotion
    property string name: "LesserHealingPotion"
    property string displayName: "Lesser Healing Potion"
    property string cardClass: "Neutral"
    property string condition: "None"
    property int power: 1
    property string cost: "Medicinal Herb - 1"
    property string effect: "Restore 5 hp."
    property string effectForParser: "HEAL:5"
    property string cardType: "Spell"
    property string useCardText: "You uncork the small potion and drink it, recovering 5 health."
    property int cardNumber: 5
    property bool selfCast: true

    width: 120
    height: 160
    radius: 8
    border.width: 3
    border.color: card_container != undefined ? card_container.selected ? "yellow" : "black" : "black"
    color: card_container != undefined ? card_container.cardColor : "$ffffff"

    // if card container is destroyed then destroy this as well
    onChildrenChanged: {
        lesserHealingPotion.destroy();
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
