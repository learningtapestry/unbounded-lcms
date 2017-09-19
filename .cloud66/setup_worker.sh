#!/usr/bin/env bash

# stop all existing
for file in `ls $STACK_PATH/tmp/pids/resque*pid`; do
  kill -QUIT `cat $file` &> /dev/null
  rm $file
done

init_workers ()
{
    COUNT=${WORKERS_COUNT:-20}

    for i in $(seq 1 $COUNT); do
      ( cd $STACK_PATH && PIDFILE=tmp/pids/resque-$i.pid BACKGROUND=yes QUEUES=default,low bundle exec rake resque:work ) &
    done
}

if [[ "$BACKGROUND_JOBS" == "1" ]]; then
    init_workers
fi
