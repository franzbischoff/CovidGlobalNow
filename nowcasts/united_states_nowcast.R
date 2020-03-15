# Packages ----------------------------------------------------------------
require(TimeVaryingNCovR0)
require(dplyr)

# Read in linelist --------------------------------------------------------
linelist <- get_combined_linelist()

# Read in international linelist --------------------------------------------------------
int_linelist <- get_international_linelist("United States") %>%
  tidyr::drop_na(date_confirm)

# Get WHO sit rep case counts ---------------------------------------------

total_cases <- TimeVaryingNCovR0::get_who_cases("UnitedStatesofAmerica", daily = TRUE)

# Join imported and local cases -------------------------------------------

cases <- TimeVaryingNCovR0::get_local_import_case_counts(total_cases, int_linelist) %>%
  dplyr::filter(date >= "2020-02-22")

# Run analysis pipeline and save results ----------------------------------

## Set the target date
target_date <- as.character(max(cases$date))

## Run and save analysis pipeline
TimeVaryingNCovR0::analysis_pipeline(
  cases = cases,
  linelist = linelist,
  target_folder = file.path("inst/results/united-states", target_date),
  target_date = target_date,
  merge_actual_onsets = FALSE, samples = 10)