require 'helper'

class TestGeoStoreClient < Test::Unit::TestCase

  def test_linccer_client
    assert c = TestClient.new( :host => "linker.beta.hoccer.com", :port => 80)
    assert d = TestClient.new( :host => "linker.beta.hoccer.com", :port => 80)
    puts c.inspect
    puts

    response = c.update_environment(
      :gps => {:longitude => 12.2, :latitude => 14.2, :accuracy => 23.0}
    )
    puts response.inspect
    puts

    response = d.update_environment(
      :gps => {:longitude => 12.2, :latitude => 14.2, :accuracy => 23.0}
    )
    puts response.inspect
    puts

    t1 = c.share_threaded( "one-to-one", :foo => "bar" )
    t2 = d.receive( "one-to-one" )

    puts t2.inspect
    puts t1.value.inspect
  end


end
