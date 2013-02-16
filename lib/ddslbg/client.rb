module Ddslbg
  class Client
    BUNDLED_JAR_PATH = File.expand_path(
      '../../../vendor/bin/ddsl-cmdline-tool_2.10-0.3.5-SNAPSHOT-one-jar.jar',
      __FILE__)

    attr_reader :options

    def initialize(options={})
      default_opts = {
        java_cmd: 'java -jar',
        jar_path: BUNDLED_JAR_PATH
      }
      @options = default_opts.merge(options)

      connect!
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

    # Send a raw command to DDSL.
    #
    # `data` can be a Ruby array or hash. It is converted to JSON before it is
    # sent to DDSL.
    def send(msg, data=nil)
      cmd = msg
      cmd += " #{data.to_json}" if data
      @stdin.puts(cmd)
      parse(process_line(@stdout.gets))
    end

    private

    def connect!
      cmd = [options[:java_cmd], options[:jar_path]].join(' ')
      @stdin, @stdout, @stderr = Open3.popen3(cmd)

      process_line(@stdout.gets)
    end

    def process_line(line='')
      status, data = line.scan(/^([a-z]+) (.+)/).flatten
      raise StandardError.new("[ddslbg] #{line}") unless status == 'ok'
      data
    end

    def parse(str)
      return true  if str == 'true'
      return false if str == 'false'
      JSON.parse(str)
    end
  end
end
