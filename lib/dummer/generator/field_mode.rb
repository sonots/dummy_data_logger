module Dummer
  class Generator
    class FieldMode < AbstractMode
      def self.message_proc(fields, labeled, delimiter, label_delimiter)
        format_proc = format_proc(labeled, delimiter, label_delimiter)
        record_proc = record_proc(fields)

        Proc.new {
          hash = record_proc.call
          format_proc.call(hash)
        }
      end

      def self.record_proc(fields)
        field_procs = field_procs(fields)

        prev_data = {}
        Proc.new {
          data = {}
          field_procs.each do |key, proc|
            prev = prev_data[key] || -1
            data[key] = proc.call(prev)
          end
          prev_data = data
        }
      end

      def self.tag_proc(tag_opts)
        field_procs({"tag" => tag_opts})["tag"]
      end

      # private

      def self.format_proc(labeled, delimiter, label_delimiter)
        if labeled
          Proc.new {|fields| "#{fields.map {|key, val| "#{key}#{label_delimiter}#{val}" }.join(delimiter)}\n" }
        else
          Proc.new {|fields| "#{fields.values.join(delimiter)}\n" }
        end
      end

      def self.field_procs(fields)
        rand = ::Dummer::Random.new
        field_procs = {}
        fields.each do |key, opts|
          opts = opts.dup
          type = opts.delete(:type)
          field_procs[key] =
            case type
            when :string
              rand.string(opts)
            when :integer
              rand.integer(opts)
            when :float
              rand.float(opts)
            when :datetime
              rand.datetime(opts)
            else
              raise ConfigError.new("type: `#{type}` is not defined.")
            end
        end
        field_procs
      end
    end
  end
end
