


library(taskscheduleR)
library(stringr)

taskscheduler_create(taskname = "correos_automaticos", 
                     rscript = paste0(str_replace_all(path,"/","\\\\"),"\\correo_auto.r"), 
                     schedule = "MONTHLY", 
                     starttime = format(Sys.time(), "%H:%M"),
                     startdate = format(Sys.Date(), "%m/%d/%Y"),
                     modifier = 1,
                     Rexe = file.path(Sys.getenv("R_HOME"), "bin", "Rscript.exe"))


