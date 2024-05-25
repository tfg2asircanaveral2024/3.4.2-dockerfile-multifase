# convertir el archivo con formato XLSX a CSV, y almacenarlo en el archivo /fichero.csv
Import-Excel -Path '/fichero.xlsx' -Worksheet "Hoja1" -startrow 2 -WarningAction SilentlyContinue |
 ConvertTo-Csv | Out-File '/fichero.csv'
