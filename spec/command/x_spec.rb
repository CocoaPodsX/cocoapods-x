require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::X do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ x }).should.be.instance_of Command::X
      end
    end
  end
end

