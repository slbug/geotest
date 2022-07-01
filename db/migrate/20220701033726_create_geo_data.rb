# frozen_string_literal: true

class CreateGeoData < ActiveRecord::Migration[7.0]
  def change
    create_table :geo_data do |t|
      t.string :input, null: false
      t.jsonb :data, null: false, default: '{}'

      t.timestamps
    end
  end
end
