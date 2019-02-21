module HttpBasicAuthenticateHelper
  def authenticate(controller)
      controller.http_basic_authenticate_with :name => ENV['HTTP_BASIC_AUTHENTICATE_USERNAME'], :password => ENV['HTTP_BASIC_AUTHENTICATE_PASSWORD']
  end
end
