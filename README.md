# explore hypervisors

If you need hardware why not use AWS!

* provision some aws infrastructure
  * vpc + ipv6
* provision a server (physical because we want kubevirt)
* install kube
* install kubevirt

##  kubeadm 

```bash
$ kubeadm init --pod-network-cidr=192.168.0.0/16
$ kubectl get nodes
$ kubectl taint nodes --all node-role.kubernetes.io/control-plane-
$ kubectl run nginx-test --image=nginx --port=80 --restart=Never
$ kubectl get pods -o wide
```


## kubevirt

```bash
$ export VERSION=$(curl -s https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
$ kubectl create -f /etc/hypervisor-setup/kubevirt-operator.yaml
$ kubectl create -f /etc/hypervisor-setup/kubevirt-cr.yaml
$ kubectl get kubevirt.kubevirt.io/kubevirt -n kubevirt -o=jsonpath="{.status.phase}"
$ kubectl get all -n kubevirt
```

* wget https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-amd64


## Oddities

* even if cni config is there before kubeadm is run it doesn't think the cni plugin is initialized. observe modifying it after running kubeadm gets things going.
* sometimes there is no capacity for a physcial server. TF_LOG=DEBUG terraform apply to look at actual messages when trying to provision instead of waiting 20 minutes
* turn it off when  not  using it to save some cash. unprovisioning it and reprovision is slow.
* even though they are cheap graviton doesn't support virtualization so you need to use an intel.
* github does not support ipv6 so you have to do that the hardway :(

