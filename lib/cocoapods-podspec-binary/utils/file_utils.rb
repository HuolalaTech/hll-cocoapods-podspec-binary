# frozen_string_literal: true

require 'zlib'

# FileUtils: A utility class for file operations.
class MBuildFileUtils
  def self.create_folder(folder_path)
    return if File.directory?(folder_path)

    begin
      Dir.mkdir(folder_path)
    rescue SystemCallError => e
      puts "Error creating folder: #{e.message}"
    end
  end

  def self.compress_file(input_file, output_file)
    File.open(input_file, 'rb') do |input|
      Zlib::GzipWriter.open(output_file) do |output|
        output.write(input.read)
      end
    end
  end
end
