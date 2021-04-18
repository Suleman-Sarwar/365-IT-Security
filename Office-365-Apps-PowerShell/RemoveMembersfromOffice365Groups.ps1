# Removes users who are in the Office 365 group but not the security group
# loop through the O365 Group and remove anybody who is not in the security group

Write-Output "Looking for O365 Group members who are not in Security Group"
$O365GroupMembersToRemove = New-Object System.Collections.ArrayList
foreach ($O365GroupMember in $O365GroupMembers) {
        $userFound = 0
        foreach ($emailAddress in $O365GroupMember.EmailAddresses) {
# trim the protocol ("SMTP:")
                $emailAddress = $emailAddress.substring($emailAddress.indexOf(":")+1,$emailAddress.length-$emailAddress.indexOf(":")-1)
                if ($securityGroupMembersToAdd.Contains($emailAddress)) { $userFound = 1 }
        }
        if ($userFound -eq 0) { $O365GroupMembersToRemove.Add($O365GroupMember) }
}


if ($O365GroupMembersToRemove.Count -eq 0) {
        Write-Output "   ...none found"
} else {

# Remove members
        Write-Output " ... removing $O365GroupMembersToRemove"
                foreach ($memberToRemove in $O365GroupMembersToRemove) {
                Remove-UnifiedGroupLinks -Identity $O365GroupID -LinkType Members -Links $memberToRemove.name
        }
}

#---------------------------------------------------------------------------------------------------------------------