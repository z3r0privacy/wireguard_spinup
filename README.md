# wireguard_spinup
Automatically setup wireguard VPN server

# Deployment
Create a virtual maschine and then exec as root:
```bash
cd /root
git clone https://github.com/z3r0privacy/wireguard_spinup.git
cd wireguard_spinup && chmod +x setup.sh
./setup.sh
```

## From azure cli
Assuming the following:
- A Logic App with a HTTP Post trigger exists which creates a Ubuntu server VM
- The url for $logic_app_trigger can be retrieved from the logic app in designer view
```powershell
$logic_app_trigger = "https:/xxx.region.logic.azure.com:443/workflows/<workflowid>/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=<sig>"
Write-Host "Invoking Logic App..."
Invoke-RestMethod -Method Post $logic_app_trigger
Write-Host "Waiting 2 Minutes for finishing up VM creation..."
sleep 120
Write-Host "Running Setup-Script..."
$script_res = az vm run-command invoke -g <ressource_group_name> -n <vm_name> --command-id RunShellScript --scripts "git clone https://github.com/z3r0privacy/wireguard_spinup.git /root/wireguard_spinup && cd /root/wireguard_spinup && chmod +x setup.sh && ./setup.sh"
$result = $script_res | ConvertFrom-Json
Write-Host $result.value.message
```