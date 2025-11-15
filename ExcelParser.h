#ifndef EXCELPARSER_H
#define EXCELPARSER_H

#include <QObject>
#include <QString>
#include <QVariant>
#include <xlnt/xlnt.hpp>
#include <QVector>


class ExcelParser : public QObject
{
    Q_OBJECT
public:
    explicit ExcelParser(QObject *parent = nullptr);

    Q_INVOKABLE QVector<double> getTradeOutcomes() const;
    Q_INVOKABLE double getInitialBalance() const { return m_initialBalance; }

public slots:
    void parseExcelFile(const QString &filePath);

signals:
    void parsingComplete(double initialBalance, int tradeCount);
    void parsingFailed(const QString &error);
    void parsingProgress(int current, int total);


private:
    struct Trade {
        QString type;
        double outcome;
    };

    QList<Trade> m_trades;
    double m_initialBalance;

};

#endif
