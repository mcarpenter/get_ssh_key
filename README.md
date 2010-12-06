
# get_ssh_key

> Copyright 2010 Martin Carpenter, mcarpenter@free.fr.

`get_ssh_key.py` and `get_ssh_key.rb` perform identical functions
in their respective languages: they return the public component
of the active SSH key (RSA or DSA) on one or more remote servers.
(I initially wrote the Python version then decided I wanted to drop
this into a Rails app, so I translated it to Ruby).

## Usage

Usage is identical for both scripts:

    get_ssh_key.py [ -p port ] [ -t { rsa | dsa } ] host [...]
    get_ssh_key.rb [ -p port ] [ -t { rsa | dsa } ] host [...]
    
If the `-p` flag is not specified then the default SSH port (22)
is used.

If the `-t` flag is not specified then first an RSA key is sought,
then a DSA key. This concurs with most client implementations.

## Prerequisites

### Python

 * Paramiko, Python SSH library, http://www.lag.net/paramiko
 * PyCrypto, Python cryptographic library, http://www.pycrypto.org/

### Ruby

 * Rubygems, http://rubyforge.org/projects/rubygems/
 * Net::SSH v2, Ruby SSH gem, http://net-ssh.rubyforge.org/

## Output

Ouput is identical for both scripts: standard OpenSSH-style public key
format (base-64 ASCII encoded):

    key_type key comment

If more than one host key is requested then each key (line) is prefixed
by `host: `.

 * `key_type` is typically `ssh-rsa` or `ssh-dss`.
 * `key` is the base-64 encoded key.
 * `comment` is of the form `host#key_length_in_bits`

## Examples

    $ get_ssh_key.py -t dsa 127.0.0.1
    ssh-dss AAAAB3NzaC1kc3MAAACBAIRwDKmnYdaBzjWM/LT1dVtImAOv9o/hrnNPeJBrgdO6p57r2CaR+h22Od6qNJZob9Q/aSRlG8GGmftuxLvtI8LEaxdfnBcvJu7HrhzSsN/+EqhVNstktKfaVVSuUs1UiBUdOY5EFLCq3J2VPBx2PYfWo9CC9qSixa4wowiZNldBaaaafQDNclEAN5I4007gQH/qxmlqK/wLKJSD34fLeURPGCH/8DUEW5uvx/VOemUVgb5VtdKv4I/4/fhaLIpp9KoejerKi1+tczCYaJN6PHylnVWeYeOHjqX8IjeK7hxdQKpkw/JCCSF3mHhB6exqCt8nJY3osLkr412fzouTO2mVYPzwtP4uV7iqQSzXQm17pIqg3wuU0dh+UTJE3QAAAIAb7bEbz/aghjXuoNvHm2ROeXML+oyNLFu+dZMPYs5gaPKhfdv/4bABZyWFlRFpuEhwu4Sxr82d9tK8MIZoVBOWENHKMVCLbFfL/Asfsyge3WLukTAqdSy9wmfdCVJDXHoOwhE97PdDSuvC9UTTktJ0hO+3X0ULv6RVit6mxp0wgQ== 127.0.0.1#1024

    $ get_ssh_key.rb 127.0.0.1 rootshell.be 
    127.0.0.1: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAs1HwTgFu0b05tcPHoT23faFRa+135x8fs34sljsdf9234jtCb4KvFb6uGIeyUjXSBAManMQ4p/A9bKqTxLru0lATJshKm4mfL+/odYSmxjBDKcccevoIWAwe8CuR5y0Io/W/oj+HVlY4q7RSqce1gH2zDmpxACNkSsTfxlzi0yM= 127.0.0.1#1024
    rootshell.be: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxsRK5we+6n84VeCJUMseGqCjrQiMtui6lFz1BbTmDQZT3Btg057zVRn7JMYrA5zF7O2t0bnjjg8eQwDvj0UMgh/KMOpZY0oMYIxgBgjgVEMw57wqnbDUUlfhtsWgjPQ2FSHXARwNv1J6288VA5P9oJc47pKIcs15L27pW0D0iR8u86FeMARjAeACDae+IDY7dWKlj12G7FrGOpGjKhUDDwkpEfrJ4IuYJP0zCgmZbNZSlqN59F0DdfZVkRYdT/DRMJD40OEzTtiBJKT9W9v+Zz/QIYU//PXTTSiw44fX0pfF070z7im43e6e6D36Fc+rmOW6aidvShqV+oixQB7ICQ== rootshell.be#2048

