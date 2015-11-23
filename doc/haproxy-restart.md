How to:

haproxy -f haproxy.cfg -p $(</var/run/haproxy.pid) -st $(</var/run/haproxy.pid)
