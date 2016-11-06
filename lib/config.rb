class Config
  def initialize(file)
    @file = file
    fail "Config file #{file} is not found" unless config_exists?
  end

  def parse
    return {} unless data
    data.deep_symbolize_keys
  end

  private

  def data
    @data ||= YAML.load_file(file)
  end

  def config_exists?
    File.readable?(file)
  end

  def file
    "#{File.dirname(File.dirname(__FILE__))}/config/#{@file}.yml"
  end
end
