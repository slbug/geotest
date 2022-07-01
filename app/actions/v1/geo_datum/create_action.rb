# frozen_string_literal: true

module V1
  module GeoDatum
    class CreateAction < ::BaseAction
      private

      def process
        input = params[:input].strip

        ip = ip_from_input(input)

        return fail_with(messages: 'Invalid input') if ip.nil?

        geo_data = ::GeoDatum.create(
          input: input,
          data: Geocoder.search(ip).first.data
        )

        return fail_with_validation(geo_data) if geo_data.invalid?

        success_with(data: { geo: geo_data.data })
      end

      def ip_from_input(input)
        case input
        when Resolv::IPv4::Regex, Resolv::IPv6::Regex
          input
        else
          ip_from_hostname(input)
        end
      end

      def ip_from_hostname(input)
        input = "http://#{input}" if URI.parse(input).scheme.nil?
        uri = URI.parse(input).host&.downcase
        return nil if uri.nil?

        Resolv.getaddress(uri)
      rescue Resolv::ResolvError
        nil
      end
    end
  end
end
