#!/bin/bash

set -x

docker rm -f gitlab
 
rm -rf ./goof/.git
