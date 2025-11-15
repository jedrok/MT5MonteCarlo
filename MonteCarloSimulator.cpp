#include "MonteCarloSimulator.h"
#include <QDebug>
#include <QVariantMap>
#include <algorithm>
#include <numeric>
#include <cmath>

MonteCarloSimulator::MonteCarloSimulator(QObject *parent)
    : QObject(parent)
    , m_stopRequested(false)
{
    std::random_device rd;
    m_generator = std::mt19937(rd());
}

void MonteCarloSimulator::runSimulation(const QVector<double> &outcomes, double initialBalance, int numSimulations, bool randomizeOrder) {
    if (outcomes.isEmpty()) {
        emit simulationFailed("No trade data available");
        return;
    }

    if (initialBalance <= 0) {
        emit simulationFailed("Initial balance must be positive");
        return;
    }

    m_stopRequested = false;

    QVector<SimulationResult> results;
    results.reserve(numSimulations);

    try {
        for (int i = 0; i < numSimulations; ++i) {
            if (m_stopRequested) {
                emit simulationStopped();
                return;
            }

            QVector<double> simOutcomes = outcomes;

            if (randomizeOrder) {
                std::shuffle(simOutcomes.begin(), simOutcomes.end(), m_generator);
            }

            SimulationResult result = runSingleSimulation(simOutcomes, initialBalance);
            results.append(result);

            if (i % 10 == 0 || i == numSimulations - 1) {
                emit simulationProgress(i + 1, numSimulations);
            }
        }

        AggregatedMetrics metrics = aggregateResults(results, outcomes.size());

        QVariantMap metricsMap = metricsToVariantMap(metrics);

        emit simulationComplete(metricsMap);

    } catch (const std::exception &e) {
        emit simulationFailed(QString("Simulation error: %1").arg(e.what()));
    }
}

void MonteCarloSimulator::stopSimulation()
{
    m_stopRequested = true;
}

MonteCarloSimulator::SimulationResult
MonteCarloSimulator::runSingleSimulation(const QVector<double> &outcomes, double initialBalance) {
    SimulationResult result;
    result.equityCurve.reserve(outcomes.size() + 1);

    double balance = initialBalance;
    double peak = initialBalance;
    double maxDrawdown = 0;
    double maxDrawdownPercent = 0;

    int consecutiveLosses = 0;
    int maxConsecutiveLosses = 0;

    double grossProfit = 0;
    double grossLoss = 0;
    int winningTrades = 0;

    QVector<double> wins;
    QVector<double> losses;
    QVector<double> returns;

    result.equityCurve.append(balance);     //initial balance

    for (double outcome : outcomes) {
        balance += outcome;
        result.equityCurve.append(balance);

        if (balance > peak) {
            peak = balance;
        }

        double currentDrawdown = peak - balance;
        if (currentDrawdown > maxDrawdown) {
            maxDrawdown = currentDrawdown;
            maxDrawdownPercent = (maxDrawdown / peak) * 100.0;
        }

        if (outcome > 0) {
            winningTrades++;
            grossProfit += outcome;
            wins.append(outcome);
            consecutiveLosses = 0;
        } else if (outcome < 0) {
            grossLoss += std::abs(outcome);
            losses.append(std::abs(outcome));
            consecutiveLosses++;
            maxConsecutiveLosses = std::max(maxConsecutiveLosses, consecutiveLosses);
        }

        double tradeReturn = (outcome / (balance - outcome)) * 100.0;
        returns.append(tradeReturn);
    }

    result.finalBalance = balance;
    result.returnPercent = ((balance - initialBalance) / initialBalance) * 100.0;
    result.maxDrawdown = maxDrawdown;
    result.maxDrawdownPercent = maxDrawdownPercent;
    result.maxConsecutiveLosses = maxConsecutiveLosses;
    result.winRate = (static_cast<double>(winningTrades) / outcomes.size()) * 100.0;
    result.avgWin = wins.isEmpty() ? 0 : std::accumulate(wins.begin(), wins.end(), 0.0) / wins.size();
    result.avgLoss = losses.isEmpty() ? 0 : std::accumulate(losses.begin(), losses.end(), 0.0) / losses.size();
    result.riskRewardRatio = (result.avgLoss != 0) ? result.avgWin / result.avgLoss : 0;
    result.profitFactor = (grossLoss != 0) ? grossProfit / grossLoss : 0;

    // sharpe ratio based on 252 days
    if (!returns.isEmpty()) {
        double meanReturn = std::accumulate(returns.begin(), returns.end(), 0.0) / returns.size();
        double variance = 0;
        for (double r : returns) {
            variance += std::pow(r - meanReturn, 2);
        }
        double stdDev = std::sqrt(variance / returns.size());
        result.sharpeRatio = (stdDev != 0) ? (meanReturn / stdDev) * std::sqrt(252) : 0;
    } else {
        result.sharpeRatio = 0;
    }
    result.calmarRatio = (maxDrawdownPercent != 0) ? std::abs(result.returnPercent / maxDrawdownPercent) : 0;

    return result;
}

