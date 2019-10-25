from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
import time
import csv
import cx_Oracle

def atualizarSituacaoNaoAtualizadoOracle(cpf):
    print(" atualizacao de situacao para usuario")
    conn_str = u'BRUNONETO/BRUNONETO@examec01-scan4.mec.gov.br:1521/hmgora'
    conn = cx_Oracle.connect(conn_str)
    conn.autocommit = True
    cursor = conn.cursor()  # cria um cursor
    named_params = {'nu_cpf': cpf}
    cursor.execute("select P.NU_CPF, P.NO_PESSOA, P.st_atualizado from dbsigpet.TB_SIGPET_PESSOA p where p.nu_cpf = :nu_cpf", named_params)  # consulta sql

    result = cursor.fetchall()  # busca o resultado da consulta
    if result == None:
        print("Nenhum Resultado")
    else:
        for i in result:
            print(i)
            print("realizando update para nao atualizado...")
            statement = 'update dbsigpet.TB_SIGPET_PESSOA set st_atualizado = :1 where nu_cpf = :2'
            x = result[0]
            cursor.execute(statement, (None, str(x[0])))

    cursor.close()
    conn.close()


def abrir(nome):
    with open(nome, 'r') as csvfile:
        cpf = []
        reader = csv.reader(csvfile, delimiter=';', quotechar='|') #tabs = \t
        #pula o cabecalho
        next(reader)
        for row in reader:
            cpf.append(row[0])
    return cpf

# teste login no Gov Br
def testeLogin(driver,cpf):
    print("Testando Login do CPF " + cpf)

    #driver = webdriver.Chrome(executable_path=r"C:\path\to\chromedriver.exe")
    driver.get("http://hmg-sigpet.mec.gov.br")
    time.sleep(3)
    button = driver.find_element_by_xpath("/html/body/div[4]/div[2]/div[1]/div/a/button")
    button.send_keys(Keys.ENTER)
    time.sleep(3)
    user = driver.find_element_by_id("j_username")
    user.send_keys(cpf)
    time.sleep(2)
    button = driver.find_element_by_id("kc-login")
    button.send_keys(Keys.ENTER)
    time.sleep(2)
    passw = driver.find_element_by_id("j_password")
    passw.send_keys("teste123")
    time.sleep(2)
    button = driver.find_element_by_id("submit-button")
    button.send_keys(Keys.ENTER)
    time.sleep(5)
    #driver.close()


def testeLogout(driver,cpf):
    print("Testando Log out do CPF " + cpf)
    button = driver.find_elements_by_xpath("/html/body/div[4]/div[2]/div[2]/a") #sair
    if len(button) > 0:
        button[0].send_keys(Keys.ENTER)
    else:
        button = driver.find_elements_by_xpath("/html/body/div[4]/div[2]/div[4]/a") # outro sair
        if len(button) > 0:
            button[0].send_keys(Keys.ENTER)
        else:
            pass
    #button.send_keys(Keys.ENTER)
    #time.sleep(3)

