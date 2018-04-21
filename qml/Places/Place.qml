import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2

Item {
    id: place
    anchors.fill: parent
    property string name: ""
    property string introText:""
    property string worldLocation:""

    // exploration
    property bool canExplore: false
    property double combatChance: 0
    property variant possibleCombats:[]
    property int zoneDifficulty: -1

    // store locations you can get to from here
    property variant links:[]
    // alternate texts that are shown if specified
    property variant linkAltText:[]
    // combat victory link, combat defeat link
    property string combatOutcomeLocation: ""
    property variant combatOutcomeLinks:[]

    property string requireTextEntry: ""

    property bool setCallback: false
    signal placeCallback(string variable)

    // dungeon
    property bool isDungeon: false
    signal enteredDungeon()

    // shop
    property bool isShop: false
    signal enteredShop()

    Component{
        id: place_button

        Button{
            id: button
            property string buttonText: ""
            property string linkTo: ""
            text: buttonText
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: (place_buttons.width - (parent.height/16)*(place_buttons.children.length))/place_buttons.children.length
            style: ButtonStyle {
                label: Text {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family:  root.textFont
                    font.pointSize: root.mediumFontSize
                    text: control.text
                }
            }

            onClicked: {
                if (buttonText === "Fight!"){
                    root.enterCombat(linkTo);
                }
                else{
                    if (setCallback){
                        placeCallback(buttonText);
                    }
                    root.changeLocation(linkTo);
                }
            }
        }
    }

    Component{
        id: explore_button

        Button{
            id: exploreButton
            text: "Explore"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: (place_buttons.width - (parent.height/16)*(place_buttons.children.length))/place_buttons.children.length
            style: ButtonStyle {
                label: Text {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family:  root.textFont
                    font.pointSize: root.mediumFontSize
                    text: control.text
                }
            }
            onClicked: {
                // roll for combat
                if (Math.random() < combatChance){
                    // roll for possible combats
                    var roll = Math.random();
                    var currentChance = 0;
                    for (var i = 0; i < possibleCombats.length; i++){
                        var chance = possibleCombats[i].split("-")[0];
                        var monster = possibleCombats[i].split("-")[1];
                        var txt = possibleCombats[i].split("-")[2];
                        currentChance += chance;
                        if (roll < currentChance){
                            introText += txt;
                            // clear button options
                            for (var b = 0; b < place_buttons.children.length; b++){
                                place_buttons.children[b].destroy();
                            }
                            // make a new button for fight
                            var fightButton = place_button.createObject(place_buttons);
                            fightButton.buttonText = "Fight!";
                            fightButton.linkTo = monster;
                        }
                    }

                }
                else{
                    introText += "You wander around for a short while, but don't find anything interesting.\n\n";
                }
            }
        }
    }

    Component{
        id: enter_dungeon_button

        Button{
            id: dungeonButton
            text: "Enter Dungeon"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: (place_buttons.width - (parent.height/16)*(place_buttons.children.length))/place_buttons.children.length
            style: ButtonStyle {
                label: Text {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family:  root.textFont
                    font.pointSize: root.mediumFontSize
                    text: control.text
                }
            }
            onClicked: {
                enteredDungeon();
            }
        }
    }

    Component{
        id: shop_button

        Button{
            id: shopButton
            text: "Browse Shop"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: (place_buttons.width - (parent.height/16)*(place_buttons.children.length))/place_buttons.children.length
            style: ButtonStyle {
                label: Text {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family:  root.textFont
                    font.pointSize: root.mediumFontSize
                    text: control.text
                }
            }
            onClicked: {
                enteredShop();
            }
        }
    }

    Component{
        id: text_entry

        // Text entry
        TextField{
            id: textEntry
            anchors.centerIn: place_buttons
            placeholderText: ""
            width: 300
            visible: placeholderText == "" ? false : true

            Button{
                id: submit
                anchors.right: parent.right
                text: "OK"
                onClicked:{
                    if (textEntry.placeholderText == "Enter Name"){
                        player.name = textEntry.text;
                        if (player.name === ""){ player.name = "Unnamed"; }
                        placeCallback("");
                    }
                }
            }
        }
    }

    // go to different areas depending on combat victory or defeat
    function victory(){
        root.setLocation(combatOutcomeLocation);
        root.changeLocation(combatOutcomeLinks[0]);
    }
    function defeat(){
        root.setLocation(combatOutcomeLocation);
        root.changeLocation(combatOutcomeLinks[1]);
    }

    function difficultyComparison(){
        if (zoneDifficulty == -1){
            return "#ffffff";
        }
        var difference = root.getPlayerPower() - zoneDifficulty;
        if (difference > 5){
            if (difference > 20){ return "#4444ff44"; }
            else { return "#44aaffaa"; }
        }
        else if (difference < -5){
            if (difference < -20){ return "#44ff4444"; }
            else { return "#44ffaaaa"; }
        }
        else{
            return "#44D8C19D";
        }
    }

    Rectangle{
        anchors.fill: parent
        border.width: 2
        border.color: "black"

        Rectangle{
            id: place_text
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: place_options.top
            border.width: 2
            border.color: "black"
            // gradient reflecting difficulty of the zone
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: difficultyComparison() }
            }

            ScrollView{
                anchors.fill: parent

                Column{
                    width: place_text.width-30
                    spacing: 15
                    anchors.top: parent.top
                    anchors.topMargin: 15

                    Text{
                        id: place_name
                        text: name
                        font.pointSize: root.mediumFontSize
                        font.family: root.textFont
                        color: root.textColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: place_text.width-30
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        font.bold: true
                        visible: name == "" ? false : true
                    }
                    Text{
                        id: intro_text
                        text: introText
                        font.pointSize: root.smallFontSize
                        font.family: root.textFont
                        color: root.textColor
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        width: place_text.width-60
                        wrapMode: Text.WordWrap
                    }
                    Rectangle{
                        color: "transparent"
                        width: 10
                        height: 50
                    }
                }
            }
        }
        Rectangle{
            id: place_options
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 200
            border.width: 2
            border.color: "black"

            // Button options
            GridLayout{
                id: place_buttons
                anchors.fill: parent
                anchors.margins: 20
                rows: 3
                columns: 4
                columnSpacing: parent.height/16
                //anchors.topMargin: parent.height/16
                visible: place_buttons.children.length > 0 ? true : false
            }
        }
    }

    Component.onCompleted: {
        root.setLocation(worldLocation);
        if (requireTextEntry !== ""){
            var newTextEntry = text_entry.createObject(place_options);
            newTextEntry.placeholderText = requireTextEntry;
        }
        else{
            // add explore button
            if (canExplore){
                var expBut = explore_button.createObject(place_buttons);
            }
            if (isDungeon){
                var dunBut = enter_dungeon_button.createObject(place_buttons);
            }
            if (isShop){
                var shopBut = shop_button.createObject(place_buttons);
            }

            for (var i = 0; i < links.length; i++){
                var newLink = place_button.createObject(place_buttons);
                if (linkAltText.length > 0){
                    newLink.buttonText = linkAltText[i];
                }
                else{
                    newLink.buttonText = links[i];
                }
                newLink.linkTo = links[i];
            }
        }
    }
}
