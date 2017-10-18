#!/bin/bash
RACK_ENV=production 
RUBYOPT=-EUTF-8
bundle exec thin -s 1 -C thin.yml -R config.ru start
