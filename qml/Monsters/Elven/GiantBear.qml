import QtQuick 2.0
import "../"

Rectangle{
    id: giantBear
    ////////////// BEGIN EDITABLE STATS ////////////
    property string name: "Great Bear, Hamma"
    property int level: 3

    // stats
    property int strength: 3
    property int dexterity: 1
    property int spellpower: 0
    property int resilience: 2
    property int luck: 0

    // resources
    property int maxHp: 10
    property int maxMp:1
    property int maxSp: 2

    // drops
    property string goldDrops: "10-14"
    property string resourceDrops: ""
    property string lootDrops:"1-Elven/NaimersBow"

    // combat
    property string basicAttack: "DAMAGE:1-2:The bear grazes you with a quick swipe, dealing &DAMAGE& damage."
    property variant specialAttackArray: ["0.25~DAMAGE:2-4:The giant bear charges at you! You fail to step back in time, and are slammed into the wall for &DAMAGE& damage."]
    // miss attack string is: misschance:misstext
    property string missAttack: "0.1~MISS:The giant bear charges at you! You quickly dodge out of the way."

    // just change this to match the id
    onChildrenChanged: {
        giantBear.destroy();
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
