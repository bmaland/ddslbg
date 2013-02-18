require 'open3'
require 'json'

require 'ddslbg/error'

module Ddslbg
  class Client
    BUNDLED_JAR_PATH = File.expand_path(
      '../../../vendor/bin/ddsl-cmdline-tool_2.10-0.3.5-SNAPSHOT-one-jar.jar',
      __FILE__)

    attr_reader :options

    def initialize(options={})
      default_opts = {
        java_cmd: 'java -jar',
        jar_path: BUNDLED_JAR_PATH,
        auto_connect: false
      }
      @options = default_opts.merge(options)

      connect! if @options[:auto_connect]
    end

    def available_services
      send('getAllAvailableServices')
    end

    def up(service)
      send('serviceUp', service)
    end

    def down(service)
      send('serviceDown', service)
    end

    def best_service_location(service_request)
      send('getBestServiceLocation', service_request)
    end

    def service_locations(service_request)
      send('getServiceLocations', service_request)
    end

    def fallback_urls=(fallback_urls)
      send('setFallbackUrlsMap', fallback_urls, parse: false)
    end

    def zookeeper_hosts=(hosts=[])
      send('setZookeeperHosts', hosts, parse: false)
    end

    # `data` can be a Ruby array or hash. It is converted to JSON before it is
    # sent to DDSL.
    def send(msg, data={}, options={})
      default_opts = { parse: true }
      options = default_opts.merge(options)
      msg += " #{data.to_json}" unless !data || data.empty?
      res = process_line(do_send(msg))
      res = parse(res) if options[:parse]
      res
    end

    # Sends a raw command to DDSL and returns the response as a unprocessed string.
    def do_send(cmd)
      connect! unless connected?
      @stdin.puts(cmd)
      @stdout.gets
    end

    def connect!
      cmd = [options[:java_cmd], options[:jar_path]].join(' ')
      @stdin, @stdout, @wait_thr = Open3.popen2(cmd)

      process_line(@stdout.gets).include?('ddsl-cmdline-tool started')
    end

    def disconnect!
      return false unless connected?
      @stdin.close unless @stdin.closed?
      @stdout.close unless @stdout.closed?
      Process.kill(:INT, @wait_thr.pid)
      true
    end

    def connected?
      !!@wait_thr && @wait_thr.alive?
    end

    private

    def process_line(line='')
      status, data = line.scan(/^([a-z]+) (.+)/).flatten
      data.chomp!
      raise Error.new(data) unless status == 'ok'
      data
    end

    def parse(str)
      return true  if str == 'true'
      return false if str == 'false'
      JSON.parse(str)
    end
  end
end
