#!/usr/bin/env bash
for id in {0..8}; do
  echo "juju ssh nova-compute/$id \"sudo ceph -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.nova-compute.keyring --id nova-compute status\""
  juju ssh nova-compute/$id "sudo ceph -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.nova-compute.keyring --id nova-compute status"
  echo "juju ssh nova-compute/$id \"sudo ceph -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.nova-compute.keyring --id nova-compute osd tree\""
  juju ssh nova-compute/$id "sudo ceph -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.nova-compute.keyring --id nova-compute osd tree"
done

echo juju ssh ceph-mon/0 'sudo ceph tell osd.* bench -f plain'
juju ssh ceph-mon/0 'sudo ceph tell osd.* bench -f plain'
