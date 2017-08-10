#!/usr/bin/env bash

# stop all existing
for file in `ls $STACK_PATH/tmp/pids/resque*pid`; do
  kill -QUIT `cat $file` &> /dev/null
  rm $file
done

WORKERS_COUNT=4

for i in $(seq 1 $WORKERS_COUNT); do
  ( cd $STACK_PATH && PIDFILE=tmp/pids/resque-$i.pid BACKGROUND=yes QUEUE=* bundle exec rake resque:work ) &
done
