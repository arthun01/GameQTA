module ActiveSupport
  module JSON
    class << self
      alias_method :original_decode, :decode
      def decode(json, options = {})
        data = ::JSON.parse(json, **(options || {}))

        if ActiveSupport.parse_json_times
          convert_dates_from(data)
        else
          data
        end
      end
    end
  end
end
