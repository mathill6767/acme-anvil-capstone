# Pre-stage AD computer accounts from CSV
# Requires: ActiveDirectory module
# CSV columns: Name, OUPath, Description, Enabled, DNSHostName

Import-Csv ".\ad_computer_prestage.csv" | ForEach-Object {
    $name = $_.Name
    $ou   = $_.OUPath
    $desc = $_.Description

    # Create the computer if it doesn't exist
    if (-not (Get-ADComputer -Filter "Name -eq '$name'" -ErrorAction SilentlyContinue)) {
        New-ADComputer -Name $name -Path $ou -Description $desc -Enabled $true
        Write-Host "Created: $name in $ou"
    } else {
        Write-Host "Exists:  $name"
    }
}
