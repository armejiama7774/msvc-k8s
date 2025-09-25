
@echo off
echo Eliminando Kubernetes Dashboard existente...
kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

echo Eliminando ServiceAccount y ClusterRoleBinding...
kubectl delete serviceaccount admin-user -n kubernetes-dashboard
kubectl delete clusterrolebinding admin-user

echo Esperando 5 segundos...
timeout /t 5 >nul

echo Instalando Kubernetes Dashboard...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

echo Creando usuario administrador...
(
echo apiVersion: v1
echo kind: ServiceAccount
echo metadata:
echo^  name: admin-user
echo^  namespace: kubernetes-dashboard
echo ---
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRoleBinding
echo metadata:
echo^  name: admin-user
echo roleRef:
echo^  kind: ClusterRole
echo^  name: cluster-admin
echo^  apiGroup: rbac.authorization.k8s.io
echo subjects:
echo^- kind: ServiceAccount
echo^  name: admin-user
echo^  namespace: kubernetes-dashboard
) > admin-user.yaml

kubectl apply -f admin-user.yaml

echo Esperando a que el Dashboard esté listo...
kubectl wait --for=condition=available deployment/kubernetes-dashboard -n kubernetes-dashboard --timeout=90s

echo Iniciando proxy en el puerto 8010...
start "" cmd /c "kubectl proxy --port=8010"

echo Esperando 3 segundos...
timeout /t 3 >nul

echo Obteniendo token de acceso...
kubectl -n kubernetes-dashboard create token admin-user > dashboard-token.txt

echo Abriendo Dashboard en el navegador...
start http://localhost:8010/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

echo Token guardado en dashboard-token.txt
pause
