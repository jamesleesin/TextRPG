import QtQuick 2.0

Item {
    id: questContainer
    property string name: ""
    property string displayName: ""
    property string shortDescription: ""
    property string fullDescription: ""
    property string reward: ""

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked:{

        }
        onEntered:{
        }
        onExited: {
        }
    }

    Column{
        id: desc
        anchors.fill: parent
        spacing: 5
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 5

        Text{
            id: questName
            text: displayName
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            width: parent.width-10
            font.bold: true
        }
        Text{
            id: questDescription
            text: shortDescription
            font.pointSize: root.tinyFontSize
            font.family: root.textFont
            color: root.textColor
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            width: parent.width-10
        }
    }

}
