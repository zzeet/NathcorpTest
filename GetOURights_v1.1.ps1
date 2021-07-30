##Biswajeet###
$domain = get-addomain |select-Object distinguishedname
$domain = $domain.distinguishedname
$OU = Read-Host -Prompt 'Provide the OU name like OU=User, for child OU-> OU=childOU,OU=ParentOU'
$filename = $((Get-Date).ToString("yyyyMMdd_HHmmss"))+"_"+$ou
Write-output("Name,Object") | out-file $PSScriptRoot\$filename.csv -Encoding ascii
Set-Location AD:\$domain

$CheckOU = [adsi]::Exists("LDAP://$ou,$domain")
if($CheckOU -eq 'True')
{
$userRights = (Get-Acl -Path $OU).Access | Where-Object ActiveDirectoryRights -like *CreateChild* | Where-Object objectType -EQ bf967aba-0de6-11d0-a285-00aa003049e2 |Select-Object IdentityReference

$names = $userRights.IdentityReference
$ErrorActionPreference = "silentlycontinue"
Foreach($name in $names)
{
$split = $name -split "\\"
$name = $split[1]

If (Get-ADGroup $name) 
{
$Identity = 'Group'
}

If (Get-ADUser $name) 
{
$Identity = 'User'
}

else
{
$Identity = 'Unknown'
}
    
    Write-Output($name +","+ $identity) | Out-File $PSScriptRoot\$filename.csv -Append -Encoding ascii

}

Write-output("Check the csv file $filename where script is located for the results!")
}

else
{
Write-Output("OU does not exist!")
}
Write-Output("Press any key to exit...")
$Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown") | OUT-NULL
$Host.UI.RawUI.FlushInputbuffer()
