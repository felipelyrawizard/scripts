library(RDCOMClient)

# busca as informações do outlook instalado na maquina
OutApp <- COMCreate("Outlook.Application")
outMail = OutApp$CreateItem(0)
outMail$GetInspector()
Signature <- outMail[["HTMLbody"]]

ano = 2019
mes = 11
outMail[["To"]] = "felipeinsonia@gmail.com"
outMail[["subject"]] = paste("IMPORTA FATURA AF ", ano,mes,sep="")

outMail[["HTMLbody"]] = paste0('Prezados,',"<p>" ,
                               'Encaminhamos a tabela contendo a consolidação dos dados',"<p>",
                               'Atenciosamente',"<p>",
                               'Equipe XXXX')

print(paste('EMAIL ','mes:',mes,',ano:',ano,sep=""))
outMail$Send()
