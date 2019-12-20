#include "translationhelper.h"

#include <QFile>
#include <Logger.h>
#include <settings.h>

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonParseError>


void TranslationHelper::readJsonFile(QString filePath, QJsonObject &jsonObj)
{
    QFile jsonFile(filePath);
    if (!jsonFile.open(QIODevice::ReadOnly)) {
        qDebug()<<"Error::could't open"<<filePath;
        return;
    }

    QByteArray jsonData = jsonFile.readAll();
    jsonFile.close();

    QJsonParseError json_error;
    QJsonDocument jsonDoc(QJsonDocument::fromJson(jsonData, &json_error));
    if (json_error.error != QJsonParseError::NoError) {
        qDebug()<<"Error::json error!";
        return;
    }

    jsonObj = jsonDoc.object();
}
// 根据字符串 srcStr从 translationInfo中寻获取对应的翻译内容
QString TranslationHelper::getTranslationStr(QString srcStr, QJsonObject translationInfo)
{
    if (translationInfo.isEmpty()) {
        return srcStr;
    }

    QString result = srcStr;
    if (translationInfo.contains(srcStr)) {
        QJsonObject subObj = translationInfo.value(srcStr).toObject();
        QString language = Settings.language();     // QLocale::system().name();
        result = subObj.value(language).toString();
        if (result.isEmpty()) {
            result = subObj.value("en").toString();;
        }
    }

    return result;
}
