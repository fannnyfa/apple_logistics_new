class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  before_action :authenticate_user!

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_users_path
    elsif resource.approved?
      collections_path
    else
      authenticated_root_path
    end
  end
end
