#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QTextStream>

class FileIO: public QObject
{
    Q_OBJECT

public:
    FileIO();
    Q_INVOKABLE bool saveGame(QVariantList data);
    Q_INVOKABLE QVariantList loadGame();

private:
    QString saveUrl = "save1.sav";
};

#endif // FILEIO_H
