# Immigration Attitudes and Policy Change

## Overview

This repository contains the reproducible code and documentation for a cross-national analysis of public attitudes toward immigration. The analysis links individual-level European Social Survey (ESS) data with country-level MIPEX and immigrant share change measures.

## Authors

- Ferzan Ideli
- Eva Carlier

## Repository Structure

- `README.md` — project overview and instructions
- `.gitignore` — excludes data, logs, and generated output
- `code/` — Stata do-files in execution order
- `data/` — cleaned input datasets (not included if restricted)
- `output/` — output tables, figures, and exported results

## Files

### Code
- `code/01_clean_ess_waves.do` — clean individual ESS wave files and harmonize variables
- `code/02_merge_ess_waves.do` — append ESS waves 7–11 into a single dataset
- `code/03_calculate_fb_change_mipex.do` — generate change measures for immigrant share and MIPEX data
- `code/04_merge_ess_mipex.do` — merge ESS and country-wave MIPEX data
- `code/05_analysis.do` — prepare predictors and estimate multilevel models

### Data
- `data/ESS7_clean.dta`
- `data/ESS8_clean.dta`
- `data/ESS9_clean.dta`
- `data/ESS10_clean.dta`
- `data/ESS11_clean.dta`
- `data/fb_change_MIPEX_clean.dta`

### Output
- `output/immigration_models.html`
- `output/economic_threat_models.html`
- `output/mipex_fb_change.png`

## Reproducibility

This project is designed for reproducibility across platforms, including macOS.

- All Stata scripts use relative file paths
- The execution order is explicit
- Code is separated from data and output
- Data sources and cleaning steps are documented in the Stata code

## Usage

1. Place cleaned input datasets in `data/`
2. Open Stata
3. Run the Stata scripts in order from `code/`:
   1. `code/01_clean_ess_waves.do`
   2. `code/02_merge_ess_waves.do`
   3. `code/03_calculate_fb_change_mipex.do`
   4. `code/04_merge_ess_mipex.do`
   5. `code/05_analysis.do`

## Data Notes

- This repository does not include restricted or raw ESS data.
- Keep sensitive or proprietary data out of GitHub.
- Document the original data source if data cannot be shared directly.
- The code shows all cleaning and transformation steps.

## GitHub Best Practices

- Use a `.gitignore` file to exclude:
  - `*.dta`
  - `*.log`
  - `*.smcl`
  - `*.doc`
  - `*.png`
- Keep code and data in separate directories
- Use descriptive, ordered do-file names
- Maintain a clear execution order in `README.md`

## Stata Version

Tested on Stata 17+.

## License

Choose a license if you want to make this work reusable and citable, for example:

- MIT
- CC BY 4.0
- GPL-3.0
