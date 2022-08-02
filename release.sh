#!/bin/sh
# $1 = Semver Version (x.x.x)
sed "s/version: \(.*\)/version: $1/" shard.yml | tee shard.yml
sed "s/version: \(.*\)/version: $1/" README.md | tee README.md
git add shard.yml
git add README.md
git commit -m "release: $1"
