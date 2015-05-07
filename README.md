# Devstack Manila
This creates a vagrant box for OpenStack Manila development.

Run:

```
$ vagrant up
$ vagrant ssh
$ source devstack/openrc demo demo
$ manila list
```

It will setup a vagrant box with Devstack and Manila.

## Restarting after reboot
I have found that using `rejoin_stack.sh` does not
work well.  Instead, the following has always worked
after a reboot:

```
$ cd devstack
$ ./unstack.sh
$ ./stack.sh
$ bash ~/post_install.sh
```
