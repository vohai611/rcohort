test_that("Basic form check", {
  start = as.Date("2020-01-01")
  end = as.Date("2025-01-01")
  date_seq = seq(start, end, length.out = 1000)
  set.seed(1)
  df = data.frame(
    x1 = sample(1:300, size = 1000, replace = TRUE),
    x2 = sample(date_seq, size = 1000, replace = TRUE)
  )
  df_cohort = cohort(df, x1, x2, "month", relative_time = FALSE)
  df_cohort2 = cohort(df, x1, x2, "month", all_group = TRUE)

  expect_equal(nrow(df_cohort), 55)
 # expect_snapshot(df_cohort)
 # expect_snapshot(df_cohort2)
})
