#include <QProcess>
#include <QVariant>

class Process : public QProcess {
    Q_OBJECT

public:
    Process(QObject *parent = 0) : QProcess(parent) { }
    //- - - - - start - - - - - -
    Q_INVOKABLE void start(const QString &program, const QVariantList &arguments) {
        QStringList args;

        // convert QVariantList from QML to QStringList for QProcess 

        for (int i = 0; i < arguments.length(); i++)
            args << arguments[i].toString();

        QProcess::start(program, args);
    }

    Q_INVOKABLE void start(const QString &program) {
        QProcess::start(program);
    }

     Q_INVOKABLE void start() {
        QProcess::start();
    }
    //, , , , , , , , , 

    Q_INVOKABLE void setProgram(const QString &program) {
        QProcess::setProgram(program);
    }

    Q_INVOKABLE void setArguments(const QStringList &arguments) {
        QProcess::setArguments(arguments);
    }

    Q_INVOKABLE qint64 write(const QByteArray &data) {
        return QProcess::write(data);
    }

    Q_INVOKABLE QByteArray readAll() {
        return QProcess::readAll();
    }

    Q_INVOKABLE QString readAllInString() {
        return QString::fromUtf8(QProcess::readAll()).toUtf8();
    }
};
