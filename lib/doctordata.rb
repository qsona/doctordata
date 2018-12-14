require "doctordata/version"
require 'csv'
require 'roo'

module Doctordata
  class Parser
    class << self
      def from_csv_table(table, options = {})
        # there is much room to do performance tuning
        table.map do |s|
          result = {}
          s.each do |k, v|
            next if k == nil || k == '' || k.start_with?('#')
            v = nil if v == ''
            context = result
            subkeys = k.scan(/[^\[\]]+(?:\]?\[\])?/)
            subkeys.each_with_index do |subkey, i|
              if i+1 != subkeys.length
                value_type = Hash
                if context[subkey] && !context[subkey].is_a?(value_type)
                  raise TypeError, "expected %s (got %s) for param `%s'" % [
                      value_type.name,
                      context[subkey].class.name,
                      subkey
                  ]
                end
                context = (context[subkey] ||= value_type.new)
              else
                context[subkey] = v
              end
            end
          end
          dehash(result, 0)
        end
      end

      def dehash(hash, depth)
        hash.each do |key, value|
          hash[key] = dehash(value, depth + 1) if value.kind_of?(Hash)
        end

        if depth > 0 && !hash.empty? && hash.keys.all? { |k| k =~ /^\d+$/ }
          hash.keys.sort.inject([]) { |all, key| all << hash[key] }
        else
          hash
        end
      end

      def from_csv_path(path, options = {})
        json_str = File.read(path)
        from_csv_str(json_str, options)
      end

      def from_csv_str(csv_str, options = {})
        skip_lines_number = options[:skip_lines_number]&.to_i || 0
        arr = CSV.parse(csv_str)
        headers = arr[skip_lines_number]
        return [] if headers.nil?
        rows = arr[(skip_lines_number+1)..-1].map { |row| CSV::Row.new(headers, row) }
        table = CSV::Table.new(rows)
        from_csv_table(table)
      end

      def from_excel(file_or_path, options = {})
        xlsx = Roo::Spreadsheet.open(file_or_path, extension: :xlsx)
        hash = {}
        xlsx.each_with_pagename do |name, sheet|
          next if name == nil || name == '' || name.start_with?('#')
          csv_str = sheet.to_csv
          hash[name] = from_csv_str(csv_str, options)
        end
        hash
      end

      def from_table(array)
        headers = array[0]
        row_array = array[1..-1].map { |row| CSV::Row.new(headers, row) }
        table = CSV::Table.new(row_array)
        from_csv_table(table)
      end

      def from_table_hash(hash)
        new_hash = {}
        hash.each do |k, v|
          new_hash[k] = from_table(v)
        end
        new_hash
      end
    end
  end
end
