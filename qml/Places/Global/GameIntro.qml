import QtQuick 2.0
import "../"

Item {
    id: gameintro
    anchors.fill: parent

    Place{
        id: place
        name: ""
        introText: "Welcome to TextRPG!\n\nCurrently, four races rule over the land. First, the Elves, known for their connection with the elements and the sprits. They are blessed with high spellpower and dexterity, but their physical bodies are not as sturdy as the other races. Second, the Dwarves, known for their crafting ability and sheer strength. They are endowed with high strength and resilience, which makes up for their lack of connection to the elements. Third, the craftiest race of them all - the Shades. These beings boast a high dexterity and luck stat, perfect for any sort of trickery one might undertake. However, they have a low strength and resilience stat, making them extremely susceptible to damage. Lastly, the Humans, the most balanced race; both a blessing and a curse.\n\nWhich of these four races would you like to start as?"
        links:["NameSelection", "NameSelection", "NameSelection", "NameSelection"]
        linkAltText: ["Elf", "Dwarf", "Shade", "Human"]
        setCallback: true
        worldLocation: "Global"
    }

    Connections{
        target: place
        onPlaceCallback:{
            root.updateValue("race", variable);
            root.updateValue("level", 1);
            switch(variable){
            case "Elf":
                root.updateValue("strength", 1);
                root.updateValue("dexterity", 1);
                root.updateValue("spellpower", 1);
                root.updateValue("resilience", 1);
                root.updateValue("luck", 1);
                root.updateValue("maxHp", 10);
                root.updateValue("hp", 10);
                root.updateValue("maxEnergy", 10);
                root.updateValue("energy", 10);
                root.updateValue("gold", 10);
                break;
            case "Dwarf":
                root.updateValue("strength", 1);
                root.updateValue("dexterity", 1);
                root.updateValue("spellpower", 1);
                root.updateValue("resilience", 1);
                root.updateValue("luck", 1);
                root.updateValue("maxHp", 1);
                root.updateValue("hp", 1);
                root.updateValue("maxEnergy", 10);
                root.updateValue("energy", 10);
                root.updateValue("gold", 10);
                break;
            case "Shade":
                root.updateValue("strength", 1);
                root.updateValue("dexterity", 1);
                root.updateValue("spellpower", 1);
                root.updateValue("resilience", 1);
                root.updateValue("luck", 1);
                root.updateValue("maxHp", 1);
                root.updateValue("hp", 1);
                root.updateValue("maxEnergy", 10);
                root.updateValue("energy", 10);
                root.updateValue("gold", 10);
                break;
            case "Human":
                root.updateValue("strength", 1);
                root.updateValue("dexterity", 1);
                root.updateValue("spellpower", 1);
                root.updateValue("resilience", 1);
                root.updateValue("luck", 1);
                root.updateValue("maxHp", 1);
                root.updateValue("hp", 1);
                root.updateValue("maxEnergy", 10);
                root.updateValue("energy", 10);
                root.updateValue("gold", 10);
                break;
            }
        }
    }
}
