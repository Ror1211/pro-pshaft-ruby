require "propshaft/load_path"
require "propshaft/resolver/dynamic"
require "propshaft/resolver/static"
require "propshaft/server"
require "propshaft/processor"

class Propshaft::Assembly
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def load_path
    Propshaft::LoadPath.new(config.paths)
  end

  def resolver
    if (manifest_path = config.output_path.join(config.manifest_filename)).exist?
      Propshaft::Resolver::Static.new manifest_path: manifest_path, prefix: config.prefix
    else
      Propshaft::Resolver::Dynamic.new(load_path: load_path, prefix: config.prefix)
    end
  end

  def server
    Propshaft::Server.new(load_path)
  end

  def processor
    Propshaft::Processor.new \
      load_path: load_path, output_path: config.output_path,
      manifest_file_name: config.manifest_filename
  end
end
