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
    border.color: "black"

    // if card container is destroyed then destroy this as well
    onChildrenChanged: {
        lesserHealingPotion.destroy();
    }

    // call this when card is drawn
    function fadeIn(){
        fade_in_animation.start();
    }
    NumberAnimation on opacity {
        id: fade_in_animation
        loops: 1
        from: 0; to: 1
        duration: 800
        running: false
        onStopped: {
            if (burnThis){
                burnCard();
            }
        }
    }

    property bool burnThis: false
    // call this to discard/burn the cardClass:
    function burnCard(){
        burn_animation.start();
        card_container.burnCardAnimation();
    }
    NumberAnimation on opacity {
        id: burn_animation
        loops: 1
        from: 1; to: 0
        duration: 800
        running: false
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
