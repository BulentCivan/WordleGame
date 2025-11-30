#include "WordOperator.h"
#include <QFile>
#include <QTextStream>
#include <QRandomGenerator>
#include <QDebug>

WordOperator::WordOperator(QObject *parent)
    : QObject(parent)
{
    QFile file(":/words.txt"); //file reading
    if (file.open(QIODevice::ReadOnly)) {

        QTextStream in(&file);

        while (!in.atEnd()) {
            QString w = in.readLine().trimmed().toUpper();
            if (w.length() == 5)
                dictionary.append(w);
        }

        file.close();
    }
}

//checking if the user guess is really a word
bool WordOperator::isValidWord(const QString &word)
{
    return dictionary.contains(word.toUpper());
}

//choosing a random word for game
QString WordOperator::getRandomWord()
{
    int index = QRandomGenerator::global()->bounded(dictionary.size());
    qInfo() << "Selected Word: " << dictionary[index];
    return dictionary[index];
}


//checking if user guess is correct or incorrect and returning including letters for target word
QVariantMap WordOperator::checkGuess(const QString &guess, const QString &target)
{
    QVariantMap result;
    QStringList correct, misplaced;

    for (int i = 0; i < guess.length(); i++) {
        QChar c = guess[i];

        if (c == target[i])
            correct.append(QString(c));
        else if (target.contains(c))
            misplaced.append(QString(c));
    }

    result["correct"] = correct;
    result["misplaced"] = misplaced;
    return result;
}

