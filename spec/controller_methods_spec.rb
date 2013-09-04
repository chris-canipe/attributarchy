require 'spec_helper'

class DummyController < ActionController::Base
  include Attributarchy
end

module Attributarchy
  describe ControllerMethods, use_fakefs: true do

    subject { DummyController.new }
    let(:attributarchy_name) { :test_attributarchy }
    let(:valid_attributarchy) { [:attr1, :attr2, :attr3] }
    let(:rails_view_path) { File.join(::Rails.root, %w[app views]) }
    let(:attributarchy_view_path) { File.join(rails_view_path, subject.controller_name) }
    let(:defined_view_paths) { subject.view_paths.to_a.map { |path| path.to_s } }

    before :each do
      # Prevent previous lookups from reporting a partial as non-existent.
      ActionView::Resolver.caching = false
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

        context 'when a partial is missing' do
          it 'raises a MissingPartial exception' do
            expect { subject.has_attributarchy attributarchy_name, as: valid_attributarchy }.to raise_error MissingPartial
          end
        end

        context 'when no partials are missing' do

          before :each do
            FileUtils.mkdir_p(attributarchy_view_path)
            valid_attributarchy.each do |a|
              FileUtils.touch File.join(attributarchy_view_path, "_#{a}.html.erb")
            end
          end

          it 'sets the attributarchy' do
            subject.has_attributarchy attributarchy_name, as: valid_attributarchy
            expect(subject.attributarchy_configuration).to eq({
              attributarchy_name => valid_attributarchy
            })
          end

          it "adds the default lookup path to the view paths (the controller's views)" do
            subject.has_attributarchy attributarchy_name, as: valid_attributarchy
            expect(defined_view_paths).to include(attributarchy_view_path)
          end

          context 'when a lookup path is specified' do

            it 'accepts a string' do
              expect {
                subject.has_attributarchy attributarchy_name, as: valid_attributarchy, in: 'path'
              }.to_not raise_error ArgumentError
              expect(defined_view_paths).to include(File.join(rails_view_path, 'path'))
            end

            it 'accepts an array' do
              expect {
                subject.has_attributarchy attributarchy_name, as: valid_attributarchy, in: ['path']
              }.to_not raise_error ArgumentError
              expect(defined_view_paths).to include(File.join(rails_view_path, 'path'))
            end

          end
        end
      end
    end

    describe '#partial_exists_for?' do

      it 'should return false if the partial does not exist' do
        expect(subject.partial_exists_for?(:nonexistent_partial)).to be_false
      end

      it 'should return true if the partial exists' do
        FileUtils.mkdir_p(attributarchy_view_path)
        FileUtils.touch File.join(attributarchy_view_path, '_attr1.html.erb')
        subject.prepend_view_path(attributarchy_view_path)
        expect(subject.partial_exists_for?(:attr1)).to be_true
      end

      it 'should return true if the partial exists in a lookup path' do
        lookup_path = File.join(attributarchy_view_path, 'lookup')
        FileUtils.mkdir_p(lookup_path)
        FileUtils.touch File.join(lookup_path, '_attr1.html.erb')
        subject.prepend_view_path(lookup_path)
        expect(subject.partial_exists_for?(:attr1)).to be_true
      end

    end

  end
end
