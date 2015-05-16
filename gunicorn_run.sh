#!/bin/bash
PORT=8080

set -e
LOGFILE=/var/log/gunicorn/mlorant.log
LOGDIR=$(dirname $LOGFILE)
LOGLEVEL=debug   # debug, info or warning
NUM_CORES=nproc
let "NUM_WORKERS=2*$NUM_CORES+1"

# user/group to run as
USER=root
GROUP=root

cd /vagrant/toto/
test -d $LOGDIR || mkdir -p $LOGDIR
exec gunicorn_django -w $NUM_WORKERS \
  --user=$USER --group=$GROUP --log-level=$LOGLEVEL \
  --log-file=$LOGFILE 2>>$LOGFILE -b 127.0.0.1:$PORT
