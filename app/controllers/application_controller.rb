class ApplicationController < ActionController::Base
  include Pagy::Backend
  include DeviseBaseController
  ActiveSupport.run_load_hooks(:devise_failure_app, self)

  private

  def render_unauthorized
    render status: :unauthorized
  end
end