# Formulario de atualizacao, somente para quem tem ja tem cadastro no sistema
def preencherFormularioAtualizacao(driver,cpf):
    print("Testando o preenchimento da atualizacao do CPF " + cpf)

    dtNascimento = driver.find_element_by_name("dtNascimento")
    #for i in range(10):
    #    print("apagando 10 vezes")
    #    dtNascimento.send_keys(Keys.BACK_SPACE)
    dtNascimento.clear()
    dtNascimento.send_keys("01/01/1980")

    tpSexo = driver.find_element_by_name("tpSexo")
    select = Select(tpSexo)
    select.select_by_value('M')

    dsNomeMae = driver.find_element_by_name("dsNomeMae")
    dsNomeMae.clear()
    dsNomeMae.send_keys("ADELINA DO NASCIMENTO")

    dsrG = driver.find_element_by_name("dsRg")
    dsrG.clear()
    dsrG.send_keys("191919")

    dsOrgaoExp = driver.find_element_by_name("dsOrgaoExp")
    select = Select(dsOrgaoExp)
    select.select_by_value('1')


    sgUfOrgaoExp = driver.find_element_by_name("sgUfOrgaoExp")
    select = Select(sgUfOrgaoExp)
    select.select_by_value('DF')

    dtExpedicaoRg  = driver.find_element_by_name("dtExpedicaoRg")
    dtExpedicaoRg.clear()
    dtExpedicaoRg.send_keys("01/01/1980")

    nuTelPrincipal = driver.find_element_by_name("nuTelPrincipal")
    nuTelPrincipal.clear()
    nuTelPrincipal.send_keys("61984754703")

    nuTelAlter = driver.find_element_by_name("nuTelAlter")
    nuTelAlter.clear()

    nuTelCelular = driver.find_element_by_name("nuTelCelular")
    nuTelCelular.clear()
    nuTelCelular.send_keys("61984754703")


    #paisNascimento = driver.find_element_by_id("select2-coDmPais-t9-container")
    paisNascimento = driver.find_element_by_class_name("select2-selection__rendered")
    paisNascimento.click()
    time.sleep(2)
    # search input
    input = paisNascimento.find_element_by_xpath("/html/body/span/span/span[1]/input")
    input.click()
    input.send_keys("Brasil")
    input.send_keys(Keys.ENTER)
    time.sleep(2)

    #selecao = paisNascimento.find_element_by_xpath("/html/body/div[6]/div/form/div[5]/div[1]/span[1]/span[1]/span")
    #selecao.click()

    ufNascimento = driver.find_element_by_name("ufNascimento")
    select = Select(ufNascimento)
    select.select_by_value('DF')


    #cidadeNascimento = driver.find_element_by_id("select2-dsLocalNascimento-3m-container")
    cidadeNascimento = driver.find_element_by_name("dsLocalNascimento")
    select = Select(cidadeNascimento)
    select.select_by_value('804')
    time.sleep(2)
    #select = cidadeNascimento.find_element_by_class_name("form-control")
    #cidadeNascimento.click()
    #input = cidadeNascimento.find_element_by_xpath("/html/body/span/span/span[1]/input")
    #input.click()
    #input.send_keys("Bras")
    #input.send_keys(Keys.ENTER)

    nuCep = driver.find_element_by_name("nuCep")
    nuCep.clear()
    nuCep.send_keys("72005261")
    nuCep.send_keys(Keys.TAB)
    time.sleep(10)

    dsLogradouro = driver.find_element_by_name("dsLogradouro")
    dsLogradouro.clear()
    dsLogradouro.send_keys("Rua 01 conjunto 01 casa")

    dsNumero = driver.find_element_by_name("dsNumero")
    dsNumero.clear()
    dsNumero.send_keys("01")

    dsUf = driver.find_element_by_name("dsUf")
    select = Select(dsUf)
    select.select_by_value('DF')
    time.sleep(2)

    try:
        cidadeEndereco = driver.find_element_by_name("dsMunicipio")
        #cidadeEndereco.send_keys(Keys.ENTER)
        #.sleep(2)
        select = Select(cidadeEndereco)
        time.sleep(2)
        select.select_by_value('804')
    except:
        print("problema")
        pass

    #cidadeEndereco.click()
    #input = cidadeEndereco.find_element_by_xpath("/html/body/span/span/span[1]/input")
    #input.send_keys("Bras")
    #input.send_keys(Keys.ENTER)


    dsBairro = driver.find_element_by_name("dsBairro")
    dsBairro.clear()
    dsBairro.send_keys("Bairro Teste")


    dsComplemento = driver.find_element_by_name("dsComplemento")
    dsComplemento.clear()
    time.sleep(2)

    # input btnSubmit (salvar)
    buttonSalvar = driver.find_element_by_name("btnSubmit")
    buttonSalvar.send_keys(Keys.ENTER)
    time.sleep(2)

def alterarDadosGovBr():
    ferramentas = driver.find_element_by_class_name("ferramentas-direita")
    ferramentas.click()
    time.sleep(2)
    changeDados = ferramentas.find_element_by_class_name("link-ssd")
    changeDados.click()
    time.sleep(2)

##########################################################################
# MAIN
##########################################################################


driver = webdriver.Chrome()

cpf = abrir("massa_testes6369.csv")

for i in range(len(cpf)): # todos
    if(cpf[i] == "07641336590"):
        while 1==1:
            atualizarSituacaoNaoAtualizadoOracle(cpf[i])
            testeLogin(driver,cpf[i])
            preencherFormularioAtualizacao(driver,cpf[i])
            alterarDadosGovBr()
            testeLogout(driver, cpf[i])



#for i in range(1): # len(cpf) todos
    #testeLogin(driver,cpf[i])
    #testeLogout(driver, cpf[i])

#for i in range(3,4): # len(cpf) todos
    #testeLogin(driver,cpf[i])
    #testeLogout(driver, cpf[i])