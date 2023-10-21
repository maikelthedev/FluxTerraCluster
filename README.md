# FluxTerraCluster
A Terraformed Kubernetes cluster in Hetzner with Flux and Talos 

## License

Apache 2.0 License as requested by the project sponsor. 

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
11. Due date max (orientative) is 7th of October preferibly but not set in stone. 

## Desired artifact

A git repo (this one) with some terraform to deploy the cluster, and flux to maintain the workload. 

## Not needed

* To run any of the actual services on there other than Flux, Traefik and Cert-Manager. You could run a sample workload via Flux as experiment. 
* To use my own Hetzner account, client supplies API access to his (don't even dream of finding the keys to it here, I wasn't born yesterday, I've been doing this for a while). 
* To create my own Talos OS snapshot, client supplies his own ready-made snapshots for this (a quick google also reveals they aren't hard to produce though). 

## Optional stretch:

* Being able to add x86 worker nodes (there are snapshots for this too)

## How to run this:

1. You'll need to create a terraform.tfvars file with content similar to terraform.tfvars-sample. In the sample one I explained each variable. Check variables.tf for clarity. 
2. optional.tf is, as it states, optional, not part of the requirements. I use it to assign DNS names because Digital Ocean DNS is free, so by using it I make my life simpler and when Flux deploys the ingress and asks Let's Encrypt for the certificates it can already access them through their DNS names by having this in place. You can replace that (and the provider) with whatever DNS solution you use. 
3. You'll need to point your deployment servers (servers.tf) to a snapshot image with Talos. [This link]( https://www.talos.dev/v1.5/talos-guides/install/cloud-platforms/hetzner/) explains how to create it. 
4. For Velero backups I'm using S3 for simplicity. You can use your own Minio server easily. I do not recommend to use a Minio server that is also maintained by this very same deployment hence S3 since I don't want to code two deployments, not required. 
5. You'll need to amend cluster/dependent/certificates/issuer.yaml to **use your own email** since this file is read by Flux directly.  

Once you run a terraform apply, I usually paste this code in the shell to gain access. Obviously you need jq, talosctl and kubectl on your distribution. 

```bash
terraform output -json talos_talosconfig | jq -r . > /tmp/talosconfig && export TALOSCONFIG=/tmp/talosconfig && talosctl kubeconfig /tmp/kubeconfig --force && export KUBECONFIG=/tmp/kubeconfig && alias k=kubectl
```

## Test services
Once you run it it should show this two example services:

* Podinfo: in my example in https://podinfo.mkl.lol
* Basic-nginx: in my example in https://nginx.mkl.lol

The later showcases using Hetzner CSI. As Kubernetes & Talos combo has no direct way to access the volume, the simplest way to create a simple index.html file to be used by that NGINX server is by accessing the volume via any of the pods plugged to it:

```bash
kubectl get pods | grep nginx 
# Use the name of any pod for the next, here I'm using my-nginx-5dfbdf99f7-bnxsl
k exec -ti my-nginx-5dfbdf99f7-bnxsl -- bash
# Create some simple index.html file with
echo '<html><head><title>Hello World</title></head><body><h1>Hello</h1><p>World</p></body></html>' > /usr/share/nginx/html/index.html
# Exit the pod
```
Now if you navigate to https://nginx.mkl.lol you shall see the sample page. 

When you delete the cluster, the volume created by this is NOT deleted, which is understandably the expected behaviour. When you re-create the cluster with Terraform it'll use a different volume (expected behaviour) unless you configured backups with Velero and restore from them in which case it'll use the old volume with your data. 

## Terraform destroy

Normally doesn't happen but if you get stuck for any reason on resources that are going to be deleted anyway once the servers are gone, you can manually get rid of them from terraform state with 

```bash
terraform state rm RESOURCE
```
When it has happened it's been kubernetes.velero or flux_bootstrap_git.this. For some reason Terraform's gone mental, deleted the load balancer first and then tried to reach the Kube cluster (impossible if the LB is missing or has target or services missing). 
It **normally** deletes them in the right order. 

## Flux fun

Now, if you want to add stuff or remove stuff I recommend as point of entry the file I set up in /clusters/steph/kustomize.yaml. Why this file? Because with it I could impose some order. Basically
- By virtue of having this file, Terraform executes it when bootstraping Flux. 
- By virtue of not having the rest of Flux files in the /steph/ folder, Flux doesn't go mental trying to run things in the wrong order. 
- I simplified what's independent and what isn't by separating them in folders. 
- That single file determines with a single kind, Kustomization (flux type) what depends on what else before loading anything of those deployments. By making everything a Kustomization I can safely use depends_on without conflicts. 

You can add anything else (or remove it) starting from that kustomization.yaml file. e.g.: get rid of the sample nginx by removing its kustomization from it. Add your own deployment by creating a folder in either independent or dependent and recycling any of the definitions in that file to point to it. 

## Other stuff

If you want to see my reasoning while I was (or I am, I might do more changes) coding feel free to read whatAmIupTo.md

Any questions I'm reachable in Matrix: @maikelthedev:matrix.org