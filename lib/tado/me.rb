require 'tado/wrapper'
require 'tado/home'
require 'tado/mobile_device'

class Tado::Me < Tado::Wrapper
  def homes
    super.map do |home_data|
      wrap Tado::Home, home_data.to_h.merge(_partially_loaded: true)
    end
  end
end
