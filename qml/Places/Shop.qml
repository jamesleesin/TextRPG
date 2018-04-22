import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

Item {
    id: shop
    anchors.fill: parent
    property string name: ""
    property variant itemsForSale:[]
    property variant resourcePrices:[]
    property variant resourceNames: ["Metal", "Fur", "Medicinal Herb", "Arrow", "Magic Crystal"]
    property variant iconNames: ["Metal", "Fur", "Herb", "Arrow", "Crystal"]

    signal exitedShop()


    Component{
        id: resource_row

        Row{
            id: resourceRow
            height: icon.height
            spacing: 10
            property string resourceName: ""
            property int resourceNum: -1

            Image{
                id: icon
                source: resourceName != "" ? "../Icons/" + resourceRow.resourceName + ".png" : ""
                width: 40
                height: 40
            }
            Text{
                text: resourceNames[resourceNum] + ": " + resourcePrices[resourceNum] + "g ea."
                font.pointSize: root.tinyFontSize
                font.family: root.textFont
                color: root.textColor
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }
            Rectangle{
                id: buyButton
                width: buyButtonText.width+10
                height: buyButtonText.height+8
                color: "white"
                border.width: 1
                border.color: "black"

                Text{
                    id: buyButtonText
                    text: "Buy"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        exitedShop();
                    }
                    onEntered: {
                        parent.color = "lightgrey";
                    }
                    onExited: {
                        parent.color = "white";
                    }
                }
            }
            Rectangle{
                id: sellButton
                width: sellButtonText.width+10
                height: sellButtonText.height+8
                color: "white"
                border.width: 1
                border.color: "black"

                Text{
                    id: sellButtonText
                    text: "Sell"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        exitedShop();
                    }
                    onEntered: {
                        parent.color = "lightgrey";
                    }
                    onExited: {
                        parent.color = "white";
                    }
                }
            }
        }
    }

    // inventory management
    Rectangle{
        id: shop_interface
        anchors.fill: parent
        border.width: 2
        border.color: "black"

        Text{
            id: shop_name
            text: name
            font.pointSize: root.mediumFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        Rectangle{
            id: divider_1
            anchors.horizontalCenter: shop_name.horizontalCenter
            anchors.top: shop_name.bottom
            anchors.topMargin: 10
            height: 2
            border.width: 2
            border.color: "black"
            width: 350
        }

        Rectangle{
            id: resource_container
            anchors.horizontalCenter: shop_name.horizontalCenter
            anchors.top: divider_1.bottom
            height: 300
            width: 500
            color: "white"

            Column{
                id: resource_list
                anchors.fill: parent
                spacing: 10
                anchors.leftMargin: 10
                anchors.rightMargin: 5
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            id: divider_2
            anchors.horizontalCenter: shop_name.horizontalCenter
            anchors.top: resource_container.bottom
            anchors.topMargin: 10
            height: 2
            border.width: 2
            border.color: "black"
            width: 350
        }
        Rectangle{
            id: shop_container
            anchors.top: divider_2.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: shop_name.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.margins: 10
            width: shop_inventory.width
            color: "white"

            // the card list for both the inventory and the deck (if on hand picking)
            GridLayout{
                id: shop_inventory
                width: shop_inventory.children.length * 150
                columns: 3
                columnSpacing: 20
                rowSpacing: 30
            }
        }
    }

    Rectangle{
        id: backButton
        width: backButtonText.width+10
        height: backButtonText.height+8
        color: "white"
        border.width: 1
        border.color: "black"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20

        Text{
            id: backButtonText
            text: "Stop browsing"
            font.pointSize: root.smallFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.centerIn: parent
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onClicked:{
                exitedShop();
            }
            onEntered: {
                parent.color = "lightgrey";
            }
            onExited: {
                parent.color = "white";
            }
        }
    }

    Component.onCompleted: {
        for (var r = 0; r < iconNames.length; r++){
            var res = resource_row.createObject(resource_list);
            res.resourceName = iconNames[r];
            res.resourceNum = r;
        }
    }

    Connections{
        target: place
        onEnteredShop:{
            for (var card = 0; card < shop_inventory.children.length; card++){
                shop_inventory.children[card].destroy();
            }
            // load in all the cards the player owns
            var inventoryArray = itemsForSale;
            for (var i = 0; i < inventoryArray.length; i++){
                var itemString = "qrc:/qml/Cards/" + inventoryArray[i] + ".qml";
                // create new card and load it into hand
                var item = Qt.createComponent(itemString);
                var newItem = item.createObject(shop_inventory);
            }
        }
    }
}
