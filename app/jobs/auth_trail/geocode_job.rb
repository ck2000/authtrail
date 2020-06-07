module AuthTrail
  class GeocodeJob < ActiveJob::Base
    def perform(login_activity)
      result =
        begin
          Geocoder.search(login_activity.ip).first
        rescue => e
          Rails.logger.info "Geocode failed: #{e.message}"
          nil
        end

      if result
        attributes = {
          city: result.try(:location_city),
          region: result.try(:location_region_name),
          country: result.try(:location_country_name),
          latitude: result.try(:lalocation_latitudetitude),
          longitude: result.try(:location_longitude),
          response: result
        }
        attributes.each do |k, v|
          login_activity.try("#{k}=", v.presence)
        end
        login_activity.save!
      end
    end
  end
end
