#-------------------------------------------------
#
# Project created by QtCreator 2018-04-05T18:40:20
#
#-------------------------------------------------

QT       += gui qml quick widgets core

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = TextRPG
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


SOURCES += \
        main.cpp \
    qtquick2applicationviewer/qtquick2applicationviewer.cpp \
    fileio.cpp

HEADERS += \
    qtquick2applicationviewer/qtquick2applicationviewer.h \
    fileio.h

DISTFILES += \
    qml/interface.qml \
    qml/Player.qml \
    qml/ProgressingText.qml \
    qml/Monsters/Goblin.qml \
    qml/Monsters/Global/Goblin.qml \
    qml/Punch.qml \
    qml/Cards/Neutral/Punch.qml \
    qml/CardContainer.qml \
    qml/Cards/CardContainer.qml \
    qml/Monsters/MonsterContainer.qml \
    qml/Cards/Neutral/Kick.qml \
    qml/Cards/Neutral/Block.qml \
    qml/Cards/Neutral/LesserHealingPotion.qml \
    qml/PlayerProgress.qml \
    qtquick2applicationviewer/qtquick2applicationviewer.pri \
    qml/Eleren.qml \
    qml/Places/Elven/Eleren.qml \
    qml/Places/Place.qml \
    qml/Places/Elven/TheCrossedArrows.qml \
    qml/Places/GameIntro.qml \
    qml/Places/NameSelection.qml \
    qml/Places/TutorialCombat.qml \
    qml/Places/Elven/TheFangHills.qml \
    qml/Places/Elven/TheDuskJungle.qml \
    qml/Places/Global/GameIntro.qml \
    qml/Places/Global/NameSelection.qml \
    qml/Places/Global/Place.qml \
    qml/Places/Global/TutorialCombat.qml \
    qml/Places/Place.qml \
    qml/Monsters/Elven/Wolf.qml \
    qml/Icons/Inventory.png \
    qml/Icons/Quests.png \
    qml/Icons/Settings.png \
    qml/Places/Dungeon.qml \
    qml/Monsters/Elven/GiantBear.qml \
    qml/Places/Elven/NaturesVault.qml \
    qml/Places/Shop.qml \
    qml/Icons/Arrow.png \
    qml/Icons/Crystal.png \
    qml/Icons/Herb.png \
    qml/Cards/Neutral/Focus.qml \
    qml/Places/Elven/NPC.qml \
    qml/NPC/NPC.qml \
    qml/NPC/Alva.qml \
    qml/NPC/Elven/Alva.qml \
    qml/Quests/QuestContainer.qml \
    qml/Quests/Elven/HerbCollecting.qml \
    qml/Cards/Elven/NaimersBow.qml \
    qml/Cards/Neutral/Think.qml \
    qml/Cards/Neutral/CopperHelmet.qml \
    qml/Quests/Elven/NaimersLostBow.qml \
    qml/NPC/Elven/Naimer.qml \
    qml/Quests/Elven/WolfHunter.qml

RESOURCES += \
    resources.qrc
