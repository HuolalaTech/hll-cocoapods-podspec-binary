# frozen_string_literal: true

require 'cocoapods-podspec-binary/mbuild/mbuild_binary'
require 'cocoapods-podspec-binary/mbuild/mbuild_project'
require 'cocoapods-podspec-binary/config/mbuild_config'

module Pod
  class Command
    # This is an example of a cocoapods plugin adding a top-level subcommand
    # to the 'pod' command.
    #
    # You can also create subcommands of existing or new commands. Say you
    # wanted to add a subcommand to `list` to show newly deprecated pods,
    # (e.g. `pod list deprecated`), there are a few things that would need
    # to change.
    #
    # - move this file to `lib/pod/command/list/deprecated.rb` and update
    #   the class to exist in the the Pod::Command::List namespace
    # - change this class to extend from `List` instead of `Command`. This
    #   tells the plugin system that it is a subcommand of `list`.
    # - edit `lib/cocoapods_plugins.rb` to require this file
    #
    # @todo Create a PR to add your plugin to CocoaPods/cocoapods.org
    #       in the `plugins.json` file, once your plugin is released.
    #
    class MBuild < Command
      self.summary = 'Used to generate binaries via podspec'
      self.abstract_command = false
      self.command = 'mbuild'
      self.description = <<-DESC
          cocoapods binary plugin for iOS code precompilation, supports framework and xcframework
      DESC

      self.arguments = [
        CLAide::Argument.new('NAME', false)
      ]

      def initialize(argv)
        @framework = argv.flag?('framework', true)
        @xcframework = argv.flag?('xcframework', false)
        @pod_name = argv.shift_argument
        @pod_version = argv.shift_argument
        @config_instance = MBuildConfig.instance
        @build_dir = @config_instance.mbuild_dir
        @sources = argv.option('sources')
        super
      end

      def self.options
        [
          ['--framework', 'Used to generate the framework '],
          ['--xcframework', 'Used to generate the xcframework '],
          ['--sources=[sources]', 'The sources from which to pull dependent pods ']
        ].concat(super).reject { |(name, _)| name == 'name' }
      end

      def run
        prepare
        generate_project
        build_binary
        export_binary
      end

      def prepare
        init_config
        MBuildFileUtils.create_folder(@build_dir)
        Dir.chdir(@build_dir)
        BuildProject.new.prepare_project
      end

      def init_config
        mbuild_yml = File.join(Dir.pwd, '.mbuild.yml')
        if File.file?(mbuild_yml)
          @config_instance.load_config
        else
          @config_instance.command_config(@pod_name, @pod_version)
        end
        @config_instance.library_type = @xcframework ? BinaryType::XCFRAMEWORK : BinaryType::FRAMEWORK
        puts "Preparing to generate the binary version of #{@pod_name}:#{@pod_version}."
        return unless @sources

        @config_instance.sources = @sources
      end

      def generate_project
        BuildProject.new.generate_project
      end

      def build_binary
        puts "Commencing the build of #{@pod_name}:#{@pod_version}."
        project_dir = File.join(@build_dir, 'BinaryProj/Example')
        Dir.chdir(project_dir)
        binary_type = @xcframework ? BinaryType::XCFRAMEWORK : BinaryType::FRAMEWORK
        build_binary = BuildBinary.new(binary_type)
        build_binary.build
        puts "The successful build of the #{@pod_name}:#{@pod_version} #{@binary_type}."
      end

      def export_binary
        puts 'Exporting binary files.'
        export_dir = @config_instance.root_dir
        FileUtils.cp_r("#{@build_dir}/#{@pod_name}-#{@pod_version}", export_dir)
        FileUtils.rm_rf("#{@build_dir}/#{@pod_name}-#{@pod_version}")
        puts 'Task execution completed.'
      end
    end
  end
end
