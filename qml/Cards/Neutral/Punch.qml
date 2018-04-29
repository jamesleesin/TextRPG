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
    border.color: "black"

    // if card container is destroyed then destroy this as well
    onChildrenChanged: {
        punch.destroy();
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
