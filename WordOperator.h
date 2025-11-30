#ifndef WORDOPERATOR_H
#define WORDOPERATOR_H

#include <QObject>
#include <QVariantMap>
#include <QVector>

class WordOperator: public QObject
{
    Q_OBJECT

public:
    explicit WordOperator(QObject *parent = nullptr);

    Q_INVOKABLE bool isValidWord(const QString &word);
    Q_INVOKABLE QString getRandomWord();
    Q_INVOKABLE QVariantMap checkGuess(const QString &guess, const QString &target);

private:
    QVector<QString> dictionary;
};


#endif // WORDOPERATOR_H

