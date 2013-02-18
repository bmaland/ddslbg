require 'spec_helper'

require 'ddslbg/client'

module Ddslbg
  describe Client do
    subject { Client.new(auto_connect: false) }

    it 'should raise if it receives an error' do
      response = "error java.net.UnknownHostException: some.other.server.com\n"
      subject.should_receive(:do_send).and_return(response)

      begin
        subject.send('any message')
      rescue Ddslbg::Error => e
        e.to_s.should == 'java.net.UnknownHostException: some.other.server.com'
      end
    end

    describe '#available_services' do
      specify do
        subject.should_receive(:do_send).with('getAllAvailableServices').and_return("ok []\n")
        subject.available_services.should == []
      end
    end

    describe '#up' do
      specify do
        service = {
          id: {environment: 'test', serviceType: 'http', name: 'cmd-tool', version: '0.1'},
          sl: {url: 'http://localhost:4321/hi', quality: 1.0, lastUpdated: 1347398923243, ip: '127.0.0.1'}
        }
        subject.should_receive(:do_send).with("serviceUp #{service.to_json}").and_return("ok true\n")
        subject.up(service).should be_true
      end
    end

    describe '#fallback_urls=' do
      specify do
        fallbacks = {
          'ServiceId(test,telnet,telnetServer,0.1)' => 'http://example.com/foo',
          'ServiceId(test,http,BarServer,1.0)'      => 'http://example.com/bar'
        }

        response = "ok fallbackUrls-map has been updated: {\"ServiceId(test,telnet,telnetServer,0.1)\":\"http://example.com/foo\",\"ServiceId(test,http,BarServer,1.0)\":\"http://example.com/bar\"}\n"

        subject.should_receive(:do_send)
          .with("setFallbackUrlsMap #{fallbacks.to_json}")
          .and_return(response)

        subject.fallback_urls = fallbacks
      end
    end

    describe '#zookeeper_hosts=' do
      specify do
        hosts = ['localhost:2181', 'some.other.server.com:2181']
        response = "ok ZookeeperHosts-list has been configured\n"

        subject.should_receive(:do_send)
          .with("setZookeeperHosts #{hosts.to_json}")
          .and_return(response)

        subject.zookeeper_hosts = hosts
      end
    end
  end
end
