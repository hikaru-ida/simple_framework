# coding: utf-8
require 'yaml'
require 'erb'
require 'sequel'
ROUTES = YAML.load(File.read(File.join(File.dirname(__FILE__), "app", "routes.yml"))) # 1

db_config_file = File.join(File.dirname(__FILE__), "app", "database.yml")
if File.exist?(db_config_file)
  config = YAML.load(File.read(db_config_file))
  DB = Sequel.connect(config)
  Sequel.extension :migration
end
p DB

Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|file| require file }
Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each {|file| require file }
if DB
  Sequel::Migrator.run(DB, File.join(File.dirname(__FILE__), 'app', 'db', 'migrations'))
end

require "./lib/router"

class SimpleApp
  attr_reader :router

  def initialize
    @router = Router.new(ROUTES)
  end
  def call(env)
    result = router.resolve(env)
    [result.status, result.headers, result.content]
  end

  def self.root
    File.dirname(__FILE__)
  end
end
