

library(readxl)
library(tidyverse)
library(mailR)

path <- dirname(rstudioapi::getSourceEditorContext()$path) # Directorio actual
setwd(path) # Definir Directorio de Trabajo

ventas <- read_xlsx("Ventas.xlsx")

correos <- read_xlsx("Correos.xlsx")

envio_auto <- function(x){
  
  nombre <- paste0("Reporte ",x,".csv") # Nombre del reporte

  ventas %>%
    filter(Sucursal == x) %>%
    group_by(Año, Producto) %>%
    summarise(Cantidad = sum(Cantidad),
              Precio = max(Precio),
              Ingresos = Cantidad*Precio) %>%
      write.csv(nombre) # Transformar y guardar la data

  destinatario <- correos$Correo[correos$Sucursal==x] # Elegir destinatario
  
  texto <- "Saludos, Adjunto el Reporte de Ventas." # Texto del correo
  
  send.mail(from = "micorreo@gmail.com",
            to = destinatario,
            subject = "Reporte de Ventas",
            body = texto,
            smtp = list(host.name = "smtp.gmail.com", port = 465, 
                        user.name = "micorreo@gmail.com",            
                        passwd = "******", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE,
            attach.files = nombre)

  file.remove(nombre) # Remover del computador el archivo enviado
  
}


sapply(
  unique(correos$Sucursal),
  envio_auto
)

