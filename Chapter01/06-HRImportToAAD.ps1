#Implement log function
function logit($level, $message)

{


	switch($level)

	{
	
        1 {$prefix = "INFO: "}
        
		2 {$prefix = "WARNING: "}
        
		3 {$prefix = "ERROR: "}
        
		default {$prefix = "UNKNOWN"}

	}

    write-host $prefix$message

}


#Connect to the Microsoft Online Service

Logit 1 "Getting Microsoft Azure Active Directory Credentials...."


Connect-MsolService

#Set domain variable
Logit 1 "Gettting Domain Variable..."
$domain = Get-MsolDomain 

#Set configuration directory location
Logit 1 "Settting path to HR export file..."
$dir = "C:\Users\sb277\Documents\Mastering-Identity-and-Access-Management-with-Microsoft-Azure-Second-Edition-master\Chapter01"

#CSV HR export file to import in Azure Active Directory
Logit 1 "Import Users and assign License...."
(get-content "$($dir)\07-NewHire.csv") | foreach-object {$_ -replace "suryendub.onmicrosoft.com" , $domain.Name} | Set-Content "$($dir)\07-NewHire.csv"
import-csv "$($dir)\07-NewHire.csv" | foreach {
Get-Msoluser -userPrincipalName $_.UserPrincipalName  | set-msoluserlicense -addlicenses "$($domain.name -replace ".onmicrosoft.com" ,":EMSPREMIUM")"
}
(import-csv "$($dir)\07-NewHire.csv") | foreach {New-Msoluser -userPrincipalName $_.UserPrincipalName -displayname $_.displayname -firstname $_.firstname -lastname $_.lastname -password $_.Password -mobilephone $phone -forcechangepassword $false -usagelocation "CH" | set-msoluserlicense -addlicenses "$($domain.name -replace ".onmicrosoft.com" ,":EMSPREMIUM")","$($domain.name -replace ".onmicrosoft.com" , ":EMSPREMIUM")"}
