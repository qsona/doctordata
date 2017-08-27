require "doctordata/version"
require 'csv'
require 'roo'
require 'faraday'
require 'pry'

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
          s.each do |k ,v|
            context = result
            subkeys = k.scan(/[^\[\]]+(?:\]?\[\])?/)
            subkeys.each_with_index do |subkey, i|
              if i+1 == subkeys.length
                context[subkey] = v
              else
                context[subkey] ||= {}
                context = context[subkey]
              end
            end
          end
          result
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
