# AFLBrownlowPredictor

An ordinal logistic regression model for predicting AFL Brownlow Medal votes, applied annually since 2023. The model predicts the number of votes (0, 1, 2, or 3) a player receives from the field umpires in each game, based on individual performance statistics, team metrics, and historical recognition data.

Data is compiled from the `fitzRoy` R package, afl.com.au, AFL Tables, and the AFL Coaches Association (AFLCA).

## Results by Year

| Year | MAE | 3-Vote Accuracy | Winner Predicted? | Notable |
| :--- | :-- | :-------------- | :---------------- | :------ |
| [2023](2023/) | 2.165 | 56.52% (117/207) | ✗ Lachie Neale (predicted 3rd) | Top 2 correctly ranked |
| [2024](2024/) | 2.008 | 55.56% (115/207) | ✓ Patrick Cripps (predicted record-breaking tally) | Top 2 correctly ranked; correctly predicted Cripps breaking all-time vote record |

MAE is calculated on the subset of players who predicted to poll votes and/or actually polled votes, excluding players who were correctly predicted to poll 0 (to avoid inflating accuracy).

## Model Improvements Over Time

**2023 → 2024:** Added a `Position` variable sourced from the AFL website. This addressed a systematic bias in 2023 where ruckmen (Rowan Marshall, Max Gawn, Tim English) had significantly inflated predicted votes — the Brownlow is predominantly a midfielder award, and the model needed to account for positional context.

## Approach

The model uses cumulative link modelling (`clm` from the `ordinal` package) to handle the ordered, discrete nature of Brownlow votes (0/1/2/3). Key design decisions:

- **Training/test split by season** — trained on 2015 to the prior season, tested on the current season only
- **Feature standardisation** — numeric features scaled using training-set parameters only (center/scale stored and applied to test data to prevent leakage)
- **Feature engineering** — derived variables (e.g. `Ineffective.Kicks`, `Contested.Possessions.No.Mark`) to reduce multicollinearity between raw stats
- **Historical features** — prior season Brownlow and Coaches Association votes included to capture consistent performers

## Repository Structure

```
AFLBrownlowPredictor/
├── 2023/
│   ├── AFL.Brownlow.Prediction.Model.2023.Rmd   # Analysis and model code
│   ├── AFL.Brownlow.Prediction.Model.2023.html  # Knitted output
│   └── brownlow_data.csv                        # Input data
├── 2024/
│   ├── AFL.Brownlow.Prediction.Model.2024.Rmd   # Analysis and model code
│   ├── AFL.Brownlow.Prediction.Model.2024.html  # Knitted output
│   └── brownlow_data_2024.csv                   # Input data
├── setup_renv.R                                 # One-time environment setup
├── .Rprofile                                    # Activates renv on project open
└── README.md
```

## Reproducibility

This project uses [`renv`](https://rstudio.github.io/renv/) for package management. To reproduce the environment:

```r
Rscript setup_renv.R
```

This installs all required packages and generates a `renv.lock` file. Required packages: `tidyverse`, `ordinal`, `knitr`, `unglue`, `fastDummies`, `writexl`, `DT`, `caret`, `ggplot2`.
