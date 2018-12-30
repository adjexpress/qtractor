#include <QVariant>

#undef signals

#include <gio/gio.h>



class Qgsettings : public QObject{
    Q_OBJECT
    Q_PROPERTY(QByteArray schema READ schema WRITE setSchema)

public:
    Qgsettings(QObject *parent = 0) : QObject(parent) { }

    Q_INVOKABLE void settingNew() {
        gSettingInstance = g_settings_new(m_schema_id);
    }

    Q_INVOKABLE bool setStringValue(QByteArray key, QByteArray value) {
        return  g_settings_set_string(gSettingInstance, key.data(), value.data());
    }

    Q_INVOKABLE QByteArray getStringValue(QByteArray key) {
        char* data = g_settings_get_string(gSettingInstance, key.data());
        return QByteArray::fromRawData(data, sizeof(data));
    }

    QByteArray schema() const {
        return q_schema_id;
    }
    void setSchema(const QByteArray &str) {
        if (q_schema_id != str) {  // guard
            q_schema_id = str;
            m_schema_id = q_schema_id.data();
        }
    }

private:
    QByteArray q_schema_id;
    char* m_schema_id;
    GSettings* gSettingInstance;
};
