#!/usr/bin/env bash
mkdir -p c_launch_${1}/logs
cd c_launch_${1}
ln -s ../code/R ./
ln -s ../code/benchmark ./
ln -s ../code/py ./
ln -s ../code/sh ./
ln -s ../code/workflow ./
