import youtube_dl
import glob
import os

# Felipe Lyra
# Downloader de midia do youtube - musicas

def download(url):
        a=url
        ydl_opts = {
                'format': 'bestaudio/best',
                'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',
                'preferredquality': '320',}],
            }

        with youtube_dl.YoutubeDL(ydl_opts) as ydl:
                try:
                        ydl.download([a])
                except:
                        print("An exception occurred")

def listDownloadedFiles():
        print('Lista de arquivos baixados:')
        mylist = [f for f in glob.glob("*.mp3")]
        for f in mylist:
                print(f)

#renomear para os webm para mp3
def renameFiles():
        files = os.listdir(os.curdir)
        for file in files:
                if '.webm' in file:
                        newfile = file.replace('.webm', '.mp3')
                        os.rename(file, newfile)

# principal
f = open("links.txt", "r")

for f in f.readlines():
        print(f)
        download(f)

renameFiles()

listDownloadedFiles()