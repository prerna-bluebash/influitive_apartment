require 'spec_helper'
require 'apartment/elevators/generic'

describe Apartment::Elevators::Generic do

  class MyElevator < described_class
    def parse_database_name(*)
      'tenant2'
    end
  end

  subject(:elevator){ described_class.new(Proc.new{}) }

  describe "#call" do
    it "calls the processor if given" do
      elevator = described_class.new(Proc.new{}, Proc.new{'tenant1'})

      Apartment::Database.should_receive(:switch).with('tenant1')

      elevator.call('HTTP_HOST' => 'foo.bar.com')
    end

    it "raises if parse_database_name not implemented" do
      expect {
        elevator.call('HTTP_HOST' => 'foo.bar.com')
      }.to raise_error(RuntimeError)
    end

    it "switches to the parsed db_name" do
      elevator = MyElevator.new(Proc.new{})

      Apartment::Database.should_receive(:switch).with('tenant2')

      elevator.call('HTTP_HOST' => 'foo.bar.com')
    end
  end
end