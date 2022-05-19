#Include "Totvs.ch"
#Include "RptDef.CH"
#include "PROTHEUS.CH"
#INCLUDE 'TBICONN.CH'
#INCLUDE "TCBROWSE.CH"
#include "rwmake.CH"
#include "ap5mail.ch"
#INCLUDE "FWPrintSetup.ch"
#Include "TopConn.Ch"
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Inconformidades"
User Function MATA1000()
	Local aArea   := GetArea()
	Local oBrowse
	
	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZZ3")
	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Legendas
	//oBrowse:AddLegend( "SBM->BM_PROORI == '1'", "GREEN",	"Original" )
	//oBrowse:AddLegend( "SBM->BM_PROORI == '0'", "RED",	"Não Original" )
	
	//Ativa a Browse
	oBrowse:Activate()

	ADD OPTION aRot TITLE 'Visualizar'     ACTION 'VIEWDEF.MATA1000' OPERATION MODEL_OPERATION_VIEW   ACCESS 1 //OPERATION 1

	ADD OPTION aRot TITLE 'Incluir'        ACTION 'VIEWDEF.MATA1000' OPERATION MODEL_OPERATION_INSERT ACCESS 1 //OPERATION 3

	ADD OPTION aRot TITLE 'Alterar'        ACTION 'VIEWDEF.MATA1000' OPERATION MODEL_OPERATION_UPDATE ACCESS 1 //OPERATION 4

	ADD OPTION aRot TITLE 'Excluir'        ACTION 'VIEWDEF.MATA1000' OPERATION MODEL_OPERATION_DELETE ACCESS 1 //OPERATION 5

	
	RestArea(aArea)
Return Nil
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
// Static Function MenuDef()
// 	Local aRot := {}

// 	// ADD OPTION aRot TITLE 'Incluir' ACTION 'VIEWDEF.MATA1000' OPERATION MODEL_OPERATION_DELETE ACCESS 0
// 	ADD OPTION aRot TITLE 'Visualizar'     ACTION 'VIEWDEF.MATA1000' OPERATION MODEL_OPERATION_VIEW   ACCESS 1 //OPERATION 1

// 	ADD OPTION aRot TITLE 'Incluir'        ACTION 'VIEWDEF.MATA1000' OPERATION MODEL_OPERATION_INSERT ACCESS 1 //OPERATION 3

// 	ADD OPTION aRot TITLE 'Alterar'        ACTION 'VIEWDEF.MATA1000' OPERATION MODEL_OPERATION_UPDATE ACCESS 1 //OPERATION 4

// 	ADD OPTION aRot TITLE 'Excluir'        ACTION 'VIEWDEF.MATA1000' OPERATION MODEL_OPERATION_DELETE ACCESS 1 //OPERATION 5
// Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
	//Criação do objeto do modelo de dados
	Local oModel := Nil
	
	//Criação da estrutura de dados utilizada na interface
	Local oStZZ3 := FWFormStruct(1, "ZZ3")
	
	//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MATA1000",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	
	//Atribuindo formulários para o modelo
	oModel:AddFields("FORMZZ3",/*cOwner*/,oStZZ3)
	
	//Setando a chave primária da rotina
	oModel:SetPrimaryKey({'ZZ3_FILIAL','ZZ3_COD'})
	
	//Adicionando descrição ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	
	//Setando a descrição do formulário
	oModel:GetModel("FORMZZ3"):SetDescription("Relatorio de Inconformidades"+cTitulo)
Return oModel
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()
	//Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("MATA1000")
	
	//Criação da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStSBM := FWFormStruct(2, "ZZ3")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}
	
	//Criando oView como nulo
	Local oView := Nil
	//Criando a view que será o retorno da função e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formulários para interface
	oView:AddField("VIEW_ZZ3", oStSBM, "FORMZZ3")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZZ3', 'Dados do Grupo de Produtos' )  
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
	//O formulário da interface será colocado dentro do container
	oView:SetOwnerView("VIEW_ZZ3","TELA")
Return oView
