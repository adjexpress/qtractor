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

public:
    QGSettings(QByteArray s_id);

    void settingNew(QByteArray schema_id) { _gSettingInstance = g_settings_new(schema_id.data()); }

    bool acceptConnection() { return getBoolValue("accept-connection"); }
    QString exitNode() { return getStringValue("exit-node"); }
    int dnsPort() { return getIntValue("dns-port"); }
    int socksPort() { return getIntValue("socks-port"); }
    int httpPort() { return getIntValue("http-port"); }
    bool useBridges() { return getBoolValue("use-bridges"); }
    QString bridges() { return _bridges; }

    void setAcceptConnection(bool ac);
    void setExitNode(QString n);
    void setDnsPort(int p);
    void setSocksPort(int p);
    void setHttpPort(int p);
    void setUseBridges(bool u);
    void setBridges(QString b);

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
    void bridgesChanged();

private:
    GSettings* _gSettingInstance;
    QString _bridges;

    QFile _bridgesFile;

};

#endif // QGSETTINGS_H
