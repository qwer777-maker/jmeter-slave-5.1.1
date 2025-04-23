#!/bin/bash

JMETER_VERSION=${JMETER_VERSION:-"5.1.1"}
IMAGE_TIMEZONE=${IMAGE_TIMEZONE:-"Asia/Shanghai"}

# Example build line

docker build  --build-arg JMETER_VERSION=${JMETER_VERSION} --build-arg TZ=${IMAGE_TIMEZONE} -t "jmeter-slave:${JMETER_VERSION}" .
