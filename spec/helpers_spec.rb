require 'spec_helper'

CountryStateCityStruct = Struct.new(:country, :state, :city)

module Attributarchy
  describe Helpers do

    subject { ControllerWithAttributarchy.new }
    let(:data) { [
      CountryStateCityStruct.new('United States', 'Colorado', 'Denver'),
      CountryStateCityStruct.new('United States', 'Colorado', 'Lakewood'),
      CountryStateCityStruct.new('United States', 'Illinois', 'Chicago'),
      CountryStateCityStruct.new('United States', 'Illinois', 'Westmont'),
      CountryStateCityStruct.new('United States', 'North Carolina', 'Charlotte'),
      CountryStateCityStruct.new('United States', 'North Carolina', 'Asheville')
    ] }
    let(:attributarchy_view_path) { File.join(rails_view_path, subject.controller_name) }

    describe '#build_attributarchy' do

      context 'when a partial is missing' do
        it 'should throw an ActionView::MissingTemplate exception' do
          subject.stub(:attributarchy_configuration).and_return({
            country: [:country],
            without_rendering: {}
          })
          expect{ subject.build_attributarchy(:country, data) }.to raise_error ActionView::MissingTemplate
        end
      end

      context 'with the default lookup path' do

        before :each do
          load_fixtures_into(attributarchy_view_path)
        end

        context 'with one attributarchy (country)' do

          let(:output) { subject.build_attributarchy(:country, data) }
          let(:tidied_output) { html_tidy(output) }
          let(:tidied_expected_output) { html_tidy(File.read(File.join(attributarchy_view_path, 'one_attributarchy.html'))) }

          before :each do
            subject.stub(:attributarchy_configuration).and_return({
              country: [:country],
              without_rendering: {}
            })
          end

          it_behaves_like 'an attributarchy'

          it 'should have one country attributarchy' do
            expect(output).to have_tag('div.country-attributarchy', count: 1)
          end

          it 'should have no state attributarchies' do
            expect(output).to_not have_tag('div.state-attributarchy')
          end

          it 'renders one attributarchy' do
            expect(tidied_output).to eq(tidied_expected_output)
          end

        end

        context 'with two attributarchies (country, state)' do

          context 'when all attributarchies are rendered' do

            let(:output) { subject.build_attributarchy(:country_and_state, data) }
            let(:tidied_output) { html_tidy(output) }
            let(:tidied_expected_output) { html_tidy(File.read(File.join(attributarchy_view_path, 'two_attributarchies.html'))) }

            before :each do
              subject.stub(:attributarchy_configuration).and_return({
                country_and_state: [:country, :state],
                without_rendering: {}
              })
            end

            it_behaves_like 'an attributarchy'

            it 'should have one country attributarchy' do
              expect(output).to have_tag('div.country-attributarchy', count: 1)
            end

            it 'should have three state attributarchies within the country' do
              expect(output).to have_tag('div.country-attributarchy') do
                with_tag('div.state-attributarchy', count: 3)
              end
            end

            it 'renders two attributarchies' do
              expect(tidied_output).to eq(tidied_expected_output)
            end

          end

          context 'when an attributarchy has a group-only attribute' do

            let(:output) { subject.build_attributarchy(:country_and_state, data) }
            let(:tidied_output) { html_tidy(output) }
            let(:tidied_expected_output) { html_tidy(File.read(File.join(attributarchy_view_path, 'two_attributarchies_without_rendering_country.html'))) }

            before :each do
              subject.stub(:attributarchy_configuration).and_return({
                country_and_state: [:country, :state],
                without_rendering: { country: nil }
              })
            end

            it_behaves_like 'an attributarchy'

            it 'should have one country attributarchy but no country content' do
              expect(output).to have_tag('div.country-attributarchy', count: 1)
              expect(output).to_not have_tag('section.country')
            end

            it 'should have three state attributarchies within the country' do
              expect(output).to have_tag('div.country-attributarchy') do
                with_tag('div.state-attributarchy', count: 3)
              end
            end

            it 'groups on both attributarchies but only renders the states' do
              expect(tidied_output).to eq(tidied_expected_output)
            end

          end

        end

        context 'with two attributarchies back-to-back (country; country, state)' do

          let(:output) {
            subject.build_attributarchy(:country, data) +
            subject.build_attributarchy(:country_and_state, data)
          }
          let(:tidied_output) { html_tidy(output) }
          let(:tidied_expected_output) {
            html_tidy(
              File.read(File.join(attributarchy_view_path, 'one_attributarchy.html')) +
              File.read(File.join(attributarchy_view_path, 'two_attributarchies.html'))
            )
          }

          before :each do
            subject.stub(:attributarchy_configuration).and_return({
              country: [:country],
              country_and_state: [:country, :state],
              without_rendering: {}
            })
          end

          it_behaves_like 'an attributarchy'

          it 'should have two attributarchies' do
            expect(output).to have_tag('div.attributarchy', count: 2)
          end

          it 'should have one country in the first attributarchy' do
            expect(output).to have_tag('div.attributarchy:nth-child(1) div.country-attributarchy', count: 1)
          end

          it 'should have no states in the first attributarchy' do
            expect(output).to_not have_tag('div.attributarchy:nth-child(1) div.state-attributarchy')
          end

          it 'should have one country in the second attributarchy' do
            expect(output).to have_tag('div.attributarchy:nth-child(2) div.country-attributarchy', count: 1)
          end

          it 'should have three states in the second attributarchy' do
            expect(output).to have_tag('div.attributarchy:nth-child(2) div.country-attributarchy') do
              with_tag('div.state-attributarchy', count: 3)
            end
          end

          it 'renders two attributarchies back-to-back' do
            expect(tidied_output).to eq(tidied_expected_output)
          end

        end
      end

      context 'with a specified lookup path' do

        before :each do
          lookup_path = File.join(attributarchy_view_path, 'lookup')
          load_fixtures_into(lookup_path)
        end

        context 'with one attributarchy (country)' do

          let(:output) { subject.build_attributarchy(:country, data) }
          let(:expected_output) { html_tidy(File.read(File.join(lookup_path, 'one_attributarchy.html'))) }

          before :each do
            subject.stub(:attributarchy_configuration).and_return({
              country: [:country],
              without_rendering: {}
            })
          end

          it_behaves_like 'an attributarchy'

          it 'should have one country attributarchy' do
            expect(output).to have_tag('div.country-attributarchy', count: 1)
          end

          it 'should have no state attributarchies' do
            expect(output).to_not have_tag('div.state-attributarchy')
          end
        end
      end

    end # /build_attributarchy
  end # /Helpers
end # /Attributarchy
