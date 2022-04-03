# Basic form check

    Code
      df_cohort
    Output
           cohort 2020-01-01 2020-02-01 2020-03-01 2020-04-01 2020-05-01 2020-06-01
           <fctr>      <num>      <num>      <num>      <num>      <num>      <num>
       1:  2020-1        100         NA         NA         NA         NA         NA
       2:  2020-2         NA        100   14.28571   7.142857   7.142857         NA
       3:  2020-3         NA         NA  100.00000         NA         NA   5.882353
       4:  2020-4         NA         NA         NA 100.000000   7.142857   7.142857
       5:  2020-5         NA         NA         NA         NA 100.000000   7.142857
      ---                                                                          
      51:  2024-6         NA         NA         NA         NA         NA         NA
      52:  2024-7         NA         NA         NA         NA         NA         NA
      53:  2024-8         NA         NA         NA         NA         NA         NA
      54: 2024-11         NA         NA         NA         NA         NA         NA
      55: 2024-12         NA         NA         NA         NA         NA         NA
      55 variable(s) not shown: [2020-07-01 <num>, 2020-08-01 <num>, 2020-09-01 <num>, 2020-10-01 <num>, 2020-11-01 <num>, 2020-12-01 <num>, 2021-01-01 <num>, 2021-02-01 <num>, 2021-03-01 <num>, 2021-04-01 <num>, ...]

---

    Code
      df_cohort2
    Output
           cohort month_1    month_2   month_3   month_4   month_5   month_6
           <fctr>   <num>      <num>     <num>     <num>     <num>     <num>
       1:     All     100  18.770227 15.533981 13.915858 11.650485 10.679612
       2:  2020-1     100  20.000000 20.000000  6.666667  6.666667  6.666667
       3:  2020-2     100  14.285714  7.142857  7.142857  7.142857  7.142857
       4:  2020-3     100   5.882353  5.882353 11.764706  5.882353 11.764706
       5:  2020-4     100   7.142857  7.142857  7.142857  7.142857  7.142857
      ---                                                                   
      52:  2024-6     100 100.000000        NA        NA        NA        NA
      53:  2024-7     100  50.000000        NA        NA        NA        NA
      54:  2024-8     100         NA        NA        NA        NA        NA
      55: 2024-11     100 100.000000        NA        NA        NA        NA
      56: 2024-12     100         NA        NA        NA        NA        NA
      29 variable(s) not shown: [month_7 <num>, month_8 <num>, month_9 <num>, month_10 <num>, month_11 <num>, month_12 <num>, month_13 <num>, month_14 <num>, month_15 <num>, month_16 <num>, ...]

