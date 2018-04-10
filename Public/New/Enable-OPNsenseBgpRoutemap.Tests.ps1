Import-Module PS_OPNsense

InModuleScope PS_OPNsense {
    $objects = @{ object = "BgpAspath"; command = "searchAsPath"}

    Describe -Tag "Quagga" "Enable-OPNsenseBgpRoutemap" {
        $uuid = @{}

        Context "Get UUIDs" {
                
            It "One UUID" -TestCases $objects {
                param($object, $command)
                {
                    $result = Invoke-OPNsenseCommand quagga bgp $command | Select-Object -ExpandProperty rows | Select-Object -ExpandProperty uuid
                    $uuid.Add($object, $result)
                } | should Not Throw
            }

        }

        Context "Enable-OPNsenseQuagga*" {

            It "Enable-OPNsenseQuagga<object>" -TestCases $objects {
                param($object, $command)
                { &"Enable-OPNsense$object" -Uuid $uuid[$object] } | should Not Throw
            }

            It "Check <object> is enabled" -TestCases $objects {
                param($object, $command)
                $( Invoke-OPNsenseCommand quagga bgp $command | Select-Object -ExpandProperty rows | Select-Object -ExpandProperty enabled ) | should be '1'
            }

        }

    }

}