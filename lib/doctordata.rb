require "doctordata/version"
require 'csv'
require 'faraday'

module Doctordata
  class Parser
    class << self
      def from_csv_table(table)
        # there is much room to tuning performance
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

      def from_csv_filepath(path)
        table = CSV.read(path, headers: true)
        from_csv_table(table)
      end
    end
  end
end
