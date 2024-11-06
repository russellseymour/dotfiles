
# Determine if the theme file exists locally, if not pull from github repo
$repo_path = ""
$local_path = "~/.config/oh-my-posh/cloud-native-tokyo-night.omp.json"

if (Test-Path -Path $local_path) {
    oh-my-posh init pwsh --config $local_path | Invoke-Expression
}

# Define aliases
Set-Alias -Name ls -Value Get-ChildItem
Set-Alias -Name ll -Value Get-ChildItem -Force

$openSshExecutable = "C:\Windows\System32\OpenSSH\ssh.exe";
if (Test-Path $openSshExecutable) {
    $env:GIT_SSH=$openSshExecutable;
}

gpg-connect-agent /bye