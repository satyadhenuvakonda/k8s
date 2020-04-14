Make the k8s-master-install.sh script executable and execute it. 
NOTE: Read below before running the script. Mainly 
k8s

 Join the two Kube worker nodes to the cluster

    Copy the kubeadm join command that was printed by the kubeadm init command earlier, with the token and hash. Run this command on both worker nodes, but make sure you add sudo in front of it:
####################################################################################################
    sudo kubeadm join $some_ip:6443 --token $some_token --discovery-token-ca-cert-hash $some_hash
####################################################################################################
    Now, on the Kube master node, make sure your nodes joined the cluster successfully:
    kubectl get nodes
     Verify that all three of your nodes are listed. It will look something like this:
      NAME            STATUS     ROLES    AGE   VERSION
      ip-10-0-1-101   NotReady   master   30s   v1.12.2
      ip-10-0-1-102   NotReady   <none>   8s    v1.12.2
      ip-10-0-1-103   NotReady   <none>   5s    v1.12.2
     Note that the nodes are expected to be in the NotReady state for now.

####################################################################################################
 Set up cluster networking with flannel
    Turn on iptables bridge calls on all three nodes:
####################################################################################################
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p -->



docker build -t itincloud/jenkins-image:1.0 .
docker push itincloud/jenkins-image:1.0