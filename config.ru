#!/usr/bin/env rackup

require_relative 'config/application'
require_relative 'config/environment'

use Broadsheet::Middleware
run Broadsheet
