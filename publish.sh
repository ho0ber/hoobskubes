#!/bin/bash

gem build hoobskubes.gemspec
gem push hoobskubes-*.gem
rm hoobskubes-*.gem
