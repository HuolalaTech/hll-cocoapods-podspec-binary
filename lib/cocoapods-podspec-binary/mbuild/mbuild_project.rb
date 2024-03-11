# frozen_string_literal: true

require 'cocoapods'

# Class prepare project
class BuildProject
  def initialize
    @config_instance = MBuildConfig.instance
    @project_dir = File.join(MBuildConfig.instance.mbuild_dir, 'BinaryProj')
  end

  def prepare_project
    example_dir = @project_dir
    if File.directory?(example_dir)
      Git.open(example_dir).reset_hard
      Git.open(example_dir).pull
    else
      MBuildFileUtils.create_folder(@project_dir)
      example_url = 'ssh://git@gitlab.huolala.cn:56358/group-wp-sdk/binary-example-ios.git'
      Git.clone(example_url, example_dir)
    end
  end

  def generate_project
    config_instance = MBuildConfig.instance
    add_build_settings if config_instance.swift
    update_podfile
    project_install
  end

  def update_podfile
    podfile_path = File.join(@project_dir, 'Podfile')
    podfile_content = File.read(podfile_path)
    pod_name = @config_instance.pod_name
    pod_version = @config_instance.pod_version
    new_content = podfile_content.gsub('BINARY_NAME', pod_name).gsub('BINARY_VERSION', pod_version).gsub(
      'cocoapods-mdapbox', 'cocoapods-podspec-binary'
    )
    new_content += "source \"#{@config_instance.sources}\"\n" if @config_instance.sources
    File.open(podfile_path, 'w') { |file| file.puts new_content }
  end

  def project_install
    Dir.chdir(@project_dir) do
      update_argv = []
      update_command = Pod::Command::Update.new(CLAide::ARGV.new(update_argv))
      update_command.run
    end
  end

  def add_build_settings
    File.open('Podfile', 'a+') do |podfile|
      podfile.puts build_settings_code
    end
  end

  def build_settings_code
    <<~CODE
      post_install do |installer|
        installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
          end
        end
      end
    CODE
  end
end
