# Fase en que se instala Powershell Core y el módulo ImportExcel, y se convierte el fichero
# XLSX a CSV
FROM ubuntu:jammy AS ubuntu-pwsh

RUN apt update && apt install wget -y

# instalar Powershell Core y el módulo ImportExcel con un script
WORKDIR /root
COPY ./script-instalacion-pwsh.sh .
RUN chmod u+x script-instalacion-pwsh.sh && sh -c ./script-instalacion-pwsh.sh && \
	rm script-instalacion-pwsh.sh

# usamos un script para convertir el archivo XLSX en CSV y dejarlo en el raíz del sistema de 
# ficheros, así aumenta la modularidad del código y es posible añadir otras funcionalidades más 
# fácilmente
WORKDIR /
COPY fichero.xlsx .
COPY script-pwsh.ps1 .
# el script se salta las 3 primeras lineas de la salida de Powershell porque son un warning 
# del módulo ImportExcel que no nos afecta
RUN pwsh -NonInteractive -c ./script-pwsh.ps1 | tail -n +3 > /fichero.csv


# fase que recibe el fichero CSV, no tiene Powershell instalado
FROM ubuntu:jammy

WORKDIR /
# script que muestra el contenido del archivo CSV
COPY script-mostrar-csv.sh .
RUN chmod u+x script-mostrar-csv.sh

# obtener el fichero CSV creado por ubuntu-pwsh
COPY --from=ubuntu-pwsh /fichero.csv .

ENTRYPOINT ["/script-mostrar-csv.sh"]
