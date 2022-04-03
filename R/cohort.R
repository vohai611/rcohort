#' Create cohort data
#'
#' Perform cohort analysis on input data frame. Which is group entities who share the same period of time
#' and there appearance in the next period
#'
#' @param data Input data
#' @param id_col Variable to identify entities (maybe customer ID)
#' @param time_col Time with respect to id_col
#' @param time_unit Time unit to group to cohort
#' @param percent_form  Should return table contain percentage value or absolute value
#' @param relative_time Should return column is relative time or absolute period
#' @import data.table
#' @return a data frame with class cohort_df
#' @export
#'

cohort = function(data,
                  id_col,
                  time_col,
                  time_unit = c("week", "month", "quarter", "year"),
                  percent_form = FALSE,
                  relative_time = FALSE) {
  data = data.table::as.data.table(data)

  # process input
  id_col = deparse(substitute(id_col))
  time_col = deparse(substitute(time_col))
  time_unit = match.arg(time_unit)

  env = list(id_col = id_col, time_col = time_col)

  # sorting data by date
  data = data[order(time_col), env = env]
  # group and aggregate cohort to long form
  data[, time_col2 := data.table::as.IDate(time_col), env = env]
  data[, cohort := round(data.table::first(time_col2), digits = time_unit) , by = id_col, env = env]
  data[, time_col2 := round(time_col2, digits = time_unit)]
  data = data[, .(n = .N), .(time_col2, cohort)]
  end_value = "n"

  if (percent_form == TRUE)  {
    data[, pct := 100 * (n / data.table::first(n)), by = cohort]
    end_value = "pct"
  }


  # cast to wide form
  if (relative_time == FALSE) {
    rs = data.table::dcast(data, cohort ~ time_col2, value.var = end_value)
  } else {
    # relative_period is group of relative next time period
    data[order(time_col2), relative_period := 1:.N, by = cohort]

    # rename period and put in order
    data[, relative_period := forcats::fct_inorder(paste0("period_", relative_period))]
    rs = data.table::dcast(data, cohort ~ relative_period, value.var = end_value)
  }

  # rename cohort column
  rs[, cohort := paste0(year(cohort), "-", do.call(time_unit, list(cohort)))]
  # factorize cohort
  class(rs) = c("cohort_df", class(rs))
  rs[, cohort := forcats::fct_inorder(cohort)][]
}


