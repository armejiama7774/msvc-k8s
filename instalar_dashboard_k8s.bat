@echo off
REM Instala el Kubernetes Dashboard en Docker Desktop

echo Aplicando manifiesto del dashboard...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

echo Creando usuario administrador...
echo apiVersion: v1 > admin-user.yaml
echo kind: ServiceAccount >> admin-user.yaml
echo metadata: >> admin-user.yaml
echo ^  name: admin-user >> admin-user.yaml
echo ^  namespace: kubernetes-dashboard >> admin-user.yaml
echo --- >> admin-user.yaml
echo apiVersion: rbac.authorization.k8s.io/v1 >> admin-user.yaml
echo kind: ClusterRoleBinding >> admin-user.yaml
echo metadata: >> admin-user.yaml
echo ^  name: admin-user >> admin-user.yaml
echo roleRef: >> admin-user.yaml
echo ^  kind: ClusterRole >> admin-user.yaml
echo ^  name: cluster-admin >> admin-user.yaml
echo ^  apiGroup: rbac.authorization.k8s.io >> admin-user.yaml
echo subjects: >> admin-user.yaml
echo ^- kind: ServiceAccount >> admin-user.yaml
echo ^  name: admin-user >> admin-user.yaml
echo ^  namespace: kubernetes-dashboard >> admin-user.yaml

kubectl apply -f admin-user.yaml

echo Obteniendo token de acceso...
kubectl -n kubernetes-dashboard create token admin-user > dashboard-token.txt

echo Iniciando proxy local...
start cmd /k kubectl proxy

echo Abriendo dashboard en el navegador...
start http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

echo Token de acceso guardado en dashboard-token.txt
pause
