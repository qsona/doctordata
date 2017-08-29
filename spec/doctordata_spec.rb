require 'spec_helper'
require 'doctordata'
require 'csv'


RSpec.describe Doctordata do
  let(:csv_str){ "keyA,#commentB,keyC[0],keyC[1]\na1,b1,c11,c12\na2,b2,c21,c22\n" }
  let(:csv_table){ CSV.parse(csv_str, :headers => true)}

  describe 'Doctordata' do
    it "has a version number" do
      expect(Doctordata::VERSION).not_to be nil
    end
  end
  describe 'from_csv_table' do
    subject do
      Doctordata::Parser.from_csv_table(csv_table)
    end
    context 'with valid csv_table' do
      it "returns correct json" do
        expect(subject).to eq [{"keyA"=>"a1", "keyC"=>["c11", "c12"]}, {"keyA"=>"a2", "keyC"=>["c21", "c22"]}]
      end

      it "doesn't raise error" do
        expect { subject }.to_not raise_error
      end
    end
  end
end
