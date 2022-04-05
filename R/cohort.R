#' Create cohort data
#'
#' cohort_count() perform cohort analysis by counting the appearance of `id_col`. `id_col` will only count one time for all appearance in each time period.
#' This cohort analysis is suitable to measure customer retention. To summarize for example revenue of each cohort, use `cohort_summarise()`
#'
#' @param data Input data
#' @param .id_col Variable to identify entities (maybe customer ID)
#' @param .time_col Time with respect to id_col
#' @param time_unit Time unit to group to cohort
#' @param percent_form  Should return table contain percentage value or absolute value
#' @param relative_time Should return column is relative time or absolute period
#' @param all_group Should result include group of all entities. This argument
#' must only set to TRUE when both percent_form and relative_time is TRUE
#' @importFrom data.table :=
#' @importFrom data.table month week quarter year
#' @return a data frame with class cohort_df
#' @export
#'

cohort_count = function(data,
                  .id_col,
                  .time_col,
                  time_unit = c("week", "month", "quarter", "year"),
                  percent_form = TRUE,
                  relative_time = TRUE,
                  all_group = FALSE
                  ) {

  # check input
  data = data.table::as.data.table(data)
  time_unit = match.arg(time_unit)
  if(all_group == TRUE && (percent_form == FALSE || relative_time == FALSE)) {
    stop("`all_group` can only set to `TRUE` when both `percent_form` and `relative_time` is `TRUE`")
  }

  # process input
  id_col = deparse(substitute(.id_col))
  time_col = deparse(substitute(.time_col))

  env = list(id_col = id_col, time_col = time_col)

  # remove unnecessary column
  data = data[, .(id_col, time_col), env =env]
  # sorting data by date
  data = data[order(time_col), env = env]
  # group and aggregate cohort to long form
  data[, time_col2 := data.table::as.IDate(time_col), env = env]
  data[, cohort := round(data.table::first(time_col2), digits = time_unit) , by = id_col, env = env]
  data[, time_col2 := round(time_col2, digits = time_unit)]
  # distinct id_col and time_col2
  data= unique(data, by = c(env$id_col, "time_col2", "cohort"))

  data = data[, .(n = .N), .(time_col2, cohort)]
  end_value = "n"

  if (percent_form)  {
    data[, pct := 100 * (n / data.table::first(n)), by = cohort]
    end_value = "pct"
  }

  # cast to wide form
  if (relative_time) {
    # relative_period is group of relative next time period
    data[order(time_col2), relative_period := 1:.N, by = cohort]

    # rename period and put in order
    data[, relative_period := forcats::fct_inorder(paste0(time_unit,"_", relative_period))]

    rs = data.table::dcast(data, cohort ~ relative_period, value.var = end_value)

  } else {
    rs = data.table::dcast(data, cohort ~ time_col2, value.var = end_value)
  }

  # rename cohort column
  rs[, cohort := paste0(data.table::year(cohort), "-", do.call(time_unit, list(cohort)))]

  ## add all cohort group
    if(all_group){
      all_group = data[, .(pct = sum(n)), by= relative_period][, .(cohort = "All", pct= 100 * pct / data.table::first(pct), relative_period)]
      all_group = data.table::dcast(all_group, cohort ~ relative_period, value.var= "pct")
      rs = rbind(all_group,rs)

    }

  # factorize cohort
  class(rs) = c("cohort_df", class(rs))
  rs[, cohort := forcats::fct_inorder(cohort)][]
}



#' Create cohort data
#'
#' cohort_summarise() perform cohort analysis by summarizing variable. For example, sum() of revenue of each cohort.
#' @inheritParams cohort_count
#' @param .summarise_col Variable to perform summarise on
#' @param .fn Function to perform summarise, in character form.default is "`sum`". This
#' function should return length 1 numeric value,
#' @param ... Additional argument pass to `.fn`
#' @export
cohort_summarise = function(data,
                  .id_col,
                  .time_col,
                  .summarise_col,
                  .fn = c("mean"),
                  ...,
                  time_unit = c("week", "month", "quarter", "year"),
                  percent_form = TRUE,
                  relative_time = TRUE,
                  all_group = FALSE
                  ) {

  # check input
  data = data.table::as.data.table(data)
  time_unit = match.arg(time_unit)
  if(all_group == TRUE && (percent_form == FALSE || relative_time == FALSE)) {
    stop("`all_group` can only set to `TRUE` when both `percent_form` and `relative_time` is `TRUE`")
  }

  # process input
  id_col = deparse(substitute(.id_col))
  time_col = deparse(substitute(.time_col))
  summarise_col = deparse(substitute(.summarise_col))

  env = list(id_col = id_col, time_col = time_col, summarise_col = summarise_col)

  # remove unnecessary column
  data = data[, .(id_col, time_col, summarise_col), env =env]
  # sorting data by date
  data = data[order(time_col), env = env]
  # group and aggregate cohort to long form
  data[, time_col2 := data.table::as.IDate(time_col), env = env]
  data[, cohort := round(data.table::first(time_col2), digits = time_unit) , by = id_col, env = env]
  data[, time_col2 := round(time_col2, digits = time_unit)]
  # distinct id_col and time_col2
  #data= unique(data, by = c(env$id_col, "time_col2", "cohort"))

  data = data[, .(n = do.call(.fn, list(summarise_col, ...))), .(time_col2, cohort), env = env]
  end_value = "n"

  if (percent_form)  {
    data[, pct := 100 * (n / data.table::first(n)), by = cohort]
    end_value = "pct"
  }

  # cast to wide form
  if (relative_time) {
    # relative_period is group of relative next time period
    data[order(time_col2), relative_period := 1:.N, by = cohort]

    # rename period and put in order
    data[, relative_period := forcats::fct_inorder(paste0(time_unit,"_", relative_period))]

    rs = data.table::dcast(data, cohort ~ relative_period, value.var = end_value)

  } else {
    rs = data.table::dcast(data, cohort ~ time_col2, value.var = end_value)
  }

  # rename cohort column
  rs[, cohort := paste0(data.table::year(cohort), "-", do.call(time_unit, list(cohort)))]

  ## add all cohort group
    if(all_group){
      all_group = data[, .(pct = sum(n)), by= relative_period][, .(cohort = "All", pct= 100 * pct / data.table::first(pct), relative_period)]
      all_group = data.table::dcast(all_group, cohort ~ relative_period, value.var= "pct")
      rs = rbind(all_group,rs)

    }

  # factorize cohort
  class(rs) = c("cohort_df", class(rs))
  rs[, cohort := forcats::fct_inorder(cohort)][]
}


