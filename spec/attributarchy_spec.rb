require 'spec_helper'

class DummyController < ActionController::Base
  include Attributarchy
end

module Attributarchy
  describe ControllerMethods do

    subject { DummyController.new }
    let(:valid_attributarchy) { [:attr1, :attr2, :attr3] }

    describe '#has_attributarchy' do

      it 'requires an array of symbols' do
        # :(
        expect { subject.has_attributarchy()    }.to raise_error
        expect { subject.has_attributarchy(nil) }.to raise_error
        expect { subject.has_attributarchy([])  }.to raise_error
        expect { subject.has_attributarchy(['attribute']) }.to raise_error
        expect { subject.has_attributarchy([:attribute, 'attribute'])  }.to raise_error
        # :)
        expect { subject.has_attributarchy([:attribute])  }.to_not raise_error
      end

      it 'sets the attributarchy' do
        subject.has_attributarchy(valid_attributarchy)
        subject.attributarchy_configuration.should == valid_attributarchy
      end

    end

  end

end
