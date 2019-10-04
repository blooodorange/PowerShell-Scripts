# Check_ADFS.ps1
# Check AD FS 3.0 web service and certificates
# Created by Martin Walder
# Version 1.0

# Input

$FQDN = "sts.contoso.com"
$ThresholdCertWarning = 30 # days
$SMTPServer = "smtp.domain.com"
$Sender = "noreply@domain.com"
$Recipient = "email@domain.com"

# Check FederationMetadata.xml

Try{
    $Request = Invoke-WebRequest -Uri "https://$FQDN/FederationMetadata/2007-06/FederationMetadata.xml" -Method Get
    if($Request.StatusCode -ne "200" -and $Request.Content -notmatch "urn:oasis:names:tc:SAML:2.0:metadata"){
        Send-MailMessage -From $Sender -To $Recipient -Subject "AD FS - Check FederationMetadata.xml" -Body "Error accessing FederationMetadata.xml" -Priority High -SmtpServer $SMTPServer
        }
    }
Catch{
    Send-MailMessage -From $Sender -To $Recipient -Subject "AD FS - Check FederationMetadata.xml" -Body $_.Exception.InnerException.Message -Priority High -SmtpServer $SMTPServer
    }

# Check web service and service-communications certificate

Try{
    $Connection = New-Object System.Net.Sockets.TcpClient("$FQDN",443)
    Try{
        $Stream = New-Object System.Net.Security.SslStream($Connection.GetStream())
        $Stream.AuthenticateAsClient($FQDN)
        $WebServerCert = $Stream.Get_RemoteCertificate()
        $WebServerCertName = $WebServerCert.GetName()
        $WebServerCertSerial = $WebServerCert.GetSerialNumberString()
        $WebServerCertValidTo = [datetime]::Parse($WebServerCert.GetExpirationDateString())
        $WebServerCertValidDays = $($WebServerCertValidTo - [datetime]::Now).Days
        if($WebServerCertValidDays -lt $ThresholdCertWarning){
            Send-MailMessage -From $Sender -To $Recipient -Subject "AD FS - Check service-communications certificate" -Body "Service-communications certificate '$WebServerCertName' with serial number '$WebServerCertSerial' is about to expire (Valid to $WebServerCertValidTo)." -Priority High -SmtpServer $SMTPServer
            }
        }
    Catch{Throw $_}
    Finally{$Connection.close()}
    }
Catch{
    Send-MailMessage -From $Sender -To $Recipient -Subject "AD FS - Check web service" -Body $_.Exception.InnerException.Message -Priority High -SmtpServer $SMTPServer
    }

# Check token-decrypting certificate

$DecryptingCert = Get-AdfsCertificate -CertificateType Token-Decrypting | Where-Object {$_.IsPrimary -eq $true}
$DecryptingCertName = $DecryptingCert.Certificate.GetName()
$DecryptingCertSerial = $DecryptingCert.Certificate.GetSerialNumberString()
$DecryptingCertValidTo = [datetime]::Parse($DecryptingCert.Certificate.GetExpirationDateString())
$DecryptingCertValidDays = $($DecryptingCertValidTo - [datetime]::Now).Days
if($DecryptingCertValidDays -lt $ThresholdCertWarning){
    Send-MailMessage -From $Sender -To $Recipient -Subject "AD FS - Check token-decrypting certificate" -Body "Token-decrypting certificate '$DecryptingCertName' with serial number '$DecryptingCertSerial' is about to expire (Valid to $DecryptingCertValidTo)." -Priority High -SmtpServer $SMTPServer
    }

# Check token-signing

$SigningCert = Get-AdfsCertificate -CertificateType Token-Signing | Where-Object {$_.IsPrimary -eq $true}
$SigningCertName = $SigningCert.Certificate.GetName()
$SigningCertSerial = $SigningCert.Certificate.GetSerialNumberString()
$SigningCertValidTo = [datetime]::Parse($SigningCert.Certificate.GetExpirationDateString())
$SigningCertValidDays = $($SigningCertValidTo - [datetime]::Now).Days
if($SigningCertValidDays -lt $ThresholdCertWarning){
    Send-MailMessage -From $Sender -To $Recipient -Subject "AD FS - Check token-signing certificate" -Body "Token-signing certificate '$SigningCertName' with serial number '$SigningCertSerial' is about to expire (Valid to $SigningCertValidTo)." -Priority High -SmtpServer $SMTPServer
    }
