#!/usr/bin/ruby

# get_ssh_key.rb
# Copyright 2010 Martin Carpenter, mcarpenter@free.fr.
# Retrieves the current public SSH key from one or more remote hosts.

require 'rubygems'
require 'net/ssh'
require 'base64'

DEFAULT_SSH_PORT = 22

# Class to represent the server's public key. This must contain a
# #verify instance method since this callback is how we populate
# the @key attribute.
class Key

  # Length = ceil( log2(n+1) ), where n is the key modulus.
  # Uses the identity: logb(n) = logx(n) / logx(b).
  def length
    ( Math.log(@key.n.to_i + 1) / Math.log(2) ).ceil
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

# Returns an ASCII string representing the host key.
def get_host_key_str(host)
  key = Key.new
  transport = Net::SSH::Transport::Session.new(
    host,
    :port => DEFAULT_SSH_PORT,
    :paranoid => key)
  transport.close
  "#{key} #{host}##{key.length}"
end

hosts = ARGV

if hosts.empty?
  $stderr.puts "Usage: #{$0} host [...]\n"
  exit 2
end

hosts.each do |host|
  key_str = get_host_key_str(host)
  puts ( hosts.length > 1 ? "#{host}: #{key_str}" : key_str )
end

