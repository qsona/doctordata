require "doctordata/version"
require 'csv'
require 'roo'
require 'faraday'

module Doctordata
  class Parser
    class << self
      def from_csv_table(table)
        # there is much room to do performance tuning
        table.
          map do |row|
            row.
              reject { |k, v| v == nil || v == '' }.
              reject { |k, v| k.start_with?('#') }.
              map { |k, v| "#{k}=#{v}" }.
              join('&')
          end.
          map { |s| Faraday::NestedParamsEncoder.decode(s) }
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
          csv_str = sheet.to_csv
          hash[name] = from_csv_str(csv_str)
        end
        hash
      end
    end
  end
end
