# frozen_string_literal: true

module GeocoderHelper
  def stub_geocoder(params)
    Geocoder.configure(ip_lookup: :test)

    Geocoder::Lookup::Test.add_stub(
      '127.0.0.1',
      ['city' => params.dig(:city), 'country' => params.dig(:country)]
    )
  end
end
