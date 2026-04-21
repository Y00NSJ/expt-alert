# expt-alert
a shell-based utility for running Python experiments with automatic log capture and Slack notifications

## What It Does
1. executes the target Python script with its arguments
    - redirects all console output to a log file; with either a specified path or an auto-generated filename
    - records the start and end times
    - checks whether the run succeeded or failed
2. sends a Slack notification through an incoming webhook
    - includes the last part of the log in the Slack message if the run fails.

## Usage
```run_exp.sh [-l logfile] <script.py> [python args...]```

or you can also add an alias for convenience:
1. `echo alias rexp="run_exp.sh" >> .bashrc; source ~/.bashrc`
2. ```rexp [-l logfile] <script.py> [python args...]```


## Preview
|Success|Fail|
|---|---|
|<img width="289" height="203" alt="success" src="https://github.com/user-attachments/assets/3922afe6-a573-4273-9f4e-da5ec3a3bf63" />|<img width="898" height="157" alt="fail" src="https://github.com/user-attachments/assets/02d23891-16ea-4385-82f2-81d0c7e545e2" />



