require 'json'
require 'highline'
require 'net/ssh'
require_relative 'commands'

path = File.expand_path "../", __FILE__

# load configs
config = "deploy_config.json"
CONFIG = JSON.parse File.read config

puts "configs loaded:"
puts CONFIG
puts

HOST      = CONFIG["host"]
USER      = CONFIG["user"]
WEB_USER  = CONFIG["web_user"]

include Commands
