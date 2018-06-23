<# This is a common module which I implemented in one of my projec
to manage more than 500 IT environments in IT infrastructure
#>
<# Purpose -All details of environments are stored in DB
   A nightly job will update the DB with all current status of
   each environment and will create a CSV file. Data is fetched from
   a table which has all information like environment name, server name,
   DB name, status, server type, clustered or not.
   My common module is going to extract this data and create an object as well
   funcations which derives each detail when an environment name is passed to the function
   For example: A function like GetAllEnvironmentDetails  UAT01 will fetch all details from CSV and 
   store as an object.

#>

$environmentDeails = Import-CSV all_environment_details.csv
$serverDetails = Import-CSV $PSRoot\servers.csv   # file that contains resources details of a server

# All main and helper functions starts here
#Get all details of environment

function GetAllEnvironmentDetails($envname) {
	
	ForEach
	if($environmentDeails | Select-String "APPSERVER="){
		$AppServer = 
	}
	$AppServer = GetAppServer($envname)
	$DBServer = GetDBServer($envname)
	$envtype = GetEnvType($envname)
	# further attributes and getter methods for it can be added below

}
