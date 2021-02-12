# this is run from the project folder!

. ..\01.build.000.commons\powershell\assureEmpowerCreds.ps1

docker-compose up
docker-compose down

Write-Host "Image creation completed."

pause