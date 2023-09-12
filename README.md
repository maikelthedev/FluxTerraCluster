# FluxTerraCluster
A Terraformed Kubernetes cluster in Hetzner with Flux and Talos 

## License

Apache 2.0 License. 

## Requirements:

1. Multi-instance deployment on Hetzner cloud. 
2. Easy ongoing maintanability/upgradability (in other words, tweakable resources).
3. Hetzner CSI for K8S storage (to avoid OpenEBS or Ceph).
4. Talos Linux as base OS. 
5. Flux up and running. 
6. Hetzner LB (K8S api ingress), traefik and cert-manager defined in the repo for flux to deploy.
7. Ampere (ARM) instances to lower the cost. 
8. IPv4 and 6 for all. 
9. 3xCAX11 for the control plane nodes, and 2xCAX31 for the workers. 
10. Velero for backups to S3-type stuff.
11. Due date max is 7th of October. 

## Desired artifact

A git repo (this one) with some terraform to deploy the cluster, and flux to maintain the workload. 

## Not needed

* To run any of the actual services on there other than Flux, Traefik and Cert-Manager. You could run a sample workload via Flux as experiment. 
* To use my own Hetzner account, client supplies API access to his (don't even dream of finding the keys to it here, I wasn't born yesterday, I've been doing this for a while). 
* To create my own Talos OS snapshot, client supplies his own ready-made snapshots for this (a quick google also reveals they aren't hard to produce though). 

## Some initial thoughts

* Run a Min.io single-node development server as destination for the Velero backups. This should be configurable in the Terraformed code. 
* Make everything that can be a variable, a variable. So all that's needed for upgrades is to change some tfvars file. 
* To configure software running on each instance you can always pass cloud-init config directly from terraform. 

## Some reading:

* https://github.com/hetznercloud/csi-driver
