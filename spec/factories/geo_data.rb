# frozen_string_literal: true

FactoryBot.define do
  factory :geo_datum do
    input { '1.1.1.1' }
    data { JSON.parse('{"lat":"13.9783617","lon":"44.1657363"}') }
  end
end
