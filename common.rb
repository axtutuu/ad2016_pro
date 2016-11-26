
require 'active_support'
require 'active_support/core_ext'
require "active_record"
require "mysql2"
require "dotenv"
Dotenv.load

# DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('db/config.yml')
ActiveRecord::Base.establish_connection(:development)

# model
Dir.glob("./model/*") { |file| require file }

# debug
require 'pry'

# common

require "yaml"
require 'json'
