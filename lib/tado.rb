require 'net/http'
require 'json'

require 'tado/auth'
require 'tado/me'
require 'tado/home'

class Tado::Client
  include Tado::Auth

  AUTH_BASE_URI = 'https://auth.tado.com/'.freeze
  BASE_URI = 'https://my.tado.com/'.freeze
  API_BASE_URI = "#{BASE_URI}api/v2/".freeze

  attr_writer :home_id

  def initialize(username: nil, password: nil, home_id: nil)
    raise ArgumentError if username.nil? || password.nil?

    @username = username
    @password = password
    @home_id = home_id
  end

  def me
    wrap Tado::Me, 'me'
  end

  def home(home_id: @home_id)
    wrap Tado::Home, 'homes', home_id
  end

  def weather(home_id: @home_id)
    wrap Tado::Wrapper, 'homes', home_id, 'weather'
  end

  def zones(home_id: @home_id)
    wrap_array Tado::Wrapper, 'homes', home_id, 'zones'
  end

  def zone_state(home_id: @home_id, zone: 1)
    wrap Tado::Wrapper, 'homes', home_id, 'zones', zone, 'state'
  end

  def devices(home_id: @home_id)
    wrap_array Tado::Wrapper, 'homes', home_id, 'devices'
  end

  def get(*path)
    uri = construct_uri(path)
    response = request_with_auth(uri)

    JSON.parse(response.body)
  end

  private

  def wrap(klass, *path)
    klass.new self, get(path)
  end

  def wrap_array(klass, *path)
    get(path).map do |entry|
      klass.new self, entry
    end
  end

  def request_with_auth(uri)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{auth_token(AUTH_BASE_URI)}"

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  def construct_uri(*path)
    URI("#{API_BASE_URI}#{path.join('/')}")
  end
end
