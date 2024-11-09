# Set the role from chezmoi
$role = "{{ .role }}"

# Set a list of the applications that need to be installed
$packages = @(
        "AgileBits.1Password",
        "Beeper.Beeper",
        "Git.Git",
        "GoLang.Go",
        "7zip.7zip",
        "Neovim.Neovim",
        "Microsoft.PowerShell",
        "GnuPG.Gpg4win",
        "JanDeDobbeleer.OhMyPosh",
        "Microsoft.PowerToys",
        "Microsoft.VisualStudioCode",
        "Microsoft.WindowsTerminal",
        "Mozilla.Firefox",
        "VideoLAN.VLC",
        "OBSProject.OBSStudio",
        "Zig.Zig",
        "MartiCliment.UniGetUI"
    )

# Add in the personal packages if the role is personal
if ($role -eq "personal") {
    $packages += "Audacity.Audacity"
    $packages += "BlenderFoundation.Blender"
}

# Sort the list of packages
$packages = $packages | Sort-Object

# Get a list of the packages that are currently installed
Write-Host "Getting list of installed packages"

# Set the path to export the installed packages to
$path = [IO.Path]::Combine($env:TEMP, "installed.json")

# Build up the command to run
$cmd = "winget export -o {0}" -f $path
Invoke-Expression $cmd

if (!(Test-Path -Path $path)) {
    Write-Error "Unabled to find list of installed applications"
    exit(1)
}

# Read in the contents of the file
$installed = Get-Content -Path $path -Raw | ConvertFrom-JSON

# Iterate around the packages that need to be installed
foreach ($package in $packages) {

    # get the status of the package
    Write-Host ("Checking for: {0} " -f $package) -NoNewLine
    $status = $installed.sources[0].Packages.PackageIdentifier -contains $package
    if ($status) {
        Write-Host -ForegroundColor Green "[Installed]"
    } else {
        Write-Host -ForegroundColor Yellow "[Not Installed, installing ....]"

        # Define the command to run to install the packages
        $cmd = "winget install --id {0} --source winget" -f $package

        Invoke-Expression $cmd
    }

}