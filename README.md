# Dotfiles for Powershell on Windows (pwsh) and Zsh

## Windows Install

```powershell
winget install twpayne.chezmoi
chezmoi init --apply --verbose russellseymour
```

## Linux Install

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply russellseymour
```

### Transient Install

This is used only for transient environments like containers:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot russellseymour
```
