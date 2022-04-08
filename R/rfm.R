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
#' @param cur_time reference time to compute Recently metrics
#' @param scale maximum score of each metrics
#' @export

rfm_score = function(data,
                     .id_col,
                     .time_col,
                     .m_col = NULL,
                     cur_time = Sys.time(),
                     scale = 4) {

  df = as.data.table(data)
  # process input
  id_col = deparse(substitute(.id_col))
  time_col = deparse(substitute(.time_col))
  m_col = deparse(substitute(.m_col))
  env = list(id_col = id_col,
             time_col = time_col,
             m_col = m_col)

  df1 = df[, .(
    r = as.numeric(difftime(max(time_col), cur_time)),
    f = uniqueN(time_col),
    m = sum(m_col, na.rm = TRUE)
  ), by = id_col, env = env]

  df2 = df1[, lapply(.SD, cut_tile, scale), .SDcols = c("r", "f", "m")]
  df1$r = abs(df1$r)
  names(df2) = paste0(c("r", "f", "m"), "_score")

  rs = cbind(df1, df2)
  rs[, rfm_score := r_score + f_score + m_score]
  rs = rs[order(-rfm_score),]

  class(rs)  = c("rfm_df", class(rs))
  return(rs)

}



