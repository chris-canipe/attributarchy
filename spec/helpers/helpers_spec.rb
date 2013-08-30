require 'spec_helper'

class DummyController < ActionController::Base
  include Attributarchy
end

AttributarchyStruct = Struct.new(:country, :state, :city)

def html_tidy(html)
  html.
    gsub(/\A\s+|\s+\z/, '').
    gsub(/>\s+/, '>').
    gsub(/\s+</, '<')
end

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
        Dir.glob('spec/fixtures/*/*') do |f|
          FileUtils.cp f, "#{subject.partial_directory_path}/#{File.basename f}"
        end
      end

      context 'with one attributarchy (country)' do

        let(:attributarchy_configuration) {{
            country: [:country],
            partial_directory: 'dummy/attributarchy'
        }}
        let(:output) { html_tidy(helper.build_attributarchy(attributarchy_configuration, :country, data)) }
        let(:expected_output) { html_tidy(File.read("#{subject.partial_directory_path}/one_attributarchy.html")) }

        it_behaves_like 'an attributarchy'

        it 'should have one country attributarchy' do
          expect(output).to have_tag('div.country-container', count: 1)
        end

        it 'should have no state attributarchies' do
          expect(output).to_not have_tag('div.state-container')
        end

        it 'renders one attributarchy' do
          expect(output).to eq(expected_output)
        end

      end

      context 'with two attributarchies (country, state)' do

        let(:attributarchy_configuration) {{
            country_and_state: [:country, :state],
            partial_directory: 'dummy/attributarchy'
        }}
        let(:output) { html_tidy(helper.build_attributarchy(attributarchy_configuration, :country_and_state, data)) }
        let(:expected_output) { html_tidy(File.read("#{subject.partial_directory_path}/two_attributarchies.html")) }

        it_behaves_like 'an attributarchy'

        it 'should have one country attributarchy' do
          expect(output).to have_tag('div.country-container', count: 1)
        end

        it 'should have three state attributarchies within the country' do
          expect(output).to have_tag('div.country-container') do
            with_tag('div.state-container', count: 3)
          end
        end

        it 'renders two attributarchies' do
          expect(output).to eq(expected_output)
        end

      end

      context 'with two attributarchies back-to-back (country; country, state)' do

        let(:attributarchy_configuration) {{
            country: [:country],
            country_and_state: [:country, :state],
            partial_directory: 'dummy/attributarchy'
        }}
        let(:output) {
          html_tidy(
            helper.build_attributarchy(attributarchy_configuration, :country, data) +
            helper.build_attributarchy(attributarchy_configuration, :country_and_state, data)
          )
        }
        let(:expected_output) {
          html_tidy(File.read("#{subject.partial_directory_path}/one_attributarchy.html")) +
          html_tidy(File.read("#{subject.partial_directory_path}/two_attributarchies.html"))
        }

        it_behaves_like 'an attributarchy'

        it 'should have two attributarchies' do
          expect(output).to have_tag('div.attributarchy', count: 2)
        end

        it 'should have one country in the first attributarchy' do
          expect(output).to have_tag('div.attributarchy:nth-child(1) div.country-container', count: 1)
        end

        it 'should have no states in the first attributarchy' do
          expect(output).to_not have_tag('div.attributarchy:nth-child(1) div.state-container')
        end

        it 'should have one country in the second attributarchy' do
          expect(output).to have_tag('div.attributarchy:nth-child(2) div.country-container', count: 1)
        end

        it 'should have three states in the second attributarchy' do
          expect(output).to have_tag('div.attributarchy:nth-child(2) div.country-container') do
            with_tag('div.state-container', count: 3)
          end
        end

        it 'renders two attributarchies back-to-back' do
          expect(output).to eq(expected_output)
        end

      end
    end
  end
end
