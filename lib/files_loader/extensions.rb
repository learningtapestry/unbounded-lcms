module FilesLoader
  # Module specific extensions for the Loader
  module Extensions
    # build an Extension instance based on the name
    def self.build(extension_name, loader)
      extension = ext_map.fetch(extension_name).new(loader)
    end

    # extensions Class map
    def self.ext_map
      @ext_map ||= {
        ela_g12_lc: ELA_G12_LC,
      }.with_indifferent_access
    end

    # Base Module Extension
    class ModuleExt
      attr_reader :loader

      def initialize(loader)
        @loader = loader
      end

      def before_process
      end

      # remove all downloads from a resource
      def remove_all_downloads(resource)
        ResourceDownload.where(resource_id: resource.id).delete_all if resource
      end
    end

    # Extension for ELA Grade 12 Literary Criticism Module
    class ELA_G12_LC < ModuleExt
      def before_process
        # Remove zip folders from LC units
        breadcrumb = 'EL / G12 / LC'
        curr = Curriculum.trees.find_by(breadcrumb_short_title: breadcrumb)

        curr.children.each do |c| # for every unit
          rds = c.resource.resource_downloads.select do |rd|
            if is_zip = rd.download.title.match(/zip folder/i)
              loader.csv(
                curriculum_id: c.id,
                resource_id: c.resource.id,
                resource_title: c.resource.title,
                action: 'remove',
                filename: rd.download['filename']
              )
            end
            is_zip
          end

          ResourceDownload.where(id: rds.map(&:id)).delete_all if rds.present?
        end
      end
    end
  end
end
