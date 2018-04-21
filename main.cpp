#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <qtquick2applicationviewer/qtquick2applicationviewer.h>
#include <QQmlContext>
#include <fileio.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;

    FileIO fileio;
    viewer.rootContext()->setContextProperty("FileIO", (QObject*)&fileio);

    viewer.setSource(QUrl("qrc:/qml/interface.qml"));

    viewer.setTitle("Text RPG");
    viewer.setMinimumSize(QSize(1280,720));
    viewer.show();

    return app.exec();
}
