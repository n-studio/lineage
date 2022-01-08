require "active_support/concern"

module DeviseBaseController
  extend ActiveSupport::Concern

  included do
    before_action :store_user_location!, if: :storable_location?
    before_action :configure_permitted_parameters, if: :devise_controller?

    # https://github.com/plataformatec/devise/blob/master/README.md#controller-filters-and-helpers
    protect_from_forgery prepend: true
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  def after_sign_out_path_for(_resource_or_scope)
    request.referer
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:display_name, :email, :password) }
  end
end
