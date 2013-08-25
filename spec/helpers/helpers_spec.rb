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
          # TODO: Clean up and use tidyer.
          (helper.build_attributarchy(attributarchy_configuration, data)).should == <<-OUTPUT.gsub(/^\s{12}/, '')
            <div class="attributarchy country-container">
            <section class="country">
              <header>
                <h1>United States</h1>
              </header>
              <div class="data">
                <ul>
                  <li>United States, Colorado, Denver</li>
                  <li>United States, Colorado, Lakewood</li>
                  <li>United States, Illinois, Chicago</li>
                  <li>United States, Illinois, Westmont</li>
                  <li>United States, North Carolina, Charlotte</li>
                  <li>United States, North Carolina, Asheville</li>
                </ul>
              </div>
              <div class="level">
                0
              </div>
            </section>
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
          (helper.build_attributarchy(attributarchy_configuration, data)).should == <<-OUTPUT.gsub(/^\s{12}/, '')
            <div class="attributarchy country-container">
            <section class="country">
              <header>
                <h1>United States</h1>
              </header>
              <div class="data">
                <ul>
                  <li>United States, Colorado, Denver</li>
                  <li>United States, Colorado, Lakewood</li>
                  <li>United States, Illinois, Chicago</li>
                  <li>United States, Illinois, Westmont</li>
                  <li>United States, North Carolina, Charlotte</li>
                  <li>United States, North Carolina, Asheville</li>
                </ul>
              </div>
              <div class="level">
                0
              </div>
            </section>
            <div class="attributarchy state-container">
            <section class="state">
              <header>
                <h1>Colorado</h1>
              </header>
              <div class="data">
                <ul>
                  <li>United States, Colorado, Denver</li>
                  <li>United States, Colorado, Lakewood</li>
                </ul>
              </div>
              <div class="level">
                1
              </div>
            </section>
            </div>
            <div class="attributarchy state-container">
            <section class="state">
              <header>
                <h1>Illinois</h1>
              </header>
              <div class="data">
                <ul>
                  <li>United States, Illinois, Chicago</li>
                  <li>United States, Illinois, Westmont</li>
                </ul>
              </div>
              <div class="level">
                1
              </div>
            </section>
            </div>
            <div class="attributarchy state-container">
            <section class="state">
              <header>
                <h1>North Carolina</h1>
              </header>
              <div class="data">
                <ul>
                  <li>United States, North Carolina, Charlotte</li>
                  <li>United States, North Carolina, Asheville</li>
                </ul>
              </div>
              <div class="level">
                1
              </div>
            </section>
            </div>
            </div>
          OUTPUT
        end

      end
    end
  end
end
