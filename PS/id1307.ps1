$Date = (Get-Date).AddDays(-30)
Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-TerminalServices-SessionBroker-Client/Operational";id='1307';StartTime=$Date}  | ConvertTo-Html -Property Message, id, TimeCreated -Head $Header | Out-File -FilePath C:\ps\30_1307days.html
$Date = (Get-Date).AddDays(-1)
Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-TerminalServices-SessionBroker-Client/Operational";id='1307';StartTime=$Date}  | ConvertTo-Html -Property Message, id, TimeCreated -Head $Header | Out-File -FilePath C:\ps\1_1307days.html
$Date = (Get-Date).AddDays(-7)
Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-TerminalServices-SessionBroker-Client/Operational";id='1307';StartTime=$Date}  | ConvertTo-Html -Property Message, id, TimeCreated -Head $Header | Out-File -FilePath C:\ps\7_1307days.html
$Date = (Get-Date).AddDays(-14)
Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-TerminalServices-SessionBroker-Client/Operational";id='1307';StartTime=$Date}  | ConvertTo-Html -Property Message, id, TimeCreated -Head $Header | Out-File -FilePath C:\ps\14_1307days.html
