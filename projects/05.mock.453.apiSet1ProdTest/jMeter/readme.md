# Example jMeter project to work with the first Mock

Example command to launch.

```bat
jmeter -Jsample_variables=flowMillis,measuredOverhead -n -t d:\tasks\2021\02.Feb\23\BPER\Test1.jmx -l d:\tasks\2021\02.Feb\23\BPER\Test1_2_19.csv
```

Passing the "sample_variables" allow to conserve in the output csv file the milliseconds measured by the mock itself.