# Ddslbg

This library spawns a child process which communicates with the
[DDSL command line tool](https://github.com/mbknor/ddsl/blob/master/ddsl-cmdline-tool/).

Just a proof of concept.

## Installation

```ruby
gem install ddslbg
```

Note that this gem spawns a Java process running a standalone jar, so a working
JRE is required.

## Usage

Please see the [main DDSL documentation](https://github.com/mbknor/ddsl) for
concepts and details.

### Initialize the client

```ruby
require 'ddslbg'
$ddsl = Ddslbg::Client.new
```

### Set a list of zookeepers to use

```ruby
$ddsl.zookeeper_hosts = ['localhost:2181', 'some.other.server.com:2181']
```

### List available services

```ruby
$ddsl.available_services
```

### Toggle service state

```ruby
service = {
  id: {environment: 'test', serviceType: 'http', name: 'cmd-tool', version: '0.1'},
  sl: {url: 'http://localhost:4321/hi', quality: 1.0, lastUpdated: 1347398923243, ip: '127.0.0.1'}
}

$ddsl.up(service)
$ddsl.down(service)
```

### Get service locations

```ruby
service_request = {
  'sid' => {'environment' => 'test', 'serviceType' => 'telnet', 'name' => 'telnetServer', 'version' => '0.1'},
  'cid' => {'environment' => 'Client env', 'name' => 'client name', 'version' => 'version', 'ip' => 'ip-address'}
}

$ddsl.best_service_location(service_request)
$ddsl.service_locations(service_request)
```

### Set local fallbacks

```ruby
fallbacks = {
  'ServiceId(test,telnet,telnetServer,0.1)' => 'http://example.com/foo',
  'ServiceId(test,http,BarServer,1.0)'      => 'http://example.com/bar'
}

$ddsl.fallback_urls = fallbacks
```

### Cleanly disconnect

Use `$ddsl.disconnect!` to kill off the spawned process.
