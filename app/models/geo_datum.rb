# frozen_string_literal: true

class GeoDatum < ApplicationRecord
  validates :input, presence: true, uniqueness: true
end
