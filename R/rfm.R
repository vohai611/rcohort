cut_tile = function(x, n){
  breaks= quantile(x, prob = seq(0,1, length = n+1), na.rm= TRUE)
  breaks = unique(breaks)
  cut(x, breaks , labels = FALSE, include.lowest = TRUE)
}

#' Compute RFM metrics
#'
#' Recently, Frequency, Monetary score
#'
#' @inheritParams cohort_count
#' @param .m_col Column to compute monetary score, default to not compute
#' @cur_time reference time to compute Recently metrics
#' @export

rfm_score = function(data, .id_col, .time_col, .m_col = NULL, cur_time = Sys.time()){

  df = as.data.table(data)
  # process input
  id_col = deparse(substitute(.id_col))
  time_col = deparse(substitute(.time_col))
  m_col = deparse(substitute(.m_col))
  env = list(id_col = id_col, time_col = time_col, m_col = m_col)

  df1 = df[, .(
    r = as.numeric(difftime(cur_time, max(time_col))),
    f = uniqueN(time_col),
    m = sum(m_col, na.rm =TRUE)), by = id_col, env = env]
  df2 = df1[, lapply(.SD, cut_tile, 4), .SDcols = c("r", "f", "m")]

  df2 = cbind(df1[[id_col]], df2)
  names(df2)[1] = id_col

  rs = df2[, .(id_col, r, f, m, rfm_score = (r + f + m)), env= env]
  class(rs)  = c("rfm_df", class(rf))
  return(rs)

}



