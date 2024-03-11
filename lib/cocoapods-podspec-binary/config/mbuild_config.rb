# frozen_string_literal: true

require 'singleton'
require 'yaml'

# Plugin configuration
class MBuildConfig
  include Singleton

  attr_reader :mbuild_dir, :root_dir
  attr_accessor :pod_name, :pod_version, :swift, :sources, :library_type

  def initialize
    @root_dir = Dir.pwd
    @mbuild_dir = File.join(Dir.home, '.mbuild')
  end

  def load_config
    mbuild_yml = File.join(@root_dir, '.mbuild.yml')
    return unless File.file?(mbuild_yml)

    mbuild_params = YAML.load_file(mbuild_yml)
    validate_required_config(mbuild_params, 'pod_name', 'pod_version')
    @pod_name = mbuild_params['program']['pod_name']
    @pod_version = mbuild_params['program']['pod_version']
  end

  def command_config(pod_name, pod_version)
    @pod_name = pod_name
    @pod_version = pod_version
  end

  private

  def validate_required_config(data, *keys)
    raise ArgumentError, 'program is required in the configuration file.' unless data['program']

    config = data['program']
    keys.each do |key|
      raise ArgumentError, "#{key} is required in the configuration file." unless config[key]
    end
  end
end
