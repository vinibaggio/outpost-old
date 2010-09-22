require 'spec_helper'

describe Outpost do

  class ScoutExample < Scout::Base
  end

  class OutpostExample < Outpost
    depends ScoutExample => "web site" do
      options :host => 'localhost', :port => 3000
      report :up, :response_code => 200
    end
  end
  
  it "should return the options for the outpost" do
    OutpostExample.class_variable_get(:@@options).should == {:host => 'localhost', :port => 3000}
  end
  
  it "should possible to set the server settings" do
    OutpostExample.server(:host => 'hostname', :user => 'my_user')
    OutpostExample.server_settings.should == { :user => 'my_user', :host => 'hostname'}
  end
  
  it "should set and return the server settings" do
    OutpostExample.server(:host => 'gotham', :user => 'batman')
    OutpostExample.server_settings.should == {:host => 'gotham', :user => 'batman'}
  end
  
  it "should set the port too!" do
    OutpostExample.server(:host => 'gotham', :port => 80)
    OutpostExample.server_settings[:port].should equal 80 
  end

end