#include "ExcelParser.h"
#include <QDebug>
#include <QUrl>

ExcelParser::ExcelParser(QObject *parent)
    : QObject(parent), m_initialBalance(0.0)
{
}

void ExcelParser::parseExcelFile(const QString &filePath)
{
    m_trades.clear();
    m_initialBalance = 0.0;

    QString localPath = filePath;
    if (localPath.startsWith("file://")) {
        QUrl url(filePath);
        localPath = url.toLocalFile();
    }

    try {
        xlnt::workbook wb;
        wb.load(localPath.toStdString());

        auto sheet = wb.active_sheet();

        bool dealsSectionFound = false;
        bool columnNamesRowFound = false;

        auto rows = sheet.rows();
        int totalRows = 0;
        int currentRow = 0;

        for (auto it = rows.begin(); it != rows.end(); ++it) {
            totalRows++;
        }

        for (auto rowIter = rows.begin(); rowIter != rows.end(); ++rowIter)
        {
            currentRow++;

            // give progress every 10 rows
            if (currentRow % 10 == 0) {
                emit parsingProgress(currentRow, totalRows);
            }

            auto row = *rowIter;
            std::string cellValue = row[0].to_string();

            if (cellValue == "Deals")
            {
                dealsSectionFound = true;
                continue;
            }

            if (dealsSectionFound)
            {
                if (!columnNamesRowFound)
                {
                    columnNamesRowFound = true;
                    continue;
                }

                if (m_initialBalance == 0.0)
                {
                    m_initialBalance = row[11].value<double>();
                    continue;
                }

                if (row[4].to_string() == "in")
                {
                    std::string type = row[3].to_string();

                    if (++rowIter != rows.end())
                    {
                        auto nextRow = *rowIter;
                        double outcome = nextRow[10].value<double>();

                        Trade trade;
                        trade.type = QString::fromStdString(type);
                        trade.outcome = outcome;
                        m_trades.append(trade);

                    }
                }
            }
        }

        emit parsingComplete(m_initialBalance, m_trades.size());

    } catch (const std::exception &e) {
        QString errorMsg = QString("Failed to parse Excel file: %1").arg(e.what());
        qDebug() << errorMsg;
        emit parsingFailed(errorMsg);
    }
}

QVector<double> ExcelParser::getTradeOutcomes() const
{
    QVector<double> outcomes;
    outcomes.reserve(m_trades.size());

    for (const auto &trade : m_trades) {
        outcomes.append(trade.outcome);
    }

    return outcomes;
}
