require 'net/http'
require 'json'

class Tado
  BASE_URI = 'https://my.tado.com/'.freeze
  AUTH_URI = "#{BASE_URI}oauth/token".freeze
  API_BASE_URI = "#{BASE_URI}api/v2/".freeze

  AUTH_FILEPATH = "#{Dir.home}/.tado_auth".freeze
  AUTH_CLIENT_ID = 'tado-webapp'.freeze
  AUTH_GRANT_TYPE = 'password'.freeze
  AUTH_SCOPE = 'home.user'.freeze

  attr_writer :home_id

  def initialize(username:, password:, home_id: nil)
    @username = username
    @password = password
    @home_id = home_id
  end

  def me
    get('me')
  end

  def home(home_id = @home_id)
    get ['homes', home_id].join('/')
  end

  def weather(home_id = @home_id)
    get ['homes', home_id, 'weather'].join('/')
  end

  def zones(home_id = @home_id)
    get ['homes', home_id, 'zones'].join('/')
  end

  def zone_state(home_id = @home_id, zone = 1)
    get ['homes', home_id, 'zones', zone, 'state'].join('/')
  end

  private

  def get(path)
    uri = URI("#{API_BASE_URI}#{path}")

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{auth_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def auth_token
    return auth['access_token'] unless auth_expired?

    authorize
  end

  def authorize
    response = Net::HTTP.post_form(URI(AUTH_URI),
                                   client_id: AUTH_CLIENT_ID,
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
