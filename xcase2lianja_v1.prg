*/ created 20120821 HJF
*/ Copyright Professional Systems Plus, Inc, All Rights Reserved Worldwide
*/ Licensed under the Apache 2 Open Source License
IF !validatexCaseDir()
	lianja.showmessage("Must Have Valid xCase Model Dir To Process")
	RETURN .F.
ENDIF

TRY
	DO pspMetaTables  && create, and sync, the pspMetaTables
	DO changes_analyze WITH Lianja.oConfig, "myChanges" && cursor of entities, change types
	DO lianja_genscript WITH Lianja.oConfig, "myChanges"
	DO genscript_execute WITH Lianja.oConfig
	
CATCH TO loError
	IF VARTYPE(loError.USERVAL) = "O"
		loError = loError.USERVAL
	ENDIF
ENDTRY

IF VARTYPE(loError) = "O"
	=MESSAGEBOX("Failed: " + loError.MESSAGE
	RETURN .F.
ELSE
	RETURN .T.
ENDIF

PROCEDURE validatexCaseDir
	LOCAL lcDir
	IF !FILE("xcase2lianja.json")
		writejsontemplate()
		lcDir = GETDIR(,"Select xCase Model Directory)
		IF EMPTY(lcDir)
			myMessageBox("Please fill out xCase2Lianja.json information in the App directory and try again.",.T.)
			RETURN .F.
		ELSE
			updatexCaseModelDir(lcDir)
		ENDIF 
	ENDIF
	loX2L = X2Lobject()
	Lianja.addproperty("oConfig",loX2L)
ENDPROC

PROCEDURE writejsontemplate
	LOCAL loObj
	loObj = OBJECT()
	loObj.xCaseModelDirectory = "Fill In Directory Here"
	lcJson = json_encode(loObj)
	=STRTOFILE(lcJson,ADDBS(Lianja.appdir) + "xCase2Lianja.json")
ENDPROC

PROCEDURE X2Lobject
	LOCAL lcApp
	lcApp = Lianja.APPLICATION
	IF TYPE("Lianja." + lcApp) = "U"
		Lianja.ADDPROPERTY(lcApp,OBJECT())
		lcAppObj = EVAL("Lianja." + lcApp)
		lcAppObj = OBJECT()
	ELSE
		lcAppObj = EVAL("Lianja." + lcApp)
	ENDIF
	IF TYPE("Lianja." + lcApp + "oX2L") = "U"
		lcAppObj.oX2L = json_decode("xcase2lianja.json")
	ENDIF
ENDPROC

PROCEDURE pspMetaTables
	LOCAL lcPspMetaDb

	lcPspMetaDb = "pspMeta_" + Lianja.APPLICATION
	IF !DBUSED(lcPspMetaDb)
		IF !myOpenData(lcPspMetaDb)
			IF !createPspMetaTables(lcPspMetaDb)
				RETURN .F.
			ENDIF
		ENDIF
	ENDIF
ENDPROC

PROCEDURE createPspMetaTables
	LPARAMETERS tcPspMetaDB

	IF !myCreateDatabase(tcPspMetaDB)
		RETURN .F.
	ENDIF

	IF !myOpenData(tcPspMetaDB)
		RETURN .F.
	ENDIF

	SET DATABASE TO (tcPspMetaDB)
	llOK = createPspMeta4Tables() AND ;
		createPspMeta4Views() AND ;
		createPspMeta4Fields() AND ;
		createPspMeta4VFields() AND ;
		createPspMeta4Indexes() AND ;
		createPspMeta4Relations() AND ;
		createPspMeta4FldTriggers() AND ;
		createPspMeta4VFldTriggers() AND ;
		createPspMeta4EntityTriggers() AND ;
		createPspMeta4ViewTriggers()

	RETURN llOK
ENDPROC

PROCEDURE openxCaseTable
	LPARAMETERS tcEntity, tcAlias
	usein(tcAlias)
	OPENTABLE(tcEntity,tcAlias)

PROCEDURE createPspMeta4Tables()
	openxCaseTable("ddent","myddent")

ENDPROC

PROCEDURE createPspMeta4Views()

ENDPROC

PROCEDURE createPspMeta4Fields()

ENDPROC

PROCEDURE createPspMeta4VFields()

ENDPROC

PROCEDURE createPspMeta4Indexes()

ENDPROC

PROCEDURE createPspMeta4Relations()

ENDPROC

PROCEDURE createPspMeta4FldTriggers()

ENDPROC

PROCEDURE createPspMeta4VFldTriggers()

ENDPROC

PROCEDURE createPspMeta4EntityTriggers()

ENDPROC

PROCEDURE createPspMeta4ViewTriggers()

ENDPROC







