#include "qgsettings.h"

QGSettings::QGSettings(QByteArray s_id) {
    settingNew(s_id);
    _bridgesFile.setFileName(QDir::homePath() + "/" + ".config/tractor/Bridges");
    _bridgesFile.open(QIODevice::ReadOnly | QIODevice::Text);
    _bridges = _bridgesFile.readAll();
    _bridgesFile.close();
}

void QGSettings::setAcceptConnection(bool ac) {
    setBoolValue("accept-connection", ac);
    emit acceptConnectionChanged();
}

void QGSettings::setExitNode(QString n) {
    setStringValue("exit-node", n);
    emit exitNodeChanged();
}

void QGSettings::setDnsPort(int p) {
    setIntValue("dns-port", p);
    emit dnsPortChanged();
}

void QGSettings::setSocksPort(int p) {
    setIntValue("socks-port", p);
    emit socksPortChanged();
}

void QGSettings::setHttpPort(int p) {
    setIntValue("http-port", p);
    emit httpPortChanged();
}

void QGSettings::setUseBridges(bool u) {
    setBoolValue("use-bridges", u);
    emit useBridgesChanged();
}

void QGSettings::setBridges(QString b) {
    _bridgesFile.open(QIODevice::WriteOnly | QIODevice::Text);
    _bridgesFile.write(b.toUtf8());
    _bridges = b;
    _bridgesFile.close();
    emit bridgesChanged();
}

bool QGSettings::setStringValue(QString key, QString value) {
    return  g_settings_set_string(_gSettingInstance, key.toUtf8().data(), value.toUtf8().data());
}

bool QGSettings::setBoolValue(QString key, bool value) {
    return  g_settings_set_value(_gSettingInstance, key.toUtf8().data(), g_variant_new_boolean(value));
}

bool QGSettings::setIntValue(QString key, int value) {
    return  g_settings_set_int(_gSettingInstance, key.toUtf8().data(), value);
}

QString QGSettings::getStringValue(QString key) {
    char* data = g_settings_get_string(_gSettingInstance, key.toUtf8().data());
    return QString(data);//QByteArray::fromRawData(data, sizeof(data));
}

bool QGSettings::getBoolValue(QString key) {
    GVariant* value = g_settings_get_value(_gSettingInstance, key.toUtf8().data());
    return g_variant_get_boolean(value);
}

int QGSettings::getIntValue(QString key) {
    return g_settings_get_int(_gSettingInstance, key.toUtf8().data());
}
