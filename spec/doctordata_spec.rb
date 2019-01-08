require 'spec_helper'
require 'doctordata'
require 'csv'


RSpec.describe Doctordata do
  let(:csv_str){ "keyA,#commentB,keyC[0],keyC[1]\na1,b1,c11,c12\n,,,\na2,b2,c21,c22,ignored\n,b3,c31,c32\n,,," }
  let(:csv_table){ CSV.parse(csv_str, :headers => true)}
  let(:result){ [{"keyA"=>"a1", "keyC"=>["c11", "c12"]}, {"keyA"=>"a2", "keyC"=>["c21", "c22"]}, {"keyA"=>nil, "keyC"=>["c31", "c32"]}] }

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
        expect(subject).to eq result
      end
    end
  end
  describe 'from_csv_str' do
    let(:options){ {} }
    subject do
      Doctordata::Parser.from_csv_str(csv_str, options)
    end
    context 'with valid csv_str' do
      it "returns correct json" do
        expect(subject).to eq result
      end
    end
    context 'with valid csv_str and skip option' do
      let(:csv_str){ "THIS_IS_UNNECESSARY_LINE\nkeyA,#commentB,keyC[0],keyC[1]\na1,b1,c11,c12\na2,b2,c21,c22\n,b3,c31,c32\n" }
      let(:options){ { skip_lines_number: 1 } }
      it "returns correct json" do
        expect(subject).to eq result
      end
    end
  end
  describe 'from_table' do
    let(:array){
      [
        ['keyA', '#commentB', 'keyC[0]', 'keyC[1]'],
        ['a1', 'b1', 'c11', 'c12'],
        ['a2', 'b2', 'c21', 'c22'],
        ['', 'b3', 'c31', 'c32'],
        ['', '', '', ''],
      ]
    }
    subject do
      Doctordata::Parser.from_table(array)
    end
    it 'returns correct json' do
      expect(subject).to eq result
    end
  end
  describe 'from_table_hash' do
    let(:title){"sheet1"}
    let(:hash){
      {
        title => [
          ['keyA', '#commentB', 'keyC[0]', 'keyC[1]'],
          ['a1', 'b1', 'c11', 'c12'],
          ['a2', 'b2', 'c21', 'c22'],
          ['', 'b3', 'c31', 'c32'],
          ['', '', '', ''],
        ],
      }
    }
    subject do
      Doctordata::Parser.from_table_hash(hash)
    end
    it 'returns correct json' do
      expect(subject[title]).to eq result
    end
  end
end
