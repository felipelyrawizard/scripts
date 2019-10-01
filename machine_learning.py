from sklearn import tree
from sklearn.tree import plot_tree
import matplotlib.pyplot as plt

#Pomar
#peso	superficie	resultado
#150	lisa	maça
#130	lisa	maça
#180	irregular	laranja
#160	irregular	laranja

lisa = 1
irregular = 0
maça = 1
laranja = 0

# treinamento
pomar =[[150,lisa],
        [130,lisa],
        [180,irregular],
        [160,irregular]]

resultado = [maça,maça,laranja,laranja]

classificador = tree.DecisionTreeClassifier()

classificador = classificador.fit(pomar,resultado)

#teste
peso = input("Entre com o peso:")
superficie = input("Entre com a superficie:")
resultadoUsuario = classificador.predict([[peso,superficie]])



if resultadoUsuario == 1:
    print("é uma maça")
else:
    print("é uma laranja")


# imprimindo arvore
#plot_tree(classificador, filled=True)
#plt.suptitle("Arvore de decisao")
#plt.legend(loc='lower right', borderpad=0, handletextpad=0)
#plt.axis("tight")
#plt.figure()
#plt.show()