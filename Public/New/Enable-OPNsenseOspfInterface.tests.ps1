﻿Import-Module PS_OPNsense

InModuleScope PS_OPNsense {
    $objects = @{
        function = "Enable-OPNsenseOspfInterface";
        module = "quagga";
        controller = "ospfsettings"
    }
    switch ("Enable-OPNsenseOspfInterface".Substring(0,6)) {
        "Enable"  {
            $objects.add('state','1')
        }
        default {
            $objects.add('state','0')
        }
    }
    switch ("quagga") {
        { @("AcmeClient", "Freeradius", "IDS", "Monit", "Postfix", "ProxyUserACL", "Quagga", "Routes", "Siproxd", "Tinc", "Tor", "Zerotier") -Contains $_ } {           
            $objects.add('command',"searchinterface")
        }
        default {           
            $objects.add('command',"searchinterfaces")
        }
    }

    Describe -Tag "quagga" "Enable-OPNsenseOspfInterface" {
        $uuid = @()

        Context "Get UUIDs" {
                
            It "Get the UUID" -TestCases $objects {
                param($function, $module, $controller, $command, $state)
                {
                    $result = Invoke-OPNsenseCommand $module $controller $command | Select-Object -ExpandProperty rows | Select-Object -ExpandProperty uuid
                    $uuid += $result
                } | should Not Throw
                $uuid.count | Should BeGreaterThan 0
            }

            It "<module> : <function>" -TestCases $objects {
                param($function, $module, $controller, $command, $state)
                { Enable-OPNsenseOspfInterface -Uuid $uuid } | should Not Throw
            }

            It "Check <function> is <state>" -TestCases $objects {
                param($function, $module, $controller, $command, $state)
                $statecount = $( Invoke-OPNsenseCommand $module $controller $command | Select-Object -ExpandProperty rows | where-object { $_.uuid -in $uuid -and $_.enabled -eq $state } ).count

                $statecount | Should be $uuid.count
                $uuid.count | Should BeGreaterThan 0
            }

        }
    }
}
