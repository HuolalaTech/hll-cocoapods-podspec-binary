# frozen_string_literal: true

require 'active_support/core_ext/object/duplicable'

# Plugins/custom_plugin.rb

module Pod
  module Downloader
    # class
    class Request
      old_method = instance_method(:validate!)
      define_method(:validate!) do
        pod_name = MBuildConfig.instance.pod_name
        pod_version = MBuildConfig.instance.pod_version
        if spec.name == pod_name && spec.version.to_s == pod_version
          podspec_hash = spec.attributes_hash.deep_dup
          Pod::MbuildPodspec.new(podspec_hash).generate_podspec
        end
        old_method.bind(self).call
      end
    end
  end
end

# Returns a deep copy of hash.
class Object
  def deep_dup
    duplicable? ? dup : self
  end
end

# Returns a deep copy of Array.
class Array
  def deep_dup
    map(&:deep_dup)
  end
end

# Returns a deep copy of hash.
class Hash
  def deep_dup
    hash = dup
    each_pair do |key, value|
      if key.is_a?(::String) || key.is_a?(::Symbol)
        hash[key] = value.deep_dup
      else
        hash.delete(key)
        hash[key.deep_dup] = value.deep_dup
      end
    end
    hash
  end
end
