#!/bin/sh

cd cadc-tap-server &&  ../gradlew --info clean build

cd cadc-tap-server-bigquery &&  ../gradlew --info clean build

cd tap-service-bigquery &&  ../gradlew --info clean build