import QtQuick 2.0
import "../"

Rectangle {
    id: copperHelmet
    property string name: "CopperHelmet"
    property string displayName: "Copper Helmet"
    property string cardClass: "Neutral"
    property string condition: "None"
    property int power: 1
    property string cost: ""
    property string effect: "While this card is in your hand, get +1 maximum HP."
    property string effectForParser: "MAXHP:1"
    property string cardType: "Equipment"
    property string useCardText: "You take off the helmet and put it back in your inventory."
    property int cardNumber: 20
    property bool selfCast: true

    property string equipmentSlot: "Head"

    width: 120
    height: 160
    radius: 8
    border.width: 3

    // if card container is destroyed then destroy this as well
    onChildrenChanged: {
        copperHelmet.destroy();
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
        equipmentSlot: parent.equipmentSlot
        anchors.fill: parent
    }
}

