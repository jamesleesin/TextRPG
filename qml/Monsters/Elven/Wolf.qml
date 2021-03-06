import QtQuick 2.0
import "../"

Rectangle{
    id: wolf
    ////////////// BEGIN EDITABLE STATS ////////////
    property string name: "Wolf"
    property int level: 1

    // stats
    property int strength: 1
    property int dexterity: 1
    property int spellpower: 0
    property int resilience: 1
    property int luck: 0

    // resources
    property int maxHp: 4
    property int maxMp:1
    property int maxSp: 1

    // drops
    property string goldDrops: "2-3"
    property string resourceDrops: "1:2:Metal, 1:1:Medicinal Herb"
    property string lootDrops:""

    // combat
    property string basicAttack: "DAMAGE:0-1:The &ENEMY& grazes you with a quick swipe, dealing &DAMAGE& damage."
    property variant specialAttackArray: ["0.2~DAMAGE:1-2:The &ENEMY& sinks its fangs into your leg, dealing &DAMAGE& damage."]
    // miss attack string is: misschance:misstext
    property string missAttack: "0.1~MISS:The &ENEMY& lunges at you, but you narrowly avoid its sharp fangs."

    // just change this to match the id
    onChildrenChanged: {
        wolf.destroy();
    }
    //////////// DONT CHANGE ANYTHING BELOW THIS ////////////

    property int hp: maxHp
    property int mp: maxMp
    property int sp: maxSp
    property string textColor: "black"
    property string textFont: "Sans Serif"
    property int tinyFontSize: 10

    property variant statusEffects:[]

    width: 200
    height: 100
    border.width: 2
    border.color: "#992222"
    color: monster_container != undefined ? monster_container.monsterColor : "#ffffff"

    NumberAnimation on x {
        id: shake_animation
        loops: 3
        from: x-10; to: x
        duration: 125
        onStopped: {
            if (monster_container.hp <= 0){
                root.monsterKilled(monster_container, monster_container.dropGold(), monster_container.dropLoot(), monster_container.dropResources(), monster_container.dropExperience());
                monster_container.destroy();
            }
        }
    }

    MonsterContainer{
        id: monster_container
        name: parent.name
        level: parent.level
        strength: parent.strength
        dexterity: parent.dexterity
        spellpower: parent.spellpower
        resilience: parent.resilience
        luck: parent.luck
        maxHp: parent.maxHp
        hp: parent.hp
        maxMp: parent.maxMp
        mp: parent.mp
        maxSp: parent.maxSp
        sp: parent.sp
        goldDrops: parent.goldDrops
        lootDrops: parent.lootDrops
        resourceDrops: parent.resourceDrops
        basicAttack: parent.basicAttack
        missAttack: parent.missAttack
        specialAttackArray: parent.specialAttackArray
        statusEffects: parent.statusEffects
        anchors.fill:parent
    }

    Connections{
        target: monster_container
        onShake:{
            shake_animation.start();
        }
    }
}
