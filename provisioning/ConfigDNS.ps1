Add-DnsServerPrimaryZone -NetworkID 192.168.100.0/24 -ZoneFile "100.168.192.in-addr.arpa.dns"
$zoneName="100.168.192.in-addr.arpa"
$startingIP=10
$endingIP=30
$incrementingName=0
$preName="public"
$postName=".test.local"
 
while ($startingIP -le $endingIP) {
    
    $significanDigit="{0:D4}" -f $incrementingName
 
    Add-DnsServerResourceRecordPtr -Name "$startingIP" -ZoneName "$zoneName" -PtrDomainName "$preName$significanDigit$postName"
 
    $startingIP++
    $incrementingName++
 
}
