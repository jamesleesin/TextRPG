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
            width: 800
            property string resourceName: ""
            property int resourceNum: -1

            TextField{
                id: buyAmt
                text: ""
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                width: 100
                placeholderText: "Amount"
                validator: IntValidator {bottom: 0; top: 1000;}
            }
            Rectangle{
                id: buyButton
                width: buyButtonText.width+10
                height: buyButtonText.height+8
                color: player.gold - (buyAmt.text * resourcePrices[resourceNum]) >= 0 ? "white" : "grey"
                border.width: 1
                border.color: "black"

                Text{
                    id: buyButtonText
                    text: "Buy (" + buyAmt.text * resourcePrices[resourceNum] + "g)"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        if (player.gold - (buyAmt.text * resourcePrices[resourceNum]) >= 0){
                            player.gold -= (buyAmt.text * resourcePrices[resourceNum]);
                            var res = [];
                            for (var i = 0; i < player.playerResourceCount.length; i++){
                                if (i === resourceRow.resourceNum){ res.push(player.playerResourceCount[i] + Number(buyAmt.text)); }
                                else { res.push(player.playerResourceCount[i]); }
                            }
                            player.playerResourceCount = res;
                        }
                    }
                    onEntered: {
                        parent.color = player.gold - (buyAmt.text * resourcePrices[resourceNum]) >= 0 ? "lightgrey" : "grey";
                    }
                    onExited: {
                        parent.color = player.gold - (buyAmt.text * resourcePrices[resourceNum]) >= 0 ? "white" : "grey";
                    }
                }
            }
            Rectangle{
                color: "transparent"
                height: 40
                width: (resourceRow.width - icon.width- amt.width - buyButton.width - buyAmt.width - sellButton.width - sellAmt.width - resourceRow.spacing*7)/2
            }
            Image{
                id: icon
                source: resourceName != "" ? "../Icons/" + resourceRow.resourceName + ".png" : ""
                width: 40
                height: 40
            }
            Text{
                id: amt
                text: resourceNames[resourceNum] + ": " + resourcePrices[resourceNum] + "g buy/" + Math.floor(resourcePrices[resourceNum]/2) + "g sell."
                font.pointSize: root.tinyFontSize
                font.family: root.textFont
                color: root.textColor
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }
            Rectangle{
                color: "transparent"
                height: 40
                width: (resourceRow.width - icon.width- amt.width - buyButton.width - buyAmt.width - sellButton.width - sellAmt.width - resourceRow.spacing*7)/2
            }

            TextField{
                id:sellAmt
                text: ""
                font.pointSize: root.smallFontSize
                font.family: root.textFont
                width: 100
                placeholderText: "Amount"
                validator: IntValidator {bottom: 0; top: 1000;}
            }
            Rectangle{
                id: sellButton
                width: sellButtonText.width+10
                height: sellButtonText.height+8
                color: player.playerResourceCount[resourceRow.resourceNum] - sellAmt.text >= 0 ? "white" : "grey"
                border.width: 1
                border.color: "black"

                Text{
                    id: sellButtonText
                    text: "Sell (" + sellAmt.text * Math.floor(resourcePrices[resourceNum]/2) + "g)"
                    font.pointSize: root.smallFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        if (player.playerResourceCount[resourceRow.resourceNum] - sellAmt.text >= 0){
                            player.gold += sellAmt.text * Math.floor(resourcePrices[resourceNum]/2);
                            var res = [];
                            for (var i = 0; i < player.playerResourceCount.length; i++){
                                if (i === resourceRow.resourceNum){ res.push(player.playerResourceCount[i] - Number(sellAmt.text)); }
                                else { res.push(player.playerResourceCount[i]); }
                            }
                            player.playerResourceCount = res;
                        }
                    }
                    onEntered: {
                        parent.color = player.playerResourceCount[resourceRow.resourceNum] - sellAmt.text >= 0 ? "lightgrey" : "grey"
                    }
                    onExited: {
                        parent.color = player.playerResourceCount[resourceRow.resourceNum] - sellAmt.text >= 0 ? "white" : "grey"
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
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                spacing: 10
                anchors.leftMargin: 10
                anchors.rightMargin: 5
                anchors.topMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle{
            id: divider_2
            anchors.horizontalCenter: shop_name.horizontalCenter
            anchors.top: resource_container.bottom
            anchors.topMargin: 50
            height: 2
            border.width: 2
            border.color: "black"
            width: 350
        }

        Rectangle{
            id: resources_interface
            anchors.horizontalCenter: shop_name.horizontalCenter
            anchors.top: divider_2.bottom
            width: 700

            Column{
                anchors.fill: parent
                spacing: 10
                anchors.leftMargin: 10
                anchors.rightMargin: 5
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Text{
                    id: resource_label
                    text: "You have:"
                    font.pointSize: root.mediumFontSize
                    font.family: root.textFont
                    color: root.textColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                }
                Row{
                    height: icon_metal.height
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image{
                        id: icon_metal
                        source: "../Icons/Metal.png"
                        width: 40
                        height: 40
                    }
                    Text{
                        text: resources_interface.visible ? player.playerResourceNames[0] + ": " +  player.playerResourceCount[0] : ""
                        font.pointSize: root.tinyFontSize
                        font.family: root.textFont
                        color: root.textColor
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                    }
                }
                Row{
                    height: icon_fur.height
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image{
                        id: icon_fur
                        source: "../Icons/Fur.png"
                        width: 40
                        height: 40
                    }
                    Text{
                        text: resources_interface.visible ? player.playerResourceNames[1] + ": " +  player.playerResourceCount[1] : ""
                        font.pointSize: root.tinyFontSize
                        font.family: root.textFont
                        color: root.textColor
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                    }
                }
                Row{
                    height: icon_herb.height
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image{
                        id: icon_herb
                        source: "../Icons/Herb.png"
                        width: 40
                        height: 40
                    }
                    Text{
                        text: player.playerResourceNames[2] + ": " +  player.playerResourceCount[2]
                        font.pointSize: root.tinyFontSize
                        font.family: root.textFont
                        color: root.textColor
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                    }
                }
                Row{
                    height: icon_arrow.height
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image{
                        id: icon_arrow
                        source: "../Icons/Arrow.png"
                        width: 40
                        height: 40
                    }
                    Text{
                        text: resources_interface.visible ? player.playerResourceNames[3] + ": " +  player.playerResourceCount[3] :""
                        font.pointSize: root.tinyFontSize
                        font.family: root.textFont
                        color: root.textColor
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                    }
                }
                Row{
                    height: icon_crystal.height
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image{
                        id: icon_crystal
                        source: "../Icons/Crystal.png"
                        width: 40
                        height: 40
                    }
                    Text{
                        text: resources_interface.visible ? player.playerResourceNames[4] + ": " +  player.playerResourceCount[4] :""
                        font.pointSize: root.tinyFontSize
                        font.family: root.textFont
                        color: root.textColor
                        verticalAlignment: Text.AlignVCenter
                        height: parent.height
                    }
                }
            }
        }

        /*
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
        }*/
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

    /*
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
    }*/
}
