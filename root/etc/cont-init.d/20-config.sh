#!/usr/bin/with-contenv bash

mkdir -p /downloads/default
touch /downloads/aria2.session

chown abc:abc /downloads
chown abc:abc /downloads/*
