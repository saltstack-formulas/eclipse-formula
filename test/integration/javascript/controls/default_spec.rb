# frozen_string_literal: true

title 'eclipse archives profile'

control 'eclipse archive' do
  impact 1.0
  title 'should be installed'

  describe file('/usr/local/eclipse-javascript-2020-03-R-incubation/eclipse') do
    it { should exist }
  end
end
