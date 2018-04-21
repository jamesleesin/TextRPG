import QtQuick 2.0

Item {
    id: shop
    anchors.fill: parent
    property string name: ""
    property variant itemsForSale:[]

    // inventory management
    Rectangle{
        id: inventory_interface
        anchors.left: stats_panel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "white"
        border.width: 2
        border.color: "black"
        visible: root.inInventory || root.inHandPicking ? true : false

        Text{
            id: inventory_label
            text: root.inInventory ? "Inventory" : "Deck"
            font.pointSize: root.mediumFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        Rectangle{
            id: inventory_container
            anchors.top: inventory_label.bottom
            anchors.bottom: inventory_buttons.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            color: "white"

            ScrollView{
                anchors.fill: parent
                anchors.leftMargin: 20

                // the card list for both the inventory and the deck (if on hand picking)
                GridLayout{
                    id: card_list
                    width: card_list.children.length * 150 > inventory_container.width - 50 ? inventory_container.width - 50 : card_list.children.length * 150
                    columns: width/150
                    columnSpacing: 20
                    rowSpacing: 30
                }
            }
            Rectangle{
                id: inventory_tracker
                visible: false
            }
        }

        Rectangle{
            id: card_details
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            color: "white"
            border.width: 2
            border.color: "black"
            height: 200
            width: parent.width/3

            property string name: "None"
            property string cardType: ""
            property string cardClass: ""
            property string condition: ""
            property int power: 0
            property string cost: ""
            property string effect: ""
            property bool cardSelected: false

            Column{
                id: card_stats
                spacing: 5
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 20
                anchors.topMargin: 20
                visible: card_details.cardSelected ? true : false
                width: parent.width-20

                Text{
                    text: {
                        // add a space before capital letters
                        var newStr = card_details.name[0];
                        for (var i = 1; i < card_details.name.length; i++){
                            if (card_details.name.charAt(i) == card_details.name.charAt(i).toUpperCase()){ newStr += " " + card_details.name.charAt(i); }
                            else{ newStr += card_details.name.charAt(i); }
                        }
                        return newStr;
                    }
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    font.bold: true
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
                Text{
                    text: card_details.cardClass
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
                Text{
                    text: card_details.condition
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
                Text{
                    text: card_details.cost
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
                Text{
                    text: card_details.effect
                    font.pointSize: root.tinyFontSize
                    font.family: root.textFont
                    color: root.textColor
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
