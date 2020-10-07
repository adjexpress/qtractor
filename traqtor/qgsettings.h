#ifndef QGSETTINGS_H
#define QGSETTINGS_H

#include <QVariant>
#include <QFile>
#include <QDir>
#undef signals
#include <gio/gio.h>


class QGSettings : public QObject{
    Q_OBJECT
    Q_PROPERTY(bool acceptConnection READ acceptConnection WRITE setAcceptConnection NOTIFY acceptConnectionChanged)
    Q_PROPERTY(QString exitNode READ exitNode WRITE setExitNode NOTIFY exitNodeChanged)
    Q_PROPERTY(int dnsPort READ dnsPort WRITE setDnsPort NOTIFY dnsPortChanged)
    Q_PROPERTY(int socksPort READ socksPort WRITE setSocksPort NOTIFY socksPortChanged)
    Q_PROPERTY(int httpPort READ httpPort WRITE setHttpPort NOTIFY httpPortChanged)
    Q_PROPERTY(bool useBridges READ useBridges WRITE setUseBridges NOTIFY useBridgesChanged)
    Q_PROPERTY(QString bridges READ bridges WRITE setBridges NOTIFY bridgesChanged)
    Q_PROPERTY(bool eProxy READ eProxy NOTIFY eProxyChanged)

public:
    QGSettings(QByteArray);

    void settingNew(QByteArray schema_id);

    bool acceptConnection() { return getBoolValue("accept-connection"); }
    QString exitNode() { return getStringValue("exit-node"); }
    int dnsPort() { return getIntValue("dns-port"); }
    int socksPort() { return getIntValue("socks-port"); }
    int httpPort() { return getIntValue("http-port"); }
    bool useBridges() { return getBoolValue("use-bridges"); }
    QString bridges() { return _bridges; }
    bool eProxy();

    void setAcceptConnection(bool);
    void setExitNode(QString);
    void setDnsPort(int);
    void setSocksPort(int);
    void setHttpPort(int);
    void setUseBridges(bool);
    void setBridges(QString);
    Q_INVOKABLE void toggleEProxy();

    bool setStringValue(QString key, QString value);
    bool setBoolValue(QString key, bool value);
    bool setIntValue(QString key, int value);

    QString getStringValue(QString key);
    bool getBoolValue(QString key);
    int getIntValue(QString key);

Q_SIGNALS:
    void acceptConnectionChanged();
    void exitNodeChanged();
    void dnsPortChanged();
    void socksPortChanged();
    void httpPortChanged();
    void useBridgesChanged();
    void eProxyChanged();
    void bridgesChanged();

private:
    GSettings* _gSettingInstance;
    GSettings* _sproxy;  // system proxy
    GSettings* _ssocks;  // system socks
    QString _bridges;

    QFile _bridgesFile;

};

#endif // QGSETTINGS_H
