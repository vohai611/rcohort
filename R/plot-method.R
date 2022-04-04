nowarn = function(x) {suppressWarnings(print(x))}

line_chart = function(df){
  p = ggplot2::ggplot(df, ggplot2::aes(variable, value, color = cohort, group = cohort))+
    ggplot2::geom_point(size = 1.5)+
    ggplot2::geom_line()+
    ggplot2::theme_light()
  nowarn(p)
}

tile_chart = function(df){

    # .[,value:= log2(value)] %>%
    p = ggplot2::ggplot(df, ggplot2::aes(variable, cohort,  fill = value))+
    ggplot2::geom_tile( color=  "grey70", size = .8)+
    ggplot2::geom_label(ggplot2::aes(label = round(value,1)))+
    ggplot2::scale_fill_gradient() +
    ggplot2::theme_light()
    nowarn(p)

}

cake_chart = function(df){
    p = ggplot2::ggplot(df,ggplot2::aes(variable, value, fill= cohort, group = cohort))+
    ggplot2::geom_area(position = ggplot2::position_stack(reverse =T), color = "white")+
    ggplot2::scale_fill_discrete()+
    ggplot2::labs(title = "Retention curve")+
    ggplot2::theme_light()
    nowarn(p)
}
#' Auto plot cohort data frame
#'
#' This auto plot function use ggplot2 as back end
#' @param data dataframe with class cohort_df
#' @param type type of plot
#' @export

auto_plot = function(data, type){
  UseMethod("auto_plot")
}

#' @export
auto_plot.cohort_df = function(data, type){
  # old plot() method
  #arg = list(...)
  #type = arg$type
  type = match.arg(type, choices = c("tile", "line", "cake"))
  melt_cohort = data.table::melt(data,id.vars = "cohort")
  #melt_cohort[,variable := as.Date(variable)]
  switch (type,
    tile = tile_chart(melt_cohort),
    line = line_chart(melt_cohort),
    cake = cake_chart(melt_cohort),
  )

}