MonteCarloSimulator::AggregatedMetrics
MonteCarloSimulator::aggregateResults(const QVector<SimulationResult> &results, int totalTrades) {
    AggregatedMetrics metrics;
    metrics.numSimulations = results.size();
    metrics.totalTrades = totalTrades;

    QVector<double> returns;
    QVector<double> maxDrawdowns;
    QVector<double> sharpeRatios;
    QVector<double> profitFactors;
    QVector<double> calmarRatios;
    QVector<double> winRates;
    QVector<double> riskRewards;
    QVector<double> avgLosses;
    QVector<double> finalBalances;

    double totalWins = 0;
    double largestWin = 0;

    for (const auto &result : results) {
        returns.append(result.returnPercent);
        maxDrawdowns.append(result.maxDrawdownPercent);
        sharpeRatios.append(result.sharpeRatio);
        profitFactors.append(result.profitFactor);
        calmarRatios.append(result.calmarRatio);
        winRates.append(result.winRate);
        riskRewards.append(result.riskRewardRatio);
        avgLosses.append(result.avgLoss);
        finalBalances.append(result.finalBalance);

        totalWins += result.avgWin;
        if (result.avgWin > largestWin) {
            largestWin = result.avgWin;
        }
    }

    metrics.medianReturn = calculatePercentile(returns, 50);
    metrics.meanReturn = std::accumulate(returns.begin(), returns.end(), 0.0) / returns.size();
    metrics.bestReturn = calculatePercentile(returns, 99);
    metrics.worstReturn = calculatePercentile(returns, 1);

    metrics.medianMaxDrawdown = calculatePercentile(maxDrawdowns, 50);
    metrics.bestMaxDrawdown = calculatePercentile(maxDrawdowns, 5);
    metrics.worstMaxDrawdown = calculatePercentile(maxDrawdowns, 95);

    metrics.medianSharpeRatio = calculatePercentile(sharpeRatios, 50);
    metrics.medianProfitFactor = calculatePercentile(profitFactors, 50);
    metrics.medianCalmarRatio = calculatePercentile(calmarRatios, 50);
    metrics.medianWinRate = calculatePercentile(winRates, 50);
    metrics.valueAtRisk95 = calculatePercentile(returns, 5);  // 5th percentile = 95% VaR

    int ruinCount = 0;
    for (const auto &result : results) {
        if (result.maxDrawdownPercent > 50) {
            ruinCount++;
        }
    }
    metrics.riskOfRuin = (static_cast<double>(ruinCount) / results.size()) * 100.0;
    metrics.avgRiskReward = std::accumulate(riskRewards.begin(), riskRewards.end(), 0.0) / riskRewards.size();
    metrics.avgLoss = std::accumulate(avgLosses.begin(), avgLosses.end(), 0.0) / avgLosses.size();
    metrics.largestWin = largestWin;
    double avgFinalBalance = std::accumulate(finalBalances.begin(), finalBalances.end(), 0.0) / finalBalances.size();
    metrics.expectancyPerTrade = avgFinalBalance / totalTrades;

    return metrics;
}

double MonteCarloSimulator::calculatePercentile(QVector<double> values, double percentile)
{
    if (values.isEmpty()) return 0;

    std::sort(values.begin(), values.end());

    int index = static_cast<int>((percentile / 100.0) * values.size());
    if (index >= values.size()) index = values.size() - 1;
    if (index < 0) index = 0;

    return values[index];
}

QVariantMap MonteCarloSimulator::metricsToVariantMap(const AggregatedMetrics &metrics)
{
    QVariantMap map;

    // overview
    map["numSimulations"] = metrics.numSimulations;
    map["medianReturn"] = metrics.medianReturn;
    map["meanReturn"] = metrics.meanReturn;
    map["medianMaxDrawdown"] = metrics.medianMaxDrawdown;
    map["medianSharpeRatio"] = metrics.medianSharpeRatio;
    map["riskOfRuin"] = metrics.riskOfRuin;
    map["medianCalmarRatio"] = metrics.medianCalmarRatio;

    // returns
    map["bestReturn"] = metrics.bestReturn;
    map["worstReturn"] = metrics.worstReturn;
    map["medianProfitFactor"] = metrics.medianProfitFactor;

    // risk
    map["bestMaxDrawdown"] = metrics.bestMaxDrawdown;
    map["worstMaxDrawdown"] = metrics.worstMaxDrawdown;
    map["valueAtRisk95"] = metrics.valueAtRisk95;

    // trades
    map["totalTrades"] = metrics.totalTrades;
    map["medianWinRate"] = metrics.medianWinRate;
    map["avgRiskReward"] = metrics.avgRiskReward;
    map["expectancyPerTrade"] = metrics.expectancyPerTrade;
    map["avgLoss"] = metrics.avgLoss;
    map["largestWin"] = metrics.largestWin;

    return map;
}
