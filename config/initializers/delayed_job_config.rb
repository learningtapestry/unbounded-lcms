require 'delayed_job'

Delayed::Worker.max_run_time = 10.hours
