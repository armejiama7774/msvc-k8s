
@echo off
echo Iniciando proxy de Kubernetes...
start "" kubectl proxy
timeout /t 3 >nul
echo Abriendo el Dashboard en el navegador...
start "" http://localhost:8010/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
echo.
echo Obteniendo token de acceso para el usuario admin-user...
kubectl -n kubernetes-dashboard create token admin-user > dashboard-token.txt
echo Token guardado en dashboard-token.txt
echo.
echo Mostrando el token en pantalla:
type dashboard-token.txt
echo.
echo Copiando el token al portapapeles...
type dashboard-token.txt | clip
echo Token copiado al portapapeles.
pause
