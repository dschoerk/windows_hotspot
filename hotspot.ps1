Function Set-NetConnectionSharing
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $InternetConnection,

        [Parameter(Mandatory=$true)]
        [string]
        $LocalConnection,

        [Parameter(Mandatory=$false)]
        [switch]
        $Enabled
    )

    Begin
    {
        $netShare = $null

        try
        {
            # Create a NetSharingManager object
            $netShare = New-Object -ComObject HNetCfg.HNetShare
        }
        catch
        {
            # Register the HNetCfg library (once)
            regsvr32 /s hnetcfg.dll

            # Create a NetSharingManager object
            $netShare = New-Object -ComObject HNetCfg.HNetShare
        }
    }

    Process
    {
        # Find connections
        $publicConnection = $netShare.EnumEveryConnection |? { $netShare.NetConnectionProps.Invoke($_).Name -eq $InternetConnection }
        $privateConnection = $netShare.EnumEveryConnection |? { $netShare.NetConnectionProps.Invoke($_).Name -eq $LocalConnection }

        # Get sharing configuration
        $publicConfig = $netShare.INetSharingConfigurationForINetConnection.Invoke($publicConnection)
        $privateConfig = $netShare.INetSharingConfigurationForINetConnection.Invoke($privateConnection)

        if ($Enabled.IsPresent)
        {
            $publicConfig.EnableSharing(0)
            $privateConfig.EnableSharing(1)
        }
        else
        {
            $publicConfig.DisableSharing()
            $privateConfig.DisableSharing()
        }
    }
}

netsh wlan set hostednetwork mode=allow ssid=FederalBoobieInspector key=disissparta
netsh wlan start hostednetwork

Set-NetConnectionSharing -InternetConnection "Ethernet" -LocalConnection "LAN-Verbindung* 12" -Enabled
