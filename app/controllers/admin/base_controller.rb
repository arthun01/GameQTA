class Admin::BaseController < ApplicationController
  include Authentication
  layout "admin"
end
