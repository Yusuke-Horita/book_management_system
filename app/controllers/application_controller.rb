class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :configure_permitted_parameters, if: :devise_controller?

	def after_sign_in_path_for(resource)
		case resource
		when Admin
			admins_books_path
		when User
			root_path
		else
			super
		end
	end

	def after_sign_out_path_for(resource)
		case resource
		when Admin, :admin, :admins
			new_admin_session_path
		when User, :user, :users
			new_user_session_path
		else
			super
		end
	end

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
	end
end
