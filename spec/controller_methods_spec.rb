require 'spec_helper'

class DummyController < ActionController::Base
  include Attributarchy
end

module Attributarchy
  describe ControllerMethods, use_fakefs: true do

    subject { DummyController.new }
    let(:valid_attributarchy) { [:attr1, :attr2, :attr3] }

    before :each do
      # Prevent previous lookups from reporting a partial as non-existent.
      ActionView::Resolver.caching = false
    end

    describe '#has_attributarchy' do

      context 'when the arguments are invalid' do
        it 'raises ArgumentError exceptions' do
          expect { subject.has_attributarchy()    }.to raise_error ArgumentError
          expect { subject.has_attributarchy(nil) }.to raise_error ArgumentError
          expect { subject.has_attributarchy([])  }.to raise_error ArgumentError
          expect { subject.has_attributarchy(['attribute']) }.to raise_error ArgumentError
          expect { subject.has_attributarchy([:attribute, 'attribute'])  }.to raise_error ArgumentError
        end
      end

      context 'when the arguments are valid' do

        context 'when the attributarchy partial directory does not exist' do
          it 'raises a MissingDirectory exception' do
            expect { subject.has_attributarchy(valid_attributarchy) }.to raise_error MissingDirectory
          end
        end

        context 'when the attributarchy partial directory exists' do

          before :each  do
            FileUtils.mkdir_p(subject.partial_directory_path)
          end

          it 'does not raise a MissingDirectory exception' do
            expect { subject.has_attributarchy(valid_attributarchy) }.to_not raise_error(MissingDirectory)
          end

          context 'when a partial is missing' do
            it 'raises a MissingPartial exception' do
              expect { subject.has_attributarchy(valid_attributarchy) }.to raise_error MissingPartial
            end
          end

          context 'when no partials are missing' do
            before :each do
              valid_attributarchy.each do |a|
                FileUtils.touch "#{subject.partial_directory_path}/_#{a}.html.erb"
              end
            end
            it 'sets the attributarchy' do
              subject.has_attributarchy(valid_attributarchy)
              subject.attributarchy_configuration.should == valid_attributarchy
            end
          end
        end
      end
    end

    describe '#partial_directory' do
      it 'should be the controller name/attributarchy' do
        subject.partial_directory.should == "#{subject.controller_name}/attributarchy"
      end
    end

    describe '#partial_directory_path' do
      it 'should be the first view path (for now)/partial_directory' do
        subject.partial_directory_path.should == "#{subject.view_context.view_paths.first}/#{subject.partial_directory}"
      end
    end

    describe '#partial_directory_exists?' do
      it 'should return false if the directory does not exist' do
        (subject.partial_directory_exists?).should be_false
      end
      it 'should return true if the directory exists' do
        FileUtils.mkdir_p(subject.partial_directory_path)
        (subject.partial_directory_exists?).should be_true
      end
    end

    describe '#partial_exists?' do
      it 'should return false if the partial does not exist' do
        (subject.partial_exists?(:partial)).should be_false
      end
      it 'should return true if the partial exists' do
        FileUtils.mkdir_p(subject.partial_directory_path)
        FileUtils.touch "#{subject.partial_directory_path}/_partial.html.erb"
        (subject.partial_exists?(:partial)).should be_true
      end
    end

  end
end
