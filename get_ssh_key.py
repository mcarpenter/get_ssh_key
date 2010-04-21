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

DEFAULT_SSH_PORT = 22

def main(argv=None):
    """Main entry point."""
    if argv is None:
        argv = sys.argv
    program_name = os.path.basename(argv[0])
    hosts = argv[1:]
    if not hosts:
        usage(program_name)
        sys.exit(2)
    for host in hosts:
        key_str = get_host_key_str(host)
        if len(hosts) > 1:
            print "%s: %s" % ( host, key_str )
        else:
            print "%s" % ( key_str )

def get_host_key_str(host):
    """Returns an ASCII string representing the host key."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((host, DEFAULT_SSH_PORT))
    transport = paramiko.Transport(sock)
    transport.connect()
    key = transport.get_remote_server_key()
    transport.close()
    sock.close()
    return ( "%s %s %s#%s" %
            ( key.get_name(), key.get_base64(), host, key.get_bits()) )

def usage(program_name):
    """Write usage to stderr."""
    sys.stderr.write("Usage: %s host [...]\n" % program_name)

if __name__ == "__main__":
    sys.exit(main())

