require "doctordata/version"
require 'csv'
require 'roo'

module Doctordata
  class Parser
    class << self
      def from_csv_table(table)
        # there is much room to do performance tuning

        checked_table = table.by_col!.delete_if{ |k, v| k == nil || k == '' || k.start_with?('#') }
        table.by_row!
        checked_table.map do |row|
          row.
            reject { |k, v| v == nil || v == '' }
        end.
        map do |s|
          result = {}
          s.each do |k,v|
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

      def from_csv_path(path)
        table = CSV.read(path, headers: true)
        from_csv_table(table)
      end

      def from_csv_str(csv_str)
        table = CSV.parse(csv_str, :headers => true)
        from_csv_table(table)
      end

      def from_excel(file_or_path)
        xlsx = Roo::Spreadsheet.open(file_or_path, extension: :xlsx)
        hash = {}
        xlsx.each_with_pagename do |name, sheet|
          next if name == nil || name == '' || name.start_with?('#')
          csv_str = sheet.to_csv
          hash[name] = from_csv_str(csv_str)
        end
        hash
      end
    end
  end
end
