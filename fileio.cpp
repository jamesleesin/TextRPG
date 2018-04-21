#include "fileio.h"
#include <QDebug>

FileIO::FileIO()
{

}

bool FileIO::saveGame(QVariantList data){
    qDebug()<<"save game";

    QFile file(saveUrl);
    if (file.open(QIODevice::ReadWrite)){
        QTextStream out(&file);
        for (int i = 0; i < data.length(); i++){
            qDebug()<<data[i];
            out << data[i].toString()<<"\n";
        }
        file.close();
        return true;
    }
    return false;
}

QVariantList FileIO::loadGame(){
    QVariantList data;
    QFile file(saveUrl);
    if(file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);
        while(!in.atEnd()) {
            QString line = in.readLine();
            data.append(line);
        }
        file.close();
    }

    return data;
}
