class Sunrise::BaseController < ActionController::Base
  layout 'application'

  around_action :switch_locale
  before_action :set_device_type, :store_location, :check_domain, :store_first_visit_date
  helper_method :show_install_app_popup?

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def set_device_type
    request.variant = :phone if request_from_mobile?
  end

  def request_from_mobile?
    browser.device.mobile?
  end

  def store_location
    return unless request.get?
    return if params[:controller].in?(%i[sessions passwords registrations])

    path = request.fullpath
    session[:previous_url] = path
  end

  def after_login_or_signup_path
    return admin_index_path if current_user.admin?
    session[:previous_url] || root_path
  end

  def check_domain
    return unless Rails.env.production?

    redirect_to "https://#{ENV['DOMAIN']}" unless request.ssl?
    redirect_to "https://#{ENV['DOMAIN']}" unless request.host == ENV['DOMAIN']
  end

  def store_first_visit_date
    session[:first_visit] = DateTime.now if session[:first_visit].blank?
  end

  def show_install_app_popup?
    return if install_app_popup_shown?

    if (session[:first_visit].to_time + 1.hours) < DateTime.now
      session[:install_app_popup_shown] = true
    end
  end

  def install_app_popup_shown?
    session[:install_app_popup_shown]
  end
end
