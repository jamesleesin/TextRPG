import QtQuick 2.0
import "../"

Item {
    id: eleren
    anchors.fill: parent

    Shop{
        id: shop
        name: "Nature's Vault"
        itemsForSale: ["Neutral/LesserHealingPotion", "Neutral/LesserHealingPotion"]
        resourcePrices: [4, 3, 1, 2, 3]
    }

    Place{
        id: place
        name: "Nature's Vault"
        introText: "A small bell rings as you walk inside the cozy cabin. The shopkeeper looks up and smiles warmly at you, beckoning you to browse her selection of goods.\n\n"
        links:["Eleren"]
        linkAltText: ["Outside to Eleren"]
        worldLocation: "Elven"
        isShop: true
    }

    Connections{
        target: place
        onEnteredShop:{
            place.visible = false;
            shop.visible = true;
        }
    }
    Connections{
        target: shop
        onExitedShop:{
            shop.visible = false;
            place.visible = true;
        }
    }
}
