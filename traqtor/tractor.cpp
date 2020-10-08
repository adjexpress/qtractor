#include <QDebug>
#include "tractor.h"

Tractor::Tractor() {
    _status = STOPED;
    _statusMessage = "";
    _progress = 0;
    _proc = new QProcess();
    _torIPProc = new QProcess();
    _torIP = "";
    _proc->setProgram("tractor");
    _runningTested = false;
    _restart = false;
    _dconf = new QGSettings("org.tractor");

    qRegisterMetaType<Status>("Status");
    connect(_proc, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), 
            this, &Tractor::handleFinish);
    connect(_proc, &QProcess::readyReadStandardOutput, this, &Tractor::handleOutput);
    connect(_torIPProc, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), 
            this, &Tractor::handleTorIP);
    testRunning();
}

void Tractor::start() {
    setStatus(CONNECTING);
    _proc->setArguments(_args[START]);
    _proc->start();
}

void Tractor::stop() {
    _proc->setArguments(_args[STOP]);
    _proc->start();
}

void Tractor::restart() {
    _restart = true;
    stop();
}

void Tractor::kill() {
    _proc->terminate();
    QProcess killtorP;
    killtorP.start("pkill", {"-x", "tor", "-e"});
    killtorP.waitForFinished();
    setStatusMessage(QString(killtorP.readAll()).trimmed());
    setProgress(0);
    setStatus(STOPED);
}

void Tractor::testConnection() {
    _proc->setArguments(_args[TEST_CONNECTION]);
    _proc->start();
}

void Tractor::testRunning() {
    _proc->setArguments(_args[TEST_RUNNING]);
    _proc->start();
}

void Tractor::calTorIP() {
    if (_status != CONNECTED)
        return;

    QString gateway;
    if (_dconf->acceptConnection())
        gateway = "0.0.0.0";
    else
        gateway = "127.0.0.1";

    int port = _dconf->socksPort();

    QString ip = gateway + ":" + QString::number(port);

    _torIPProc->start("curl", {"--socks5", ip, "http://checkip.amazonaws.com/"});
}

QString Tractor::geoIP() {
    if (_status != CONNECTED)
        return QString();

    QProcess p;
    p.start("geoiplookup", {_torIP});

    if (!p.waitForFinished())
        return QString();

    QString geo = p.readAll();
    geo = geo.right(geo.size() - 23).trimmed();

    return geo;
}

void Tractor::setStatus(Tractor::Status s) {
    if (_status == s)
        return;

    _status = s;
    emit statusChanged(s);
}

void Tractor::setProgress(int p) {
    if (_progress == p)
        return;

    _progress = p;
    emit progressChanged();
}

void Tractor::setStatusMessage(QString s) {
    if (_statusMessage == s)
        return;

    _statusMessage = s;
    emit statusMessageChanged();
}

void Tractor::handleFinish(int exitCode, QProcess::ExitStatus extStatus) {
    if (extStatus == QProcess::CrashExit)
        return;

    if (_proc->arguments() == _args[STOP]) {
        setProgress(0);
        setStatus(STOPED);
        _dconf->unsetProxy();

        if (_restart) {
            start();
            _restart = false;
        }
    }

    calTorIP();
}

void Tractor::handleOutput() {
    QString data = _proc->readAllStandardOutput();

    if (_proc->arguments() == _args[TEST_CONNECTION]) {  // isconnected output
        //TODO
    } else if (_proc->arguments() == _args[TEST_RUNNING]) {  // isrunning output
        if (data.contains("True")) {
            setStatus(CONNECTED);
            setProgress(100);
            setStatusMessage("Tractor is connected");
        } else if (data.contains("False")) {
            setStatus(STOPED);
            setProgress(0);
            setStatusMessage("Tractor is not connected");
        } else {
            qDebug() << "problem " << data;
        }

        if (!_runningTested) {
            _runningTested = true;
            emit runningTestDone();
        }
    } else if (_proc->arguments() == _args[START]) {    // start output
        if (data.contains("Tractor")) {
            if (data.contains("Starting")) {
                setStatusMessage("Starting Tractor");
            } else if (data.contains("conneted")) {
                setStatusMessage("Tractor is connected");
                setStatus(CONNECTED);
            }  else {
                setStatusMessage(data.mid(7, data.count() - 7));
            }

            if (data.contains("Reached timeout")) {
                setStatusMessage("Reached timeout");
                setProgress(0);
                setStatus(STOPED);
            }
        } else if (data.contains("Bootstrapped")) {
            setStatusMessage(data.mid(data.indexOf("Bootstrapped"), data.count() - 15));
            setProgress(data.mid(data.indexOf("Bootstrapped") + 13,
                                                     data.indexOf("%") - data.indexOf("Bootstrapped") - 13).toInt());
        } else {
            setStatusMessage(data.mid(5, data.count() - 12));
            if (data.contains("Reached timeout.")) {
                setProgress(0);
                setStatus(STOPED);
            }
        }
    } else if (_proc->arguments() == _args[STOP]) {  // stop output
        if (data.contains("Tractor"))
            setStatusMessage(data.mid(7, data.count() - 12));
        else
            setStatusMessage(data.mid(5, data.count() - 7));
    }
}

void Tractor::handleTorIP(int exitCode) {
    _torIP = _torIPProc->readAll();
    _torIP = _torIP.trimmed();
    emit torIPAvailable();
}

