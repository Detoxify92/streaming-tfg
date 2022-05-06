#!/bin/sh

_quit () {
  echo 'Caught sigquit, sending SIGQUIT to child';
  kill -s QUIT $child;
}

trap _quit SIGQUIT;

echo 'Starting child (nginx)';
/usr/local/nginx/nginx -g 'daemon off;' &
child=$!;

echo 'Waiting on child...';
wait $child;
