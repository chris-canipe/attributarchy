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
    let(:attributarchy_view_path) { File.join(rails_view_path, subject.controller_name) }

    describe '#build_attributarchy' do

      context 'with the default lookup path' do

        before :each do
          FileUtils.mkdir_p(attributarchy_view_path)
          FakeFS::FileSystem.clone('spec/fixtures')
          Dir.glob('spec/fixtures/*/*') do |f|
            FileUtils.cp f, File.join(attributarchy_view_path, File.basename(f))
          end
          helper.controller.prepend_view_path(attributarchy_view_path)
        end

        context 'with one attributarchy (country)' do

          let(:attributarchy_configuration) {{
              country: [:country],
              without_rendering: {}
          }}
          let(:output) { html_tidy(helper.build_attributarchy(attributarchy_configuration, :country, data)) }
          let(:expected_output) { html_tidy(File.read(File.join(attributarchy_view_path, 'one_attributarchy.html'))) }

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

          context 'when all attributarchies are rendered' do

            let(:attributarchy_configuration) {{
                country_and_state: [:country, :state],
                without_rendering: {}
            }}
            let(:output) { html_tidy(helper.build_attributarchy(attributarchy_configuration, :country_and_state, data)) }
            let(:expected_output) { html_tidy(File.read(File.join(attributarchy_view_path, 'two_attributarchies.html'))) }

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

          context 'when an attributarchy has a group-only attribute' do

            let(:attributarchy_configuration) {{
                country_and_state: [:country, :state],
                without_rendering: { country: nil }
            }}
            let(:output) { html_tidy(helper.build_attributarchy(attributarchy_configuration, :country_and_state, data)) }
            let(:expected_output) { html_tidy(File.read(File.join(attributarchy_view_path, 'two_attributarchies_without_rendering_country.html'))) }

            it_behaves_like 'an attributarchy'

            it 'should have one country attributarchy but no country content' do
              expect(output).to have_tag('div.country-container', count: 1)
              expect(output).to_not have_tag('section.country')
            end

            it 'should have three state attributarchies within the country' do
              expect(output).to have_tag('div.country-container') do
                with_tag('div.state-container', count: 3)
              end
            end

            it 'groups on both attributarchies but only renders the states' do
              expect(output).to eq(expected_output)
            end

          end

        end

        context 'with two attributarchies back-to-back (country; country, state)' do

          let(:attributarchy_configuration) {{
              country: [:country],
              country_and_state: [:country, :state],
              without_rendering: {}
          }}
          let(:output) {
            html_tidy(
              helper.build_attributarchy(attributarchy_configuration, :country, data) +
              helper.build_attributarchy(attributarchy_configuration, :country_and_state, data)
            )
          }
          let(:expected_output) {
            html_tidy(File.read(File.join(attributarchy_view_path, 'one_attributarchy.html'))) +
            html_tidy(File.read(File.join(attributarchy_view_path, 'two_attributarchies.html')))
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

      context 'with a specified lookup path' do

        before :each do
          lookup_path = File.join(attributarchy_view_path, 'lookup')
          FileUtils.mkdir_p(lookup_path)
          FakeFS::FileSystem.clone('spec/fixtures')
          Dir.glob('spec/fixtures/*/*') do |f|
            FileUtils.cp f, File.join(lookup_path, File.basename(f))
          end
          helper.controller.prepend_view_path(lookup_path)
        end

        context 'with one attributarchy (country)' do

          let(:attributarchy_configuration) {{
              country: [:country],
              without_rendering: {}
          }}
          let(:output) { html_tidy(helper.build_attributarchy(attributarchy_configuration, :country, data)) }
          let(:expected_output) { html_tidy(File.read(File.join(lookup_path, 'one_attributarchy.html'))) }

          it_behaves_like 'an attributarchy'

          it 'should have one country attributarchy' do
            expect(output).to have_tag('div.country-container', count: 1)
          end

          it 'should have no state attributarchies' do
            expect(output).to_not have_tag('div.state-container')
          end
        end
      end

    end # /build_attributarchy
  end # /Helpers
end # /Attributarchy
