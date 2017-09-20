#!/usr/bin/env bash

mkdir -p $STACK_BASE/shared/google
chown cloud66-user:cloud66-user $STACK_BASE/shared/google
ln -nsf $STACK_BASE/shared/google $STACK_PATH/config/google
