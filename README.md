# TempViz app

A quick Shiny app to visualize the temperature records from POL-EKO incubators.

To launch and run the app, you must have `ggplot2` `shiny` and `shinyTime` installed. You can install them like so :

```r
install.packages(c("ggplot2", "shiny", "shinyTime"))
```

Then, simply type the following in a R console :

```r
shiny::runGitHub("TempViz", "Romain-B")
```

Or you can also clone/download the git repo and do this :

```r
shiny::runApp("path/to/repo")
```


Once you have the app running, upload your temperature record `.csv` file and customize your plot as needed.





### Example input file

```
sep=;
ST 2 SMART; ST0XXXXXXX

date; temp.; status; Doors
2020.01.20 12:50; 16.90; wait; false
2020.01.20 12:50; 16.90; ramp; false
2020.01.20 13:00; 20.91; ramp; false
2020.01.20 13:10; 23.31; ramp; false
2020.01.20 13:20; 25.05; set temp.; false
2020.01.20 13:30; 25.69; set temp.; false
```
