#Check ADFS Primary Server and Failover to Secondary Server

Set-AdfsSyncProperties -Role PrimaryComputer
Set-AdfsSyncProperties -Role SecondaryComputer -PrimaryComputerName adfsin
