import csv
import fileinput
import os

def retorna_depara(nome):
    de = []
    para = []
    with open(nome, 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=';', quotechar='|') #tabs = \t
        #pula o cabecalho
        next(reader)
        for row in reader:
            de.append(row[0])
            para.append(row[1])
    return de,para

def substituir(Dir, velho, novo):
    for root, directories, filenames in os.walk(Dir):
        for filename in filenames:
            print(os.path.join(root,filename))
            f = open(os.path.join(root,filename), 'r',encoding="utf8") #retirar encoding quando exec em linux
            filedata = f.read()
            f.close()
            newdata = filedata.replace(velho, novo)
            f = open(os.path.join(root,filename), 'w',encoding="utf8") #retirar encoding quando exec em linux
            f.write(newdata)
            f.close()

            #with fileinput.FileInput(os.path.join(root,filename), inplace=True, backup='',bufsize=290000) as file:
            #    for line in file:
            #        print(line.replace(velho, novo), end='')
            #file.close()


###PRINCIPAL####

de,para = retorna_depara("de_para.csv")
Dir = input("Diretorio:")
os.chdir(Dir)

for i in range(len(de)):
    print("Atualizando de "+de[i] +" para "+para[i])
    substituir(Dir, de[i], para[i])

#velho = input("Texto velho:")
#novo = input("Texto novo:")

#for (dirpath, dirnames, filenames) in walk(Dir):
#    print (dirnames)
#    print (filenames)

#Filelist = os.listdir()
#Eprint('File list: ',Filelist)
