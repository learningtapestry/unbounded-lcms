#!/usr/bin/env bash

PIDFILE=$STACK_PATH/tmp/pids/resque.pid

if [ -f "$PIDFILE" ]; then
    kill -s QUIT `cat ${PIDFILE}`
fi

cd $STACK_PATH && RAILS_ENV=development PIDFILE=${PIDFILE} BACKGROUND=yes QUEUE=* bundle exec rake resque:work
