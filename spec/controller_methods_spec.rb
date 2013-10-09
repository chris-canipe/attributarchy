require 'spec_helper'

module Attributarchy
  describe ControllerMethods do

    subject { ControllerWithAttributarchy }
    let(:attributarchy_name) { :a_symbol }
    let(:valid_attributarchy) {[
      :a_symbol_representing_an_attribute,
      :a_symbol_representing_another_attribute,
      :a_symbol_representing_yet_another_attribute,
    ]}

    it 'defines the build_attributarchy helper' do
      expect(subject.new.view_context).to respond_to(:build_attributarchy)
    end

    it 'defines the attributarchy_configuration helper' do
      expect(subject.new.view_context).to respond_to(:attributarchy_configuration)
    end

    describe '#has_attributarchy' do

      context 'when the arguments are invalid' do
        it 'raises ArgumentError exceptions' do
          expect { subject.has_attributarchy }.to raise_error ArgumentError
          expect { subject.has_attributarchy :attributarchy_name, as: [] }.to raise_error ArgumentError
          expect { subject.has_attributarchy :attributarchy_name, as: ['attribute'] }.to raise_error ArgumentError
          expect { subject.has_attributarchy :attributarchy_name, as: [:attribute, 'attribute'] }.to raise_error ArgumentError
        end
      end

      context 'when the arguments are valid' do
        let(:attributarchy_view_path) { File.join(rails_view_path, subject.controller_name) }
        let(:view_paths) { subject.view_paths.to_a.map { |path| path.to_s } }

        it 'sets the attributarchy' do
          subject.has_attributarchy attributarchy_name, as: valid_attributarchy
          expect(subject.attributarchy_configuration[attributarchy_name]).to eq(valid_attributarchy)
          expect(subject.new.view_context.attributarchy_configuration[attributarchy_name]).to eq(valid_attributarchy)
        end

        it "adds the default lookup path (the controller's views) to the view path" do
          subject.has_attributarchy attributarchy_name, as: valid_attributarchy
          expect(view_paths).to include(attributarchy_view_path)
        end

        context 'when a non-rendering attribute is specified as a symbol' do
          it 'defines the attribute as non-rendering' do
            subject.has_attributarchy attributarchy_name,
              as: [:do_not_render], without_rendering: :do_not_render
            expect(subject.attributarchy_configuration[:without_rendering]).to include(:do_not_render)
          end
        end

        context 'when non-rendering attributes are specified as an array' do
          it 'defines the attributes as non-rendering' do
            subject.has_attributarchy attributarchy_name,
              as: [:do_not_render, :do_not_render_either], without_rendering: [:do_not_render, :do_not_render_either]
            expect(subject.attributarchy_configuration[:without_rendering]).to include(:do_not_render)
            expect(subject.attributarchy_configuration[:without_rendering]).to include(:do_not_render_either)
          end
        end

        context 'when a lookup path is specified' do
          it 'accepts a string' do
            subject.has_attributarchy attributarchy_name, as: valid_attributarchy, in: 'path'
            expect(view_paths).to include(File.join(rails_view_path, 'path'))
          end
          it 'accepts an array' do
            subject.has_attributarchy attributarchy_name, as: valid_attributarchy, in: ['path']
            expect(view_paths).to include(File.join(rails_view_path, 'path'))
          end
        end
      end
    end
  end
end
