# frozen_string_literal: true

require 'fileutils'

module Pod
  # generate podspec
  class MbuildPodspec
    def initialize(podspec_hash)
      @binary_type = MBuildConfig.instance.library_type == BinaryType::FRAMEWORK ? 'framework' : 'xcframework'
      @config_instance = MBuildConfig.instance
      @pod_name = MBuildConfig.instance.pod_name
      @pod_version = MBuildConfig.instance.pod_version
      @podspec_hash = podspec_hash
    end

    def generate_podspec
      binary_spec_version
      binary_spec_framework
      binary_spec_lib
      binary_spec_public_header_files
      binary_private_header_files
      write_podspec_to_file
    end

    private

    def write_podspec_to_file
      podspec_file = "#{Dir.pwd}/#{@pod_name}.podspec.json"
      podspec_json = JSON.pretty_generate(@podspec_hash)
      File.write(podspec_file, podspec_json)
    end

    def binary_spec_version
      @podspec_hash['version'] = @pod_version
    end

    def binary_spec_framework
      vendored_frameworks_array = []
      vendored_frameworks_array << "#{@pod_name}/*.#{@binary_type}"
      @podspec_hash['vendored_frameworks'] = vendored_frameworks_array
    end

    def binary_private_header_files
      return unless @podspec_hash['private_header_files']

      @podspec_hash['private_header_files'] =
        if @binary_type == 'xcframework'
          "#{@pod_name}/*.#{@binary_type}/ios-arm64/*.framework/privateHeaders/*.h"
        else
          "#{@pod_name}/*.#{@binary_type}/privateHeaders/*.h"
        end
    end

    def binary_spec_lib
      return unless @podspec_hash['libraries']

      @podspec_hash['libraries'] = Array(@podspec_hash['libraries'])
    end

    def binary_spec_public_header_files
      @podspec_hash.delete('default_subspecs') if @podspec_hash.key?('default_subspecs')
      @podspec_hash.delete('source_files') if @podspec_hash.key?('source_files')
      @podspec_hash.delete('public_header_files') if @podspec_hash.key?('public_header_files')
      @podspec_hash['public_header_files'] = "#{@pod_name}/Headers/*.h"
    end
  end
end
