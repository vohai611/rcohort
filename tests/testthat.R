Sys.setenv("R_TESTS" = "")
library(testthat)
library(rcohort)
test_check("rcohort")
