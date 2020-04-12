#! /bin/sh

# Add the Docker GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository:
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

# This update will add the localrepo
sudo apt-get update
# Installing docker docker-ce=18
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu
# Hold Docker at this specific version:
sudo apt-mark hold docker-ce

# check the status of docker
systemctl is-active --quiet docker
if [ $? -eq 0 ]; then
    echo DOCKER-IS-RUNNING
else
    echo FAILED-TO-START-DOCKER
fi

# Add the Kubernetes GPG key:
 curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Add the Kubernetes repository:
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update

# Kubernetes version is set and locked for 1.12.7-00
sudo apt-get install -y kubelet=1.12.7-00 kubeadm=1.12.7-00 kubectl=1.12.7-00
sudo apt-mark hold kubelet kubeadm kubectl

# master node installation
kube-join = sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# set up the local kubeconfig:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl version

# Join the two Kube worker nodes to the cluster

#    Copy the kubeadm join command that was printed by the kubeadm init command earlier, with the token and hash. Run this command on both worker nodes, but make sure you add sudo in front of it:
####################################################################################################
#    sudo kubeadm join $some_ip:6443 --token $some_token --discovery-token-ca-cert-hash $some_hash
####################################################################################################
#    Now, on the Kube master node, make sure your nodes joined the cluster successfully:
#    kubectl get nodes
#     Verify that all three of your nodes are listed. It will look something like this:
#      NAME            STATUS     ROLES    AGE   VERSION
#      ip-10-0-1-101   NotReady   master   30s   v1.12.2
#      ip-10-0-1-102   NotReady   <none>   8s    v1.12.2
#      ip-10-0-1-103   NotReady   <none>   5s    v1.12.2
#     Note that the nodes are expected to be in the NotReady state for now.

####################################################################################################
# Set up cluster networking with flannel
#    Turn on iptables bridge calls on all three nodes:
####################################################################################################
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p


#    Next, run this only on the Kube master node:
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
