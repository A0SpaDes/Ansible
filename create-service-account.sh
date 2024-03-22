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
export SACLIENT=$(kubectl -n kubernetes-dashboard create token ${CLIENT}-sa)
echo $SACLIENT
