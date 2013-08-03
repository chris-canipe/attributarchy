require 'spec_helper'

class DummyController < ActionController::Base
  include Attributarchy
end

module Attributarchy
  describe ControllerMethods do

    subject { DummyController.new }
    let(:valid_attributarchy) { [:attr1, :attr2, :attr3] }
    let(:partial_directory) { "#{subject.view_context.view_paths.first}/#{subject.controller_name}/attributarchy" }

    describe '#has_attributarchy', fakefs: true do

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
            FileUtils.mkdir_p(partial_directory)
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
                FileUtils.touch "#{partial_directory}/_#{a}.html.erb"
              end
              # Prevent previous lookups from reporting a partial as non-existent.
              ActionView::Resolver.caching = false
            end
            it 'sets the attributarchy' do
              subject.has_attributarchy(valid_attributarchy)
              subject.attributarchy_configuration.should == valid_attributarchy
            end
          end
        end
      end
    end
  end
end
