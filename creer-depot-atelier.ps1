# Script pour créer le depot atelier Git (historique volontairement "sale")
# A executer dans le dossier ou tu veux creer le repo (ex. Bureau).
# Usage : .\creer-depot-atelier.ps1
# Ou : cd C:\Users\abid\Desktop\Git; .\creer-depot-atelier.ps1

$dirName = "git-lab-clean-history"
if (Test-Path $dirName) {
    Write-Host "Le dossier $dirName existe deja. Supprime-le ou choisis un autre emplacement." -ForegroundColor Yellow
    exit 1
}

New-Item -ItemType Directory -Path $dirName | Out-Null
Set-Location $dirName

git init
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur : git init a echoue. Git est installe ?" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Commit 1 : init
"# Mon projet" | Out-File -FilePath README.md -Encoding utf8
git add README.md
git commit -m "init"

# Commit 2 : add file
"def hello(): pass" | Out-File -FilePath main.py -Encoding utf8
git add main.py
git commit -m "add file"

# Commit 3 : wip
"def hello(): return 'hi'" | Add-Content -Path main.py
git add main.py
git commit -m "wip"

# Commit 4 : fix
"# TODO" | Add-Content -Path main.py
git add main.py
git commit -m "fix"

# Commit 5 : fix typo
"def bye(): pass" | Add-Content -Path main.py
git add main.py
git commit -m "fix typo"

# Commit 6 : oups
"" | Add-Content -Path main.py
git add main.py
git commit -m "oups"

Write-Host "Depot cree dans $(Get-Location)" -ForegroundColor Green
Write-Host "Historique actuel (sale) :" -ForegroundColor Cyan
git log --oneline -6
Write-Host ""
Write-Host "Tu peux maintenant enchaîner sur l'atelier : amend, rebase -i, reset. Voir les slides ou lab-pratique.md." -ForegroundColor Cyan
Set-Location ..
