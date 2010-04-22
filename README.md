
# get_host_key.py

`get_host_key.py` is a short python script to return the public
component of the active SSH key on one or more remote servers.

## Usage

    get_host_key.py host [...]

## Prerequisites

 * Python
 * Paramiko python SSH library, http://www.lag.net/paramiko

## Output

Ouput is in standard OpenSSH-style public key format (base-64 ASCII
encoded):

    key_type key comment

If more than one host key is requested then each key (line) is prefixed
by `host: `.

 * `key_type` is typically `ssh-rsa` or `ssh-dss`.
 * `key` is the base-64 encoded key.
 * `comment` is of the form `host#key_length_in_bits`

## Examples

    $ get_host_key.py 127.0.0.1
    ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAs1HwTgFu0b05tcPHoT23faFRa+135x8fs34sljsdf9234jtCb4KvFb6uGIeyUjXSBAManMQ4p/A9bKqTxLru0lATJshKm4mfL+/odYSmxjBDKcccevoIWAwe8CuR5y0Io/W/oj+HVlY4q7RSqce1gH2zDmpxACNkSsTfxlzi0yM= 127.0.0.1#1024

    $ get_ssh_key.py 127.0.0.1 rootshell.be 
    127.0.0.1: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAs1HwTgFu0b05tcPHoT23faFRa+135x8fs34sljsdf9234jtCb4KvFb6uGIeyUjXSBAManMQ4p/A9bKqTxLru0lATJshKm4mfL+/odYSmxjBDKcccevoIWAwe8CuR5y0Io/W/oj+HVlY4q7RSqce1gH2zDmpxACNkSsTfxlzi0yM= 127.0.0.1#1024
    rootshell.be: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxsRK5we+6n84VeCJUMseGqCjrQiMtui6lFz1BbTmDQZT3Btg057zVRn7JMYrA5zF7O2t0bnjjg8eQwDvj0UMgh/KMOpZY0oMYIxgBgjgVEMw57wqnbDUUlfhtsWgjPQ2FSHXARwNv1J6288VA5P9oJc47pKIcs15L27pW0D0iR8u86FeMARjAeACDae+IDY7dWKlj12G7FrGOpGjKhUDDwkpEfrJ4IuYJP0zCgmZbNZSlqN59F0DdfZVkRYdT/DRMJD40OEzTtiBJKT9W9v+Zz/QIYU//PXTTSiw44fX0pfF070z7im43e6e6D36Fc+rmOW6aidvShqV+oixQB7ICQ== rootshell.be#2048

