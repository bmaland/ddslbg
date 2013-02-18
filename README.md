# Ddslbg

This library spawns a child process which communicates with the
[DDSL command line tool](https://github.com/mbknor/ddsl/blob/master/ddsl-cmdline-tool/).

Just a proof of concept.

## Installation

```ruby
gem install ddslbg
```

## Usage

```ruby
require 'ddslbg'

$ddsl = Ddslbg::Client.new

service = {
  id: {environment: 'test', serviceType: 'http', name: 'cmd-tool', version: '0.1'},
  sl: {url: 'http://localhost:4321/hi', quality: 1.0, lastUpdated: 1347398923243, ip: '127.0.0.1'}
}

# Some of the DDSL methods has Ruby shortcuts (TODO implement all methods):
$ddsl.up(service)        # Register the service, uses ddsl serviceUp
$ddsl.available_services # List all available services, uses ddsl getAllAvailableServices
$ddsl.down(service)      # Explicitly deregister the service, uses ddsl serviceDown

# The remaining methods can be used via Ddslbg::Client#send, e.g.:
$ddsl.send('setFallbackUrlsMap', 
  {"ServiceId(test,telnet,telnetServer,0.1)" => "http://example.com/foo",
   "ServiceId(test,http,BarServer,1.0)" => "http://example.com/bar"})
```
