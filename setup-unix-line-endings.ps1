# setup-unix-line-endings.ps1

# 1. Create or overwrite the .gitattributes file
@"
*.sh text eol=lf
*.R  text eol=lf
Dockerfile text eol=lf
"@ | Set-Content -Encoding UTF8 -Path ".gitattributes"

# 2. Configure Git to convert CRLF to LF on commit (but not the other way around)
git config core.autocrlf input

# 3. Stage and normalize line endings
git add .gitattributes
git add --renormalize .
git commit -m "Setup .gitattributes and normalize line endings"

# 4. Create pre-commit hook
$hookContent = @"
#!/bin/bash
echo "?? Pre-commit: Converting .sh and .R files to LF..."
find . -type f \( -name "*.sh" -o -name "*.R" \) -exec dos2unix {} \; 2>/dev/null
echo "? Done converting line endings."
"@

$hookPath = ".git/hooks/pre-commit"
$hookContent | Set-Content -Encoding Ascii -Path $hookPath

# 5. Simulate 'chmod +x' in Git to make pre-commit executable
git update-index --chmod=+x $hookPath

Write-Host "`n✅ Setup complete. Your repository now auto-converts .sh and .R files to Unix line endings." -ForegroundColor Green
