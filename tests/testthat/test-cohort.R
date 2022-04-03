start= as.Date("2020-01-01")
end = as.Date("2025-01-01")
date_seq= seq(start, end, length.out = 1000)
set.seed(1)
df = data.frame(x1= sample(1:300, size = 1000, replace = TRUE), x2 = sample(date_seq, size = 1000, replace = TRUE))

df_cohort = rcohort::cohort(df, x1, x2, "month", percent_form = T, relative_time = T)
nrow(df_cohort)

pct_test = function(){
  df_test = df_cohort[, -1] <= 100
  df_test[!is.na(df_test)] |> all()
}



test_that("Basic form check", {
  expect_equal(nrow(df_cohort), 55)
  expect_equal(pct_test(), TRUE)
})
