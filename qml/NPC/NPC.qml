import QtQuick 2.0

Item {
    id: npc
    property string name: ""
    property string greeting: ""
    property string doneQuestText: ""
    property string questOffered: ""

    Column{
        id: npc_text_container
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 5
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 15

        Text{
            id: npc_name
            text: name
            font.pointSize: root.mediumFontSize
            font.family: root.textFont
            color: root.textColor
            width: npc_text_container.width-60
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.bold: true
        }
        Text{
            id: npc_text
            text: greeting
            font.pointSize: root.smallFontSize
            font.family: root.textFont
            color: root.textColor
            anchors.left: parent.left
            anchors.leftMargin: 20
            width: npc_text_container.width-60
            wrapMode: Text.WordWrap
        }
    }
}
