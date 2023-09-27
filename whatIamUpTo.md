- [x] Design cloud
- [x] Recreate locally
- [x] Add Talos OS to it
- [ ] Add Flux
- [ ] Run podinfo as a template for everything else

## On his cloud
- [ ] Add Talos to the current cloud using his image
	- [ ] Added label controlplane
- [ ] Run Talos
- [ ] Add Flux
- [ ] Add CSI

### Important

For flux you need

```sh
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>
```

Instructions: https://fluxcd.io/flux/get-started/

NOTICE: The launch of the cluster depends on what you send as controlplane.yaml and workers.yaml. You first need a LB before you launch those others as the IPs are required. Their order matters

1. Launch the cluster, you're going to need the ip of the load balancer
This command will require that IP and it creates the files to launch Talos: 

```bash
talosctl gen config talos-k8s-hcloud-tutorial https://<load balancer IP or DNS>:6443
```

167.235.111.202

talosctl gen config talos-k8s-hcloud-tutorial https://167.235.111.202:6443

Now you need the first control plane IP to bootstrap etcd. So this sets the node for the talosconfig (check the file?)

```bash
talosctl --talosconfig talosconfig config endpoint <control-plane-1-IP>

talosctl --talosconfig talosconfig config node <control-plane-1-IP>
```

And etcd with this

```bash
talosctl --talosconfig talosconfig bootstrap
```

1. Bootstrap Talos OS
2. Get the kubeconfig.yaml
With 

```bash
talosctl --talosconfig talosconfig kubeconfig .
```

1. Test it works with kubectl --kubeconfig kubeconfig.yaml get 

kubectl --kubeconfig kubeconfig get nodes -o wide

Change the IPs to private IPs that way you can control them through terraform and do the steps in the best order. 

Notice there's no ingress and no storage classes. 

Installing FLUx

```sh
kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml
```
NOw plug it to your github repo

Beware Flux will assume you have a valid kubeconfig so before do:

```sh
 export KUBECONFIG=/home/maikel/code/clients/stephen_newey/FluxTerraCluster/kubeconfig
```


if flux pre --check doesn't pass then there's an issue connecting to the cluster. 

```sh
export GITHUB_TOKEN="...."
export GITHUB_USER=maikelthedev

flux bootstrap github \
  --token-auth \
  --owner=maikelthedev \
  --repository=fleet-infra \
  --branch=main \
  --path=clusters/my-cluster \
  --personal
```

## Now with Flux installed

You still don't have an ingress but could use Flux to install it. 

Notice that Stephen does use Traefik

From the folder of fleet-infra do this

```sh
flux create source git podinfo \
  --url=https://github.com/stefanprodan/podinfo \
  --branch=master \
  --interval=1m \
  --export > ./clusters/my-cluster/podinfo-source.yaml
```

Then commit and push. 

You still have not deployed it, now do.

```sh
flux create kustomization podinfo \
  --target-namespace=default \
  --source=podinfo \
  --path="./kustomize" \
  --prune=true \
  --wait=true \
  --interval=30m \
  --retry-interval=2m \
  --health-check-timeout=3m \
  --export > ./clusters/my-cluster/podinfo-kustomization.yaml
```

Commit and push again

Now in theory you have Flux and podinfo all configured

## Let's configure an ingress to actually see if it works

Install helm https://helm.sh/docs/intro/install/

Add the traefik repo

https://platform9.com/learn/v1.0/tutorials/traefik-ingress

Created kubelb.mkl.lol as access to load balancer on D.O. for testing

