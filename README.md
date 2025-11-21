# MT5 Monte Carlo Simulator

A fast cross-platform **desktop application for running Monte Carlo simulations on your strategy based on MetaTrader 5 (MT5) backtest results.** 

This tool helps to understand the robustness of your strategy by running randomized simulations on historical trade sequences extracted directly from MT5 backtest reports.
MT5 backtest reports provide only a single historical sequence of trades.
This app performs Monte Carlo resampling to simulate thousands of alternative outcomes not visible in the original MT5 report.
---

## Features

- **Upload MT5 backtest Excel report (.xlsx)**  
  The app automatically extracts all trade data from the file and any other necessary data.

- **Monte Carlo Simulation Engine**  
  Currently supports:
  - Randomized trade order simulation  
  - Multiple simulation runs  
  - Equity curve generation  
  - Drawdown analysis  
  - Key performance metrics (Win rate, MDD, Expectancy, Profit Factor, etc.)

- **Clean, modern UI (Qt)**  
  Fast, lightweight and intuitive interface.

- **Cross-platform (Windows / Linux / MacOS)**

---


