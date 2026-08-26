# AFLBrownlowPredictor

Ordinal logistic regression model predicting AFL Brownlow Medal votes, applied annually since 2023.

## What it does

Predicts the number of Brownlow votes (0, 1, 2, or 3) a player receives from umpires in each AFL game. The model is trained on historical seasons and tested on the current season.

## Structure

```
AFLBrownlowPredictor/
├── 2023/
│   ├── AFL.Brownlow.Prediction.Model.2023.Rmd   # Full analysis and model code
│   ├── AFL.Brownlow.Prediction.Model.2023.html  # Knitted HTML output
│   └── brownlow_data.csv                        # Input data (2015–2023)
├── 2024/
│   ├── AFL.Brownlow.Prediction.Model.2024.Rmd   # Full analysis and model code
│   ├── AFL.Brownlow.Prediction.Model.2024.html  # Knitted HTML output
│   └── brownlow_data_2024.csv                   # Input data (2015–2024)
├── setup_renv.R    # Run once to initialise renv and generate renv.lock
└── .Rprofile       # Activates renv automatically on project open
```

## Key modelling decisions

- **Model**: Cumulative link model (`clm` from the `ordinal` package) — correct choice for ordered discrete outcomes (0/1/2/3 votes)
- **Train/test split**: Train on 2015 to prior season, test on current season only — no leakage
- **Standardisation**: Numeric features scaled using training-set mean/SD only; center and scale stored and applied to test data
- **Feature engineering**: Derived variables (e.g. `Ineffective.Kicks = Kicks - Effective.Kicks`) to reduce multicollinearity
- **Historical features**: Prior season Brownlow and AFLCA votes included to capture consistent performers
- **Position variable** (2024+): Added to address ruckman vote inflation observed in 2023

## Data sources

- `fitzRoy` R package (player stats)
- afl.com.au (player positions)
- AFL Tables (historical stats)
- AFL Coaches Association (AFLCA votes)

## Packages

`tidyverse`, `ordinal`, `knitr`, `unglue`, `fastDummies`, `writexl`, `DT`, `caret`, `ggplot2`

Run `Rscript setup_renv.R` once to install all packages and generate `renv.lock`.

## Results summary

| Year | MAE | 3-Vote Accuracy | Winner |
|------|-----|-----------------|--------|
| 2023 | 2.165 | 56.52% (117/207) | ✗ Lachie Neale (predicted 3rd) |
| 2024 | 2.008 | 55.56% (115/207) | ✓ Patrick Cripps |
| 2025 | 2.228 | 58.54% (120/205) | ✗ Matt Rowell (predicted 6th); top pick Nick Daicos finished 2nd |

## Adding a new year

1. Compile `brownlow_data_{year}.csv` from the same sources
2. Copy the prior year's `.Rmd` into a new `{year}/` subdirectory
3. Update `train_end_season` and `test_season`
4. Update the results table in this file and in `README.md`
