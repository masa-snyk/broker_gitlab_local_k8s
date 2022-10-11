#!/bin/bash

set -x

kind create cluster --name dc1 --config kind.yaml
