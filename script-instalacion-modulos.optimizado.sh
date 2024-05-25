#!/bin/sh

# este script se ejecuta si Powershell ya está instalado
pwsh -NonInteractive -c Install-Module ImportExcel -force $true
