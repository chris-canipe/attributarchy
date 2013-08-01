require 'spec_helper'

class DummyController < ActionController::Base
  include Attributarchy
end

module Attributarchy
  describe ControllerMethods do

    subject { DummyController.new }
    let(:valid_attributarchy) { [:attr1, :attr2, :attr3] }

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
          before do
            partial_directory = "#{subject.view_context.view_paths.first}/#{subject.controller_name}/attributarchy/"
            FileUtils.mkdir_p(partial_directory)
          end
          it 'does not raise an exception' do
            expect { subject.has_attributarchy(valid_attributarchy) }.to_not raise_error
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
