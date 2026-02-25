if Rails.env.test?
  Rails.application.config.host_authorization = { exclude: ->(_request) { true } }
end
