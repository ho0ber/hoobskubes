#!/bin/bash

gem build hoobskubes.gemspec
gem install hoobskubes-*.gem
rm hoobskubes-*.gem
