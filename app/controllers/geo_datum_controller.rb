# frozen_string_literal: true

class GeoDatumController < ::ApplicationController
  proxy_actions(actions: %i[show create destroy], namespace: ::V1::GeoDatum)
end
