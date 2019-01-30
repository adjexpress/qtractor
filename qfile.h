#include <QFile>
#include <QDir>
#include <iostream>


class QmlFile : public QFile {
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(bool homeDir READ homeDir WRITE setHomeDir)
//    Q_PROPERTY(QString nameFromHome READ nameFromHome WRITE setNameFromHome)

public:
    QmlFile() : QFile() {

    }

    /*Q_INVOKABLE bool open(QString mode) {
        QFile::setFileName(_name);
        if (mode == "NotOpen")
            return QFile::open(QIODevice::NotOpen);
        else if (mode == "ReadOnly")
            return QFile::open(QIODevice::ReadOnly | QIODevice::Text);
        else if (mode == "WriteOnly")
            return QFile::open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text);
        else if (mode == "ReadWrite")
            return QFile::open(QIODevice::ReadWrite | QIODevice::Truncate | QIODevice::Text);
        else if (mode == "Append")
            return QFile::open(QIODevice::Append | QIODevice::Truncate | QIODevice::Text);
        else if (mode == "Truncate")
            return QFile::open(QIODevice::Truncate | QIODevice::Text);
        else if (mode == "Text")
            return QFile::open(QIODevice::Text | QIODevice::Text);
        else if (mode == "Unbuffered")
            return QFile::open(QIODevice::Unbuffered | QIODevice::Text);
        else if (mode == "NewOnly")
            return QFile::open(QIODevice::NewOnly | QIODevice::Text);
        else if (mode == "ExistingOnly")
            return QFile::open(QIODevice::ExistingOnly | QIODevice::Text);
        else
            return false;
    }*/

    Q_INVOKABLE qint64 write(QString str) {
        if (_homeDir == true)
            QFile::setFileName(QDir::homePath() + "/" + _name);
        else
            QFile::setFileName(_name);
        QFile::open(QIODevice::WriteOnly | QIODevice::Text);
        QByteArray ba = str.toLocal8Bit();
        qint64 qi = QFile::write(ba);
        QFile::close();
        return qi;
    }


    Q_INVOKABLE QByteArray readAll() {
        if (_homeDir == true)
            QFile::setFileName(QDir::homePath() + "/" + _name);
        else
            QFile::setFileName(_name);
//        char *ch = new char ();
        QFile::open(QIODevice::ReadOnly | QIODevice::Text);
//        std::cerr << QFile::read(ch, 1000) << std::endl;
//        std::cerr << ch[0];
        QByteArray ba = QFile::readAll();
        QFile::close();
        return ba;
    }

    Q_INVOKABLE QString fileName() {
//        QFile::setFileName(_name);
        return QFile::fileName();
    }

    /*Q_INVOKABLE void close() {
        QFile::close();
    }*/

    QString name() const {
        return _name;
    }

    void setName(const QString &str) {
        if (_name != str) {  // guard
            _name = str;
        }
    }

    bool homeDir() const {
        return _homeDir;
    }

    void setHomeDir(const bool &b) {
        if (_homeDir != b) {  // guard
            _homeDir = b;
        }
    }

private:
    QString _name;
    bool _homeDir;
};
