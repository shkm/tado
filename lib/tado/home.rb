require 'tado/wrapper'

class Tado::Home < Tado::Wrapper
  def ensure_details!
    return unless _partially_loaded

    append_hash @client.get('homes', id).merge(partially_loaded: false)
  end

  alias_method :dateTimeZone, :attribute_with_details
  alias_method :temperatureUnit, :attribute_with_details
  alias_method :installationCompleted, :attribute_with_details
  alias_method :partner, :attribute_with_details
  alias_method :simpleSmartScheduleEnabled, :attribute_with_details
  alias_method :contactDetails, :attribute_with_details
  alias_method :address, :attribute_with_details
  alias_method :geolocation, :attribute_with_details
end
