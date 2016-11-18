# PSWindowsUpdate

## Update Count
The parameter -UpdateCount has been added that allows you to limit the number of updates that are installed. This was added to assist in back patching too many updates at once causing the entire update process to fail.

```powershell
PS C:\jp> Get-WuInstall -UpdateCount 50
```

## WSUS Support
An additional switch has been added to use a WSUS server that has been configured via Group\Local Policy. This switch sets ServerSelection to 1 for 'ManagedServer'. See [ServerSelection enumeration](https://msdn.microsoft.com/en-us/library/windows/desktop/aa387280(v=vs.85).aspx) for more info. 

```c
typedef enum  { 
  ssDefault        = 0,
  ssManagedServer  = 1,
  ssWindowsUpdate  = 2,
  ssOthers         = 3
} ServerSelection;
```

**Update**: It seems this work is not required. If you have a WSUS server configured via Group\Local Policy then it should show up as IsDefault=True when running Get-WUServiceManager.

```powershell
PS C:\jp> Get-WUServiceManager

ServiceID                            IsManaged IsDefault Name
---------                            --------- --------- ----
9482f4b4-e343-43b6-b170-9a65bc822c77 False     False     Windows Update
3da21691-e39d-4da6-8a4b-b43877bcb1b7 True      True      Windows Server Update Service
```

That said, the logic in Michal's script is correct in that when -WindowsUdpate, -MicrosoftUpdate, and -ServiceID are **not** specified the process will default to whatever ServiceID has IsDefault=True (in most cases the Windows Server Update Service). This logic is shown below.

```powershell
If($objService.IsDefaultAUService -eq $True)
{
    $serviceName = $objService.Name
    Break
}
```