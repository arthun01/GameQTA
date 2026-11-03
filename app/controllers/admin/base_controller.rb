class Admin::BaseController < ApplicationController
  include Authentication
  layout "admin"
  before_action { response.headers["Cache-Control"] = "no-store" }
end
