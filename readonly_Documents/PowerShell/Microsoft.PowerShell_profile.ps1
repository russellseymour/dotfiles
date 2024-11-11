
# Determine if the theme file exists locally, if not pull from github repo
$repo_path = ""
$local_path = "~/.config/oh-my-posh/cloud-native-tokyo-night.omp.json"

if (Test-Path -Path $local_path) {
    oh-my-posh init pwsh --config $local_path | Invoke-Expression
}

if (!(Test-Path -Path env:\SSH_AUTH_SOCK)) {
    [Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", "\\.\pipe\openssh-ssh-agent", [System.EnvironmentVariableTarget]::User)
}

# Define aliases
Set-Alias -Name ls -Value Get-ChildItem
Set-Alias -Name ll -Value Get-ChildItem -Force

$openSshExecutable = (Get-Command -Name ssh -ErrorAction SilentlyContinue).Source
if (Test-Path $openSshExecutable) {
    $env:GIT_SSH=$openSshExecutable;
}

# Configure the SSH agent so that GPG can be used
# Get the status of the ssh-agent
$service = Get-Service -Name ssh-agent
$service
if ($service.Status -eq "Running") {
    Write-Host "Stopping the ssh-agent service"
    Stop-Service -Name ssh-agent
}

if ($service.StartType -ne "Disabled") {
    Write-Host "Disabling the ssh-agent service"
    Set-Service -Name ssh-agent -StartupType Disabled
}

gpg-connect-agent /bye