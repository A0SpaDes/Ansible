#!/bin/sh

read -p 'Enter the name of ServiceAccount : ' name

export CLIENT=$name

echo -e "\nUsername is: ${CLIENT}"

#Generate ServiceAccount

cat << EOF >> ${CLIENT}-sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${CLIENT}-sa
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${CLIENT}-sa
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: ${CLIENT}-sa
  namespace: kubernetes-dashboard
EOF

kubectl apply -f ${CLIENT}-sa.yaml

#Create Secret to long-lived Bearer Token for ServiceAccount
cat << EOF >> secret-token.yaml
apiVersion: v1
kind: Secret
metadata:
  name: sys-admin-05-sa
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: "sys-admin-05-sa"   
type: kubernetes.io/service-account-token
EOF

export SACLIENT=$(kubectl get secret sys-admin-05-sa -n kubernetes-dashboard -o jsonpath={".data.token"} | base64 -d)
echo -e "\nToken for ${CLIENT} is: \n${SACLIENT}"
