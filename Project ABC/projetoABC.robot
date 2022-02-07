*** Settings ***
Resource    resourseProjectoABC.robot

Test Setup  Conectar a API

*** Test Case ***
TC01: Cadastro de usuário
  Cadastrar um usuário no sistema
  Teste: Validar o usuário cadastrado via API

TC02: Consulta token do usuário
  Consultar o token do um usuário cadastrado no sistema
  Teste: validar o retorno do token

TC03: Consulta de usuário cadastro no sistema
  Consultar um usuário cadastrado no sistema pelo id "2"
  Teste: validar as informações do usuário cadastrado

TC04: Atualizar usuario no sistema
  Realizar a atualização do nome e trabalho do usuário para o id "2"
  Teste: Validar alteração do usuário do sistema

TC05: Excluir um usuário cadastrado no sistema
  Cadastrar um novo usuário no sistema e identificar o Id do usuário
  Deletar o usuário pelo seu id cadastrado
  Teste: Validar usuário excluido pelo status code "204"

#EXEMPLO DE TESTE DETALHADO
#TC01: Usuario deseja se conectar a consulta de cadastro de endereço pelo CEP
#Step01: Quando o usuário digitar o CEP "xxxxx-xxx"
#Step02: Deve ser preenchido o endereço com o nome "rua do seu madruga" no elemento da pagina "nome_endereco"
#Step03: Deve ser preenchido o bairro com o nome "xxxxxxxx" e no elemento da pagina "nome_bairro"
#Step04: Deve ser preenchido o cidade com o nome "xxxxxxxx" e no elemento da pagina "nome_cidade"
#Step05: Deve ser preenchido o estado com o nome "xxxxxxxx" e no elemento da pagina "nome_sc"