#!/usr/bin/ruby

# = get_ssh_key.rb
# Copyright 2010 Martin Carpenter, mcarpenter@free.fr.
#
# Retrieves the public SSH key from one or more remote hosts.
#
# == Usage
# get_ssh_key.rb -h | [ -t { rsa | dsa } ] host [...]

require 'rubygems'
require 'net/ssh'
require 'base64'
require 'getoptlong'

DEFAULT_SSH_PORT = 22

# Class to represent the server's public key. This must contain a
# #verify instance method since this callback is how we populate
# the @key attribute.
class Key

  # Return the length of the key in bits.
  def length
    case @key
    when OpenSSL::PKey::DSA
      length_indicator = @key.p
    when OpenSSL::PKey::RSA
      length_indicator = @key.n
    else
      raise RuntimeError, "Unknown key type `#{@key.class}'"
    end
    length_indicator.to_i.to_s(2).length
  end

  # Convert key to string representation.
  def to_s
    b64 = Base64.encode64(@key.to_blob).gsub!(/\s+/, '')
    "#{@key.ssh_type} #{b64}"
  end

  # Callback invoked by the host verifier.
  def verify(to_verify)
    @key = to_verify[:key]
  end

end

# Return the name of this program.
def program_name
  File.basename($0)
end

# Display usage on stderr and exit with (optional) exit code.
def usage(exit_code=0)
  $stderr.puts "Usage: #{program_name} -h | [ -t { rsa | dss } ] host [...]"
  exit(exit_code)
end

# Parse the command line options.
def parse_options
    opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--type', '-t', GetoptLong::REQUIRED_ARGUMENT ]
    )
  key_types = [ 'ssh-rsa', 'ssh-dss' ]
  begin
    opts.each do |opt, arg|
      case opt
      when '--help'
        usage
      when '--type'
        case arg
        when 'rsa'
          key_types = [ 'ssh-rsa' ]
        when 'dsa'
          key_types = [ 'ssh-dss' ]
        else
          $stderr.puts "Unknown key type `#{arg}'"
          usage(2)
        end
      end
    end
  rescue GetoptLong::MissingArgument, GetoptLong::InvalidOption
    usage(2)
  end
  usage(2) if ARGV.empty?
  [ key_types, ARGV ]
end

# Returns an ASCII string representing the host key.
def get_host_key_str(key_types, host)
  key = Key.new
  session = Net::SSH::Transport::Session.new(
    host,
    :port => DEFAULT_SSH_PORT,
    :paranoid => key,
    :host_key => key_types
  )
  session.close
  "#{key} #{host}##{key.length}"
end

key_types, hosts = *parse_options
hosts.each do |host|
  key_str = get_host_key_str(key_types, host)
  puts ( hosts.length > 1 ? "#{host}: #{key_str}" : key_str )
end

