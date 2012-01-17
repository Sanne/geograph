class ApplicationController < ActionController::Base
  protect_from_forgery
  include Madmass::AuthenticationHelper
  helper Madmass::ApplicationHelper
end
