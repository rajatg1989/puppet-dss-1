class Hiera
  module Backend
    class Array_lookup_backend

      def initialize(cache=nil)
        Hiera.debug("Hiera array lookup backend starting")
        @cache = cache || Filecache.new
      end

      # a special hiera backend that just tries to resolve rescursive array lookups
      def lookup(key, scope, order_override, resolution_type)
        answer = nil
        Backend.datasourcefiles(:yaml, scope, "yaml", order_override) do |source, yamlfile|
          data = @cache.read_file(yamlfile, Hash) do |data|
            YAML.load(data) || {}
          end
          next if data.empty?
          next unless data.include?(key)
          if data[key] =~ /^%\{(lookup_array|lookup_array_first_element)\(['"]([^"']*)["']\)\}$/
            value = Hiera::Backend.lookup($2, nil, scope, nil, :priority)
            if value == nil
              answer = nil
              break
            else
              unless value.class == Array
                raise Exception, "Invalid value #{$2}=#{value.class}. Hiera lookup array methods expect an array value"
              end
              case $1
              when 'lookup_array'
                break if answer = value
              when 'lookup_array_first_element'
                break if answer = value.first
              end
            end
          elsif data[key] =~ /%\{(lookup_array|lookup_array_first_element)\(['"]([^"']*)["']\)\}/
            raise Exception, "Invalid lookup_array call: #{data[key]} Cannot interpolate array lookups."
          end
        end
        answer
      end
    end
  end
end
