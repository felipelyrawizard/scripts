from sklearn import tree

#temperatura | uso jacketa?
# 30    não
# 25    não
# 20    sim
# 15    sim
# 10    sim

sim = 1
nao = 0

# treinamento
usar_jacketa =[[30],[25],[20],[15],[10]]
resultado = [0,0,1,1,1]

classificador = tree.DecisionTreeClassifier()
classificador = classificador.fit(usar_jacketa,resultado)

#teste
temp = input("Entre com a temperatura:")
resultadoUsuario = classificador.predict([[temp]])

if resultadoUsuario == 0:
    print("não usar jacketa")
else:
    print("usar jacketa")