class Users::BaseController < ApplicationController
  include Users::Authentication
  layout "student"
end
