require 'fileutils'
module Oneoff
  class Issue6
    attr_reader :root_folder, :gdrive_ids

    def initialize
      @root_folder = ENV.fetch('ROOT_FOLDER')
      @gdrive_ids = {}

      raise unless File.directory?(root_folder)
    end

    def run
      Curriculum.trees.with_resources.order(:hierarchical_position).each do |item|
        key = build_key(item)
        parents = item.ancestors.map { |parent| gdrive_ids.fetch(build_key(parent)) }
        puts "------\n#{key}  => #{parents.inspect}"
        gdrive_ids[key] = add_folder(item, parents)
      end
    end

    def build_key(item)
      if item.breadcrumb_short_title.end_with?(item.breadcrumb_short_piece)
        item.breadcrumb_short_title
      else
        item.breadcrumb_short_title + item.breadcrumb_short_piece
      end
    end

    def add_folder(item, parents)
      fname = item.resource.short_title
      path = File.join(root_folder, parents.reverse, fname)
      puts "F: #{path}"
      FileUtils.mkdir(path)

      fname  #gdrive id
    end
  end
end
