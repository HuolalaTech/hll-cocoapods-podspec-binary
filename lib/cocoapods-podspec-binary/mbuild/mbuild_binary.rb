# frozen_string_literal: true

# Build binary types enumeration
module BinaryType
  FRAMEWORK = 'framework'
  XCFRAMEWORK = 'xcframework'
  STATIC_LIBRARY = 'static_library'
end

# Class build framework
class BuildBinary
  def initialize(binary_type)
    @config_instance = MBuildConfig.instance
    @binary_type = binary_type
    @pod_name = @config_instance.pod_name
    @pod_version = @config_instance.pod_version
  end

  def build
    clean
    Dir.chdir('Pods') do
      build_iphoneos_framework
      build_iphonesimulator_framework
    end
    framework = create_universal_framework
    generate_final_binary(framework)
    generate_cache_file
  end

  def clean
    binary_dir = "#{@config_instance.mbuild_dir}/#{@pod_name}"
    FileUtils.rm_rf(binary_dir) if Dir.exist?(binary_dir)
    clean_cmd = 'xcodebuild clean'
    system clean_cmd
  end

  def build_iphoneos_framework
    build_cmd = "xcodebuild build -target #{@pod_name} -sdk iphoneos -arch arm64 -quiet"
    system build_cmd
  end

  def build_iphonesimulator_framework
    build_cmd = "xcodebuild build -target #{@pod_name} -sdk iphonesimulator -arch x86_64 -quiet"
    system build_cmd
  end

  def create_universal_framework
    iphoneos_framework = "./build/Release-iphoneos/#{@pod_name}/#{@pod_name}.framework"
    simulator_framework = iphoneos_framework.gsub('iphoneos', 'iphonesimulator')
    if @binary_type == BinaryType::FRAMEWORK
      build_framework(iphoneos_framework, simulator_framework)
    else
      build_xcframework(iphoneos_framework, simulator_framework)
    end
    iphoneos_framework.gsub("#{@pod_name}.framework", '')
  end

  def generate_final_binary(framework)
    binary_dir = "#{@config_instance.mbuild_dir}/#{@pod_name}"
    Dir.mkdir(binary_dir) unless Dir.exist? binary_dir
    FileUtils.cp_r(framework, binary_dir)
    podspec_file = "#{Dir.pwd}/#{@pod_name}.podspec.json"
    FileUtils.cp_r(podspec_file, binary_dir)
  end

  def generate_cache_file
    binary_dir = "#{@config_instance.mbuild_dir}/#{@pod_name}/Podfile.lock"
    FileUtils.cp_r("#{@config_instance.mbuild_dir}/project/Podfile.lock", binary_dir)
  end

  private

  def build_framework(iphoneos_framework, simulator_framework)
    iphoneos_binary = "#{iphoneos_framework}/#{@pod_name}"
    output_framework = iphoneos_binary
    simulator_binary = "#{simulator_framework}/#{@pod_name}"
    lipo_cmd = "ipo -create #{iphoneos_binary} #{simulator_binary} -output #{output_framework}"
    system lipo_cmd
    output_framework
  end

  def build_xcframework(iphoneos_framework, simulator_framework)
    output_xcframework = iphoneos_framework.gsub('.framework', '.xcframework')
    xcbuild = "xcodebuild -create-xcframework -framework #{iphoneos_framework}"
    build_xcframework = "#{xcbuild} -framework #{simulator_framework} -output #{output_xcframework}"
    system build_xcframework
    output_xcframework
  end
end
