module Tado::Auth
  AUTH_FILEPATH = "#{Dir.home}/.tado_auth".freeze
  AUTH_CLIENT_ID = 'tado-web-app'.freeze
  AUTH_GRANT_TYPE = 'password'.freeze
  AUTH_SCOPE = 'home.user'.freeze

  def auth_token(base_uri)
    return auth['access_token'] unless auth_expired?

    authorize(base_uri)
  end

  def authorize(base_uri)
    response = Net::HTTP.post_form(URI("#{base_uri}oauth/token"),
                                   client_id: AUTH_CLIENT_ID,
                                   client_secret: 'wZaRN7rpjn3FoNyF5IFuxg9uMzYJcvOoQ8QWiIqS3hfk6gLhVlG57j5YNoZL2Rtc',
                                   grant_type: AUTH_GRANT_TYPE,
                                   scope: AUTH_SCOPE,
                                   username: @username,
                                   password: @password)

    @auth = JSON.parse(response.body)
    @auth_expiry = nil

    write_auth

    @auth['access_token']
  end

  def auth_expired?
    return true unless auth_exists?
    return true if Time.now >= auth_expires_at

    false
  end

  def auth_expires_at
    @auth_expiry ||= (File.mtime(AUTH_FILEPATH) + auth['expires_in'].to_i)
  end

  def auth
    @auth ||= JSON.parse(File.read(AUTH_FILEPATH))
  end

  def auth_exists?
    File.exist?(AUTH_FILEPATH)
  end

  def write_auth
    File.open(AUTH_FILEPATH, 'w') { |file| file.write(JSON.dump(@auth)) }
  end
end
