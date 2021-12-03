###
* Берет текущее время ($data) и выбирает диапозон дней (AddDays(-7))

* Идет в event-log microsoft-windows-terminalservices-remoteconnectionmanager/operational, выбирает ID=1149 и конвертирует в хтпл.

###
$Date = (Get-Date).AddDays(-7)
Get-WinEvent -FilterHashtable @{logname="microsoft-windows-terminalservices-remoteconnectionmanager/operational";id='1149';StartTime=$Date}  | ConvertTo-Html -Property Message, id, TimeCreated -Head $Header | Out-File -FilePath C:\ps\7days.html
$Date = (Get-Date).AddDays(-1)
Get-WinEvent -FilterHashtable @{logname="microsoft-windows-terminalservices-remoteconnectionmanager/operational";id='1149';StartTime=$Date}  | ConvertTo-Html -Property Message, id, TimeCreated -Head $Header | Out-File -FilePath C:\ps\1days.html
$Date = (Get-Date).AddDays(-14)
Get-WinEvent -FilterHashtable @{logname="microsoft-windows-terminalservices-remoteconnectionmanager/operational";id='1149';StartTime=$Date}  | ConvertTo-Html -Property Message, id, TimeCreated -Head $Header | Out-File -FilePath C:\ps\14days.html
$Date = (Get-Date).AddDays(-30)
Get-WinEvent -FilterHashtable @{logname="microsoft-windows-terminalservices-remoteconnectionmanager/operational";id='1149';StartTime=$Date}  | ConvertTo-Html -Property Message, id, TimeCreated -Head $Header | Out-File -FilePath C:\ps\30days.html