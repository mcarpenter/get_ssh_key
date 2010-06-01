#!/usr/bin/python

"""
get_ssh_key.py
Copyright 2010 Martin Carpenter, mcarpenter@free.fr.
Retrieves the current public SSH key from one or more remote hosts.
"""

import os.path
import paramiko
import socket
import sys
from optparse import OptionParser

DEFAULT_SSH_PORT = 22

def main(argv=None):
    """Main entry point."""
    if argv is None:
        argv = sys.argv
    ( key_types, hosts ) = parse_options(argv[1:])
    for host in hosts:
        key_str = get_host_key_str(key_types, host)
        if len(hosts) > 1:
            print "%s: %s" % ( host, key_str )
        else:
            print "%s" % ( key_str )

def parse_options(argv):
    """Parse the command line options. Exits on error with return
    code two, otherwise returns a list of key types and a list of
    host names."""
    parser = OptionParser("Usage: %prog [options] host [...]")
    parser.add_option('-t', '--type',
            help='specify key type TYPE (rsa or dsa)',
            metavar='TYPE')
    (options, hosts) = parser.parse_args(argv)
    if not options.type:
        key_types = [ 'ssh-rsa', 'ssh-dss' ]
    elif options.type == 'rsa':
        key_types = [ 'ssh-rsa' ]
    elif options.type == 'dsa':
        key_types = [ 'ssh-dss' ]
    else:
        print >> sys.stderr, 'Invalid key type %s' % options.type
        parser.print_help()
        sys.exit(2)
    if not hosts:
        parser.print_help()
        sys.exit(2)
    return ( key_types, hosts )


def get_host_key_str(key_types, host):
    """Returns an ASCII string representing the host key."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((host, DEFAULT_SSH_PORT))
    transport = paramiko.Transport(sock)
    options = transport.get_security_options()
    options.key_types = key_types
    transport.connect()
    key = transport.get_remote_server_key()
    transport.close()
    sock.close()
    return ( "%s %s %s#%s" %
            ( key.get_name(), key.get_base64(), host, key.get_bits()) )

if __name__ == "__main__":
    sys.exit(main())

