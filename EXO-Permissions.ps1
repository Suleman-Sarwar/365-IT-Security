// --- Get list of all user’s calendars default permissions ---
Get-Mailbox | ForEach-Object {Get-MailboxFolderPermission $_”:\calendar”} | Where {$_.User -like “Default”} | Select Identity, User, AccessRights //Option 1
Get-Mailbox | % { Get-MailboxFolderPermission (($_.PrimarySmtpAddress.ToString())+”:\Calendar”) -User *user1* -ErrorAction SilentlyContinue} | select Identity,User,AccessRights // Option2


// --- Check specific calendar permissions ---
Get-MailboxFolderPermission -Identity eli@domain.com:\calendar

// --- Office 365 Mailbox Access Roles ---

// Owner — read, create, modify and delete all items and folders. Also this role allows manage items permissions
// PublishingEditor — read, create, modify and delete items/subfolders
// Editor — read, create, modify and delete items
// PublishingAuthor — read, create all items/subfolders. You can modify and delete only items you create
// Author — create and read items; edit and delete own items NonEditingAuthor – full read access and create items. You can delete only your own items
// Reviewer — read-only
// Contributor — create items and folders
// AvailabilityOnly — read free/busy information from the calendar
// LimitedDetails
// None — no permissions to access folder and files.
