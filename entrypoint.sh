#!/bin/sh
echo "Waiting for elastic..."

while ! nc -z elasticsearch 9200; do
  sleep 0.1
done

echo "elastic started"

exec "$@"