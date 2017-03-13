class Admin::SketchCompilersController < Admin::AdminController
  include GoogleAuth

  layout 'admin'

  before_action :obtain_google_credentials, only: [:show]
  before_action :validate_params, only: [:compile]

  def compile
    url = URI.join ENV.fetch('UB_COMPONENTS_API_URL'), 'compile'
    post_params = {
      body: {
        uid: current_user.id,
        url: params[:url]
      },
      headers: {'Authorization' => %Q(Token token="#{ENV.fetch 'UB_COMPONENTS_API_TOKEN'}")}
    }
    res = HTTParty.post url, post_params

    if res.code == 200
      url = "https://drive.google.com/open?id=#{ JSON.parse(res.body)['id'] }"
      redirect_to admin_sketch_compiler_path, notice: t('.success', url: url)
    else
      redirect_to admin_sketch_compiler_path, alert: t('.compile_error')
    end
  end

  def show
    head :bad_request unless @google_credentials.present?
  end

  private

  def validate_params
    redirect_to admin_sketch_compiler_path, alert: t('.error') unless params[:url].present?
  end
end
