#!/bin/ash

TS=$(date "+%Y%m%d-%H%M%S")
HOST="nitro.turbodomain"
REMOTE_USER="inman"
REMOTE_DIR="/home/inman/aline-nuc"
KEYFILE="/root/.ssh/id_rsa"

lbu package > ${TS}.apkovl.tar.gz

ssh -i ${KEYFILE} ${REMOTE_USER}@${HOST} "mkdir -p \"$REMOTE_DIR\""

scp -i ${KEYFILE} ${TS}.apkovl.tar.gz ${REMOTE_USER}@${HOST}:${REMOTE_DIR}