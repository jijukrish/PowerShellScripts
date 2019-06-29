# Script to create an environment by installing software
# install services
# configure application server

function setupJbossEAP($computerName){
    Invoke-Command -ComputerName $computerName {Expand-Archive -LiteralPath D:\installation\binaries\jboss-eap-7.1.0.zip -DesinationPath
    D:\installation\binaries\jboss-eap-7.1.0\ -Force}
    Invoke-Command -ComputerName $computername {Move-Item -Path D:\installation\binaries\jboss-eap7.1.0 -DesinationPath E:\node -Force}
}

function setupJbossSVC($computerName){
    Invoke-Command -ComputerName $computerName{Expand-Archive -LiteralPath D:\installation\binaries\jbcs-jsvc-1.0.15.2-win6.x86_64.zip -DesinationPath
    D:\installation\binaries\jbcs-jsvc-1.0.15.2-win6.x86_64\ -Force}
    Invoke-Command -ComputerName $computerName{Move-Item -path D:\installation\binaries\jbcs-jsvc-1.0.15.2-win6.x86_64\jbcs-jsvc-1.0 -Desination
    F:\node - Force}
}

function createJbossVault($computername){
    Invoke-Command -ComputerName $computername{New-Item -Path $env:JBOSS_HOME\vault -ItemType Directory}
    Invoke-Command -computername $computername{keytool -genseckey -alias vault -storetype jceks -keyalg AES
    -keysize 128 -storepass "your password" -keypass "your password" -validity 30000
    -keystore E:\node\jboss-eap-7.1\vault\vault.keystore}

    --Create a secure password for DB_User and store in vault
    Invoke-Command -computername $computername{Invoke-Expression -Command:"cmd.exe /c '$env:JBOSS_HOME/bin/vault.bat'
    --keystore $env:JBOSS_HOME/vault/vault.keystore --keystore-password 'Your password' --alias vault --vault-block vb
    --attribute tst_db_user_password --sec-attr dbpassword --enc-dir $env:JBOSS_HOME/vault/ --iteration 120 --salt 1234qwer"}

    ##Keystore configuration
    Invoke-Command -computername $computername{New-Item -Path $env:JBOSS_HOME\keystore -ItemType Directory}
    Invoke-Command -computername $computername{Copy-Item "D:\installation\configure\ssl\*" -Desination "$env:JBOSS_HOME\keystore" -force -recurse}
}

function applyJbossPatch($computerName){
    Invoke-Command -computername $computername{Invoke-Expression -Command:"cmd.exe /c 'env:JBOSS_HOME/bin/jboss-cli.bat' 'patch apply d:\installation\binaries\jboss-eap-7.1.5-patch.zip"}

}

function setupEnvironment($computerName) {
#Rename drives
$scriptBlock = {
    param($hostname)
    $driveObj = Invoke-Command -computerName $hostname {Get-Volume}
    $driveObj | ForEach-Object {
        if($_.FileSysTemLabel -eq 'C') {
            Invoke-Command -ComputerName $hostname { Set-Volume -FileSysTemLabel "C" -NewFileSystemLabel "Windows"}
        } elseif($_.FileSysTemLabel -eq 'F'){
            Invoke-Command -ComputerName $hostname{Set-Volume -FileSysTemLabel "F" -NewFileSystemLabel "node"}
        }elseif($_.FileSysTemLabel -eq 'D'){
            Invoke-Command -ComputerName $hostname{Set-Volume -FileSysTemLabel "D" -NewFileSystemLabel "setup"}
        } elseif($_.FileSysTemLabel -eq 'L'){
            Invoke-Command -ComputerName $hostname{Set-Volume -FileSysTemLabel "G" -NewFileSystemLabel "Logs"}
        }
    }
}
Invoke-Command $scriptBlock -ArgumentList $computerName

#install Jboss EAP7.1
setupJbossEAP $computername
setupJbossSVC $computername
createJbossVault $computername
applyJbossPatch $computername
}