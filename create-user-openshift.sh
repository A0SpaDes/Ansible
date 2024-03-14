#!/bin/sh
  
read -p 'Enter the Username : ' name
read -p 'Enter the Group Name : ' group
read -p 'Enter the Namespace Name: ' namespace

export CLIENT=$name
export GROUP=$group
export NAMESPACE=$namespace
 
echo -e "\nUsername is: ${CLIENT}\nGroup Name is: ${GROUP}\nand Namespace is: ${NAMESPACE}"
  
mkdir ${CLIENT}
cd ${CLIENT}
      
#Generate key & csr
openssl req -new -newkey rsa:4096 -nodes -keyout ${CLIENT}.key -out ${CLIENT}.csr -subj "/CN=${CLIENT}"

#Generate csr yaml
cat << EOF >> ${CLIENT}-csr.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${CLIENT}-access
spec:
  signerName: kubernetes.io/kube-apiserver-client
  groups:
  - system:authenticated
  request: $(cat ${CLIENT}.csr | base64 | tr -d '\n')
  usages:
  - client auth
EOF

#CA extraction
oc config view --raw -o jsonpath='{..cluster.certificate-authority-data}' --kubeconfig=/home/truongnqk/.kube/kubeconfig | base64 --decode > ca.crt

#Set ENV
export CA_CRT=$(cat ca.crt | base64 -w 0)
export CONTEXT=mgmt
export CLUSTER_ENDPOINT=$(kubectl config view -o jsonpath='{.clusters[?(@.name == "'"$CONTEXT"'")].cluster.server}')
export USER=${CLIENT}
export CRT=$(cat ${CLIENT}.crt | base64 -w 0)
export KEY=$(cat ${CLIENT}.key | base64 -w 0)
export NAMESPACE=$namespace

#Create kubeconfig yaml
cat << EOF >> ${CLIENT}-kubeconfig.yaml
apiVersion: v1
kind: Config
current-context: ${CONTEXT}
clusters:
- name: OCB-OpenShift
  cluster:
    certificate-authority-data: ${CA_CRT}
    server: ${CLUSTER_ENDPOINT}
contexts:
- name: ${CONTEXT}
  context:
    cluster: OCB-OpenShift
    user: ${CLIENT}
    namespace: ${NAMESPACE}
users:
- name: ${CLIENT}
  user:
    client-certificate-data: $CRT
    client-key-data: $KEY
EOF
