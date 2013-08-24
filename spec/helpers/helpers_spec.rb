require 'spec_helper'

class DummyController < ActionController::Base
  include Attributarchy
end

AttributarchyStruct = Struct.new(:country, :state, :city)

module Attributarchy
  describe Helpers do

    subject { DummyController.new }
    let(:data) { [
      AttributarchyStruct.new('United States', 'Colorado', 'Denver'),
      AttributarchyStruct.new('United States', 'Colorado', 'Lakewood'),
      AttributarchyStruct.new('United States', 'Illinois', 'Chicago'),
      AttributarchyStruct.new('United States', 'Illinois', 'Westmont'),
      AttributarchyStruct.new('United States', 'North Carolina', 'Charlotte'),
      AttributarchyStruct.new('United States', 'North Carolina', 'Asheville')
    ] }

    describe '#build_attributarchy' do

      before :each do
        FileUtils.mkdir_p(subject.partial_directory_path)
        FakeFS::FileSystem.clone('spec/fixtures')
        Dir.glob('spec/fixtures/*') do |f|
          FileUtils.cp f, "#{subject.partial_directory_path}/#{File.basename f}"
        end
      end

      context 'with one group (country)' do

        let(:attributarchy_configuration) {{
            attributes: [:country],
            partial_directory: 'dummy/attributarchy'
        }}

        it 'renders one group' do
          (helper.build_attributarchy(attributarchy_configuration, data)).should == <<-OUTPUT.gsub(/^\s+/, '')
            <div class="attributarchy country-container">
              Country_Value=United States
              Country_Data=
              United States, Colorado, Denver
              United States, Colorado, Lakewood
              United States, Illinois, Chicago
              United States, Illinois, Westmont
              United States, North Carolina, Charlotte
              United States, North Carolina, Asheville
              Country_Level=0
            </div>
          OUTPUT
        end

      end

      context 'with two groups (country, state)' do

        let(:attributarchy_configuration) {{
            attributes: [:country, :state],
            partial_directory: 'dummy/attributarchy'
        }}

        it 'renders two groups' do
          (helper.build_attributarchy(attributarchy_configuration, data)).should == <<-OUTPUT.gsub(/^\s+/, '')
            <div class="attributarchy country-container">
              Country_Value=United States
              Country_Data=
              United States, Colorado, Denver
              United States, Colorado, Lakewood
              United States, Illinois, Chicago
              United States, Illinois, Westmont
              United States, North Carolina, Charlotte
              United States, North Carolina, Asheville
              Country_Level=0
              <div class="attributarchy state-container">
                State_Value=Colorado
                State_Data=
                United States, Colorado, Denver
                United States, Colorado, Lakewood
                State_Level=1
              </div>
              <div class="attributarchy state-container">
                State_Value=Illinois
                State_Data=
                United States, Illinois, Chicago
                United States, Illinois, Westmont
                State_Level=1
              </div>
              <div class="attributarchy state-container">
                State_Value=North Carolina
                State_Data=
                United States, North Carolina, Charlotte
                United States, North Carolina, Asheville
                State_Level=1
              </div>
            </div>
          OUTPUT
        end

      end
    end
  end
end
