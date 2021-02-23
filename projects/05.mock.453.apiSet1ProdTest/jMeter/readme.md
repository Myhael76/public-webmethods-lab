# Example jMeter project to work with the first Mock

Example command to launch.

```bat
jmeter -Jsample_variables=flowMillis,measuredOverhead -n -t Test1.jmx -l Test1_2_19.csv
```

Passing the "sample_variables" allow to conserve in the output csv file the milliseconds measured by the mock itself.
