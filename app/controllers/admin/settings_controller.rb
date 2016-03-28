module Admin
  class SettingsController < AdminController
    def toggle_editing_enabled
      current_value = Settings.editing_enabled?
      Settings.last.update_column(:editing_enabled, !current_value)
      notice = Settings.editing_enabled? ? t('.enabled') : t('.disabled')
      redirect_to :admin_resources, notice: notice
    end
  end
end
