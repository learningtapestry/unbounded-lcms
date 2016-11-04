module FilesLoader
  # Module specific extensions for the Loader
  module Extensions
    # build an Extension instance based on the name
    def self.build(extension_name, loader)
      extension = ext_map.fetch(extension_name.to_sym).new(loader)
    end

    # extensions Class map
    def self.ext_map
      @ext_map ||= {
        ela_g12_lc: ELA_G12_LC,
        ela_g12_em: ELA_G12_EM,
      }
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

      def remove_zip_folders_from_units(grade_breadcrumb, module_short_title)
        # Remove zip folders from LC units
        grade = Curriculum.trees.find_by(breadcrumb_short_title: grade_breadcrumb)
        mod = grade.children.select { |c| c.resource.short_title =~ module_short_title }.first

        mod.children.each do |c| # for every unit
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

    # Extension for ELA Grade 12 Literary Criticism Module
    class ELA_G12_LC < ModuleExt
      def before_process
        remove_zip_folders_from_units 'EL / G12', /literary criticism/i
      end
    end

    # Extension for ELA Grade 12 Extension Module
    class ELA_G12_EM < ModuleExt
      def before_process
        remove_zip_folders_from_units 'EL / G12', /extension module/i
      end
    end
  end
end
