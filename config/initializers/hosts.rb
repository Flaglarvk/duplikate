# frozen_string_literal: true
env = Rails.env
host = env.development? ? 'localhost:3000' : ENV.fetch('HOST', 'qul.tarteel.io')

Rails.application.configure do
  hosts = [/.zeet-tarteel.zeet.app/, 'qul.tarteel.ai', 'qul.tarteel.io', 'localhost']
  config.hosts += hosts
  config.action_cable.allowed_request_origins = hosts

=begin
  config.action_dispatch.default_headers = {
    'Access-Control-Allow-Origin' => '*',
    'X-Forwarded-Proto' => 'https'
  }
=end

  if env.production? || env.staging?
    config.action_mailer.default_url_options = {
      host: host,
      protocol: 'https'
    }
  end
end

Rails.application.routes.default_url_options = {
  host: host,
  protocol: 'https'
}

