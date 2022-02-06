*** Settings ***
Library         RequestsLibrary
Library         Collections
Library         FakerLibrary   locale=pt_br

*** Variable ***
${URL_API}          https://reqres.in
${POST_CONSULTA}    /api/login
${POST_CADASTRO}    /api/users
${GET_CONSULTA}     /api/users/2
${CONTENT_TYPE}     application/json
&{MSG_RETORNO}      token={"token":"QpwL5tke4Pnpja7X4"}
&{MSG_REASON}       Ok=OK  Create=Created


*** Keywords ***
Conectar a API  
  Create Session    TesteApi     ${URL_API}

Criar header para a chamadas
  ${HEADER}=    Create Dictionary  Content-Type=${CONTENT_TYPE} 
  Set Suite Variable    ${HEADER}

Criar usuario para o sistema
  ${RANDOM_NOME}    FakerLibrary.Name
  ${RANDOM_JOB}     FakerLibrary.Job
  ${USUARIO}    Create Dictionary    Nome=${RANDOM_NOME}  Job=${RANDOM_JOB}
  Set Suite Variable    ${USUARIO}

  
Cadastrar um usuário no sistema
  Criar usuario para o sistema
  Criar header para a chamadas
  ${BODY}=      Create Dictionary  nome=${USUARIO.Nome} job=${USUARIO.Job}  
  ${RESPOSTA}=  POST On Session  TesteApi  ${POST_CADASTRO}  json=${BODY}  headers=${HEADER}
  log  ${RESPOSTA}
  Set Suite Variable  ${RESPOSTA} 

Teste: Validar o usuário cadastrado via API
  Cadastrar um usuário no sistema
  ${RES_BODY}=  Convert To String  ${RESPOSTA.content}
  Should Be Equal As Strings    ${RESPOSTA.url}          ${URL_API}${POST_CADASTRO} 
  Should Be Equal As Strings    ${RESPOSTA.reason}       ${MSG_REASON.Create}
  Should Be Equal As Integers   ${RESPOSTA.status_code}  201


Consultar o token do um usuário cadastrado no sistema
  Criar header para a chamadas
  ${BODY}=      Create Dictionary  email=eve.holt@reqres.in  password=cityslicka
  ${RESPOSTA}=  POST On Session  TesteApi  ${POST_CONSULTA}  json=${BODY}  headers=${HEADER}
  log  ${RESPOSTA}
  Set Suite Variable  ${RESPOSTA}  

Teste: validar o retorno do token
  Consultar o token do um usuário cadastrado no sistema
  ${RES_BODY}=  Convert To String  ${RESPOSTA.content}
  Should Be Equal As Strings    ${RESPOSTA.url}          ${URL_API}${POST_CONSULTA} 
  Should Be Equal As Strings    ${RESPOSTA.reason}       ${MSG_REASON.Ok}
  Should Be Equal As Integers   ${RESPOSTA.status_code}  200 
  Should Contain  ${RES_BODY}   ${MSG_RETORNO.token}


Consultar um usuário cadastrado no sistema pelo id
  Criar header para a chamadas
  ${RESPOSTA}=  Get Request  TesteAPI   ${GET_CONSULTA}  headers=${HEADER}
  log  ${RESPOSTA}
  Set Suite Variable  ${RESPOSTA} 

Teste: validar as informações do usuário cadastrado
  Consultar um usuário cadastrado no sistema pelo id
  Should Be Equal As Integers     ${RESPOSTA.status_code}           200
  Dictionary Should Contain Key   ${RESPOSTA.json()}  data
  Dictionary Should Contain Item  ${RESPOSTA.json()["data"]}        id            2
  Dictionary Should Contain Item  ${RESPOSTA.json()["data"]}        email         janet.weaver@reqres.in
  Dictionary Should Contain Item  ${RESPOSTA.json()["data"]}        first_name    Janet
  Dictionary Should Contain Item  ${RESPOSTA.json()["data"]}        last_name     Weaver
  Dictionary Should Contain Item  ${RESPOSTA.json()["data"]}        avatar        https://reqres.in/img/faces/2-image.jpg
  Dictionary Should Contain Key   ${RESPOSTA.json()}  support
  Dictionary Should Contain Item  ${RESPOSTA.json()["support"]}     url           https://reqres.in/#support-heading
  Dictionary Should Contain Item  ${RESPOSTA.json()["support"]}     text          To keep ReqRes free, contributions towards server costs are appreciated!