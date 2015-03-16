require 'yaml'
require 'erubis'
require 'fileutils'
require 'pathname'

module ARTest
  class << self
    def config
      @config ||= read_config
    end

    private

    def config_file
      Pathname.new(ENV['ARCONFIG'] || TEST_ROOT + '/config.yml')
    end

    def read_config
      expand_config(YAML.load_file(config_file))
    end

    def expand_config(config)
      config['connections'].each do |adapter, connection|
        dbs = [['arunit', 'activerecord_unittest'], ['arunit2', 'activerecord_unittest2']]
        dbs.each do |name, dbname|
          connection[name]['database'] ||= dbname
          connection[name]['adapter']  ||= adapter
        end
      end

      config
    end
  end
end
