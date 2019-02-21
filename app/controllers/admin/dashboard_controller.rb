include HttpBasicAuthenticateHelper

class Admin::DashboardController < ApplicationController

  HttpBasicAuthenticateHelper.authenticate(self)

  def show
  end
end
