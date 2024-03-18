#!/bin/sh

read -p 'Enter the Username : ' name
read -p 'Enter the Group : ' group
read -p 'Enter the path of config (ex: /home/truongnqk/.kube/kubeconfig) : ' kubepath
read -p 'Enter the Namespace Name: ' namespace
read -p 'Enter the name cluster : ' cluster

export CLIENT=$name
export GROUP=$group
export kubepath=$kubepath
export NAMESPACE=$namespace
export CLUSTER=$cluster

echo -e "\nUsername is: ${CLIENT}\nGroup is: ${GROUP}\nPath kubeconfig is: ${kubepath}\nand Namespace is: ${NAMESPACE}"

mkdir ${CLIENT}
cd ${CLIENT}

#Generate key & csr
openssl req -new -newkey rsa:4096 -nodes -keyout ${CLIENT}.key -out ${CLIENT}.csr -subj "/CN=${CLIENT}/O=${GROUP}"

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

#Client extraction crt
oc create -f ${CLIENT}-csr.yaml
oc adm certificate approve ${CLIENT}-access
oc get csr ${CLIENT}-access -o jsonpath='{.status.certificate}' | base64 -d > ${CLIENT}-access.crt

#CA extraction crt
oc config view --raw -o jsonpath='{..cluster.certificate-authority-data}' --kubeconfig=${kubepath} | base64 --decode > ca.crt

#Set ENV
export CA_CRT=$(cat ca.crt | base64 -w 0)
export CONTEXT=${CLIENT}
export CLUSTER_ENDPOINT=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}')
export USER=${CLIENT}
export CRT=$(cat ${CLIENT}-access.crt | base64 -w 0)
export KEY=$(cat ${CLIENT}.key | base64 -w 0)
export NAMESPACE=$namespace

#Create kubeconfig yaml
cat << EOF >> ${CLIENT}-kubeconfig.yaml
apiVersion: v1
kind: Config
current-context: ${CONTEXT}
clusters:
- name: ${CLUSTER}
  cluster:
    certificate-authority-data: ${CA_CRT}
    server: ${CLUSTER_ENDPOINT}
contexts:
- name: ${CONTEXT}
  context:
    cluster: ${CLUSTER}
    user: ${CLIENT}
    namespace: ${NAMESPACE}
users:
- name: ${CLIENT}
  user:
    client-certificate-data: $CRT
    client-key-data: $KEY
EOF
