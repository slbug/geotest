# frozen_string_literal: true

module V1
  module GeoDatum
    class ShowAction < ::BaseAction

      def process
        geo_datum = ::GeoDatum.find_by(input: params[:input].strip)

        return fail_with(messages: 'GeoDatum not found', status: :not_found) if geo_datum.nil?

        success_with(data: { geo: geo_datum.data })
      end
    end
  end
end
