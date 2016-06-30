module WickedPdfHelper
  module Assets
    def find_asset(file)
      if Rails.env.development?
        Rails.application.assets.find_asset(file)
      else
        Rails.application.assets_manifest.assets[file]
      end
    end

    def fixed_wicked_pdf_asset_base64(path)
      asset = find_asset(path)
      throw "Could not find asset '#{path}'" if asset.nil?
      base64 = Base64.encode64(asset.to_s).gsub(/\s+/, '')
      "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
    end
  end
end
