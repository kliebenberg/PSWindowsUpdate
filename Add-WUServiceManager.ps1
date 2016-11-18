Function Add-WUServiceManager 
{
	<#
	.SYNOPSIS
	    Register windows update service manager.

	.DESCRIPTION
	    Use Add-WUServiceManager to register new Windows Update Service Manager.
    
	.PARAMETER ServiceID	
		An identifier for the service to be registered. 
		
		Examples Of ServiceID:
		Windows Update 					9482f4b4-e343-43b6-b170-9a65bc822c77 
		Microsoft Update 				7971f918-a847-4430-9279-4a52d1efe18d 
		Windows Store 					117cab2d-82b1-4b5a-a08c-4d62dbee7782 
		Windows Server Update Service 	3da21691-e39d-4da6-8a4b-b43877bcb1b7 
	
	.PARAMETER AddServiceFlag	
		A combination of AddServiceFlag values. 0x1 - asfAllowPendingRegistration, 0x2 - asfAllowOnlineRegistration, 0x4 - asfRegisterServiceWithAU
	
	.PARAMETER authorizationCabPath	
		The path of the Microsoft signed local cabinet file (.cab) that has the information that is required for a service registration. If empty, the update agent searches for the authorization cabinet file (.cab) during service registration when a network connection is available.
		
	.EXAMPLE
		Try register Microsoft Update Service.
	
		PS H:\> Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d"

		Confirm
		Are you sure you want to perform this action?
		Performing the operation "Register Windows Update Service Manager: 7971f918-a847-4430-9279-4a52d1efe18d" on target "MG".
		[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

		RegistrationState ServiceID                       IsPendingRegistrationWithAU Service
		----------------- ---------                       --------------------------- -------
                  		3 7971f918-a847-4430-9279-4a...                         False System.__ComObject

	.NOTES
		Author: Michal Gajda
		Blog  : http://commandlinegeeks.com/
		
	.LINK
		http://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc
	
	.LINK
		http://msdn.microsoft.com/en-us/library/aa387290(v=vs.85).aspx
		http://support.microsoft.com/kb/926464

	.LINK
        Get-WUServiceManager
		Remove-WUServiceManager
	#>
    [OutputType('PSWindowsUpdate.WUServiceManager')]
	[CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="High"
    )]
    Param
    (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$ServiceID,
		[Int]$AddServiceFlag = 2,
		[String]$authorizationCabPath
    )

	Begin
	{
		$User = [Security.Principal.WindowsIdentity]::GetCurrent()
		$Role = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

		if(!$Role)
		{
			Write-Warning "To perform some operations you must run an elevated Windows PowerShell console."	
		} #End If !$Role		
	}
	
    Process
	{
        $objServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
        Try
        {
            If ($pscmdlet.ShouldProcess($Env:COMPUTERNAME,"Register Windows Update Service Manager: $ServiceID")) 
			{
				
				$objService = $objServiceManager.AddService2($ServiceID,$AddServiceFlag,$authorizationCabPath)
				$objService.PSTypeNames.Clear()
				$objService.PSTypeNames.Add('PSWindowsUpdate.WUServiceManager')
				
			} #End If $pscmdlet.ShouldProcess($Env:COMPUTERNAME,"Register Windows Update Service Manager: $ServiceID"
        } #End Try
        Catch 
        {
            If($_ -match "HRESULT: 0x80070005")
            {
                Write-Warning "Your security policy don't allow a non-administator identity to perform this task"
            } #End If $_ -match "HRESULT: 0x80070005"
			Else
			{
				Write-Error $_
			} #End Else $_ -match "HRESULT: 0x80070005"
			
            Return
        } #End Catch
		
        Return $objService	
	} #End Process

	End{}
} #In The End :)




