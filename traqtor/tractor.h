#ifndef TRACTOR_H
#define TRACTOR_H

#include <QObject>
#include <QProcess>

#include "qgsettings.h"


class Tractor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)
    Q_PROPERTY(bool runningTested READ runningTested NOTIFY runningTestDone)
    Q_PROPERTY(QGSettings* settings READ settings CONSTANT)

public:
    Tractor();

    enum Status {
        STOPED, CONNECTING, CONNECTED
    }; Q_ENUM(Status)

    enum CmdArgs {
        START, STOP, TEST_RUNNING, TEST_CONNECTION
    };

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void restart();
    Q_INVOKABLE void testConnection();
    void testRunning();

    Status status() { return _status; }
    QString statusMessage() { return _statusMessage; }
    int progress() { return _progress; }
    bool connectionTested() { return _connectionTested; }
    bool runningTested() { return _runningTested; }
    QGSettings* settings() { return _dconf; }

    void setStatus(Status s);
    void setProgress(int p);
    void setStatusMessage(QString s);

Q_SIGNALS:
    void statusChanged(Status status);
    void statusMessageChanged();
    void progressChanged();
    void runningTestDone();

public slots:
    void handleFinish(int exitCode, QProcess::ExitStatus extStatus);
    void handleOutput();

private:
    QProcess *_proc;
    Status _status;
    QString _statusMessage;
    int _progress;
    bool _connectionTested;
    bool _runningTested;
    bool _restart;
    QGSettings *_dconf;

    const QList<QStringList> _args = {
        {"start"},
        {"stop"},
        {"isrunning"},
        {"isconnected"}
    };
};

#endif // TRACTOR_H
