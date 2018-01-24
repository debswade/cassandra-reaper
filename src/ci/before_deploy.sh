#!/bin/bash

echo "Starting Before Deploy step..."

set -xe
if [ "${TRAVIS_BRANCH}" = "push-master-releases" -a "${CASSANDRA_VERSION}" = "2.1.19" -a "x${GRIM_MIN}" = "x" ]
then
    git config --global user.email "builds@travis-ci.com"
    git config --global user.name "Travis CI"
    git tag -d master-snapshot || echo "no pre existing master-snapshot tag"
    git tag master-snapshot -a -m "Generated tag from TravisCI for build $TRAVIS_BUILD_NUMBER [skip ci]"
    mkdir cassandra-reaper-master
    mkdir cassandra-reaper-master/server
    mkdir cassandra-reaper-master/server/target
    cp -R src/packaging/bin cassandra-reaper-master/
    cp src/server/target/cassandra-reaper-*.jar cassandra-reaper-master/server/target
    cp -R src/packaging/resource cassandra-reaper-master/
    tar czf cassandra-reaper-master-release.tar.gz cassandra-reaper-master/
    docker-compose -f src/packaging/docker-build/docker-compose.yml build > /dev/null
    docker-compose -f src/packaging/docker-build/docker-compose.yml run build > /dev/null
else
    mkdir cassandra-reaper-${TRAVIS_TAG}
    mkdir cassandra-reaper-${TRAVIS_TAG}/server
    mkdir cassandra-reaper-${TRAVIS_TAG}/server/target
    cp -R src/packaging/bin cassandra-reaper-${TRAVIS_TAG}/
    cp src/server/target/cassandra-reaper-*.jar cassandra-reaper-${TRAVIS_TAG}/server/target
    cp -R src/packaging/resource cassandra-reaper-${TRAVIS_TAG}/
    tar czf cassandra-reaper-${TRAVIS_TAG}-release.tar.gz cassandra-reaper-${TRAVIS_TAG}/
    docker-compose -f src/packaging/docker-build/docker-compose.yml build > /dev/null
    docker-compose -f src/packaging/docker-build/docker-compose.yml run build > /dev/null
fi