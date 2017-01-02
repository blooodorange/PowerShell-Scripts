# CheckRemoteCertificate.ps1

$FQDN = Read-Host "Please enter hostname"
$Port = 443
$Threshold = 30
 
Try{
    $Connection = New-Object System.Net.Sockets.TcpClient($FQDN,$Port) 
  
    Try{
        $Stream = New-Object System.Net.Security.SslStream($Connection.GetStream())
        $Stream.AuthenticateAsClient($FQDN)
        $Cert = $Stream.Get_RemoteCertificate()
        $ValidTo = [datetime]::Parse($Cert.GetExpirationDatestring())
        Write-Host "Connection successful" -ForegroundColor Green
        Write-Host "FQDN: $FQDN"
        $ValidDays = $($ValidTo - [datetime]::Now).Days
        if($ValidDays -lt $Threshold){
            Write-Host "Status: Warning (Certificate expires in $ValidDays days)" -ForegroundColor Yellow
            Write-Host "CertExpiration: $ValidTo" -ForegroundColor Yellow
            }
        else{
            Write-Host "Status: OK" -ForegroundColor Green
            Write-Host "CertExpiration: $ValidTo" -ForegroundColor Green
            }
        }
    Catch{ Throw $_ }
    Finally{ $Connection.close() }
    }
Catch{
    Write-Host "Error occurred connecting to $FQDN" -ForegroundColor Yellow
    Write-Host "Status:" $_.Exception.InnerException.Message -ForegroundColor Yellow
    }
