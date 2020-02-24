```
juju deploy ./saml-bundle.yaml
juju add-relation keystone keystone-saml-mellon
juju add-relation openstack-dashboard keystone-saml-mellon
juju add-relation openstack-dashboard:websso-trusted-dashboard keystone:websso-trusted-dashboard
openstack domain list
openstack domain create federated_domain #-> obtain created ID
vim rules.json # edit domain id and put one from previous step 
openstack project create federated_project --domain federated_domain
openstack group create federated_users --domain federated_domain #obtain group ID
openstack role add --group 505767e058434ee98d1f03f8871f79c9 --domain federated_domain Member # use group ID from previous step
openstack identity provider create --remote-id <URL> <name>
openstack mapping create --rules rules.json spc_mapping
openstack federation protocol create mapped --mapping spc_mapping --identity-provider <name>
juju config keystone-saml-mellon idp-name=spc user-facing-name='SPC via saml2'
```
