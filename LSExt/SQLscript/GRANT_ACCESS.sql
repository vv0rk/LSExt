use lansweeperdb;

go 

-- должны быть созданы группы AD 
	--VT_USERS	- все ¬“шники им предоставл€етс€ доступ 
		подключение к базе lansweeperdb
		чтение/запись	таблицы rMaterialRashod 
		чтение			все остальные таблицы
	--UIT_USERS	- пользовател€м вход€щим в эту группу предоставл€етс€ доступ 
		подключение к базе lansweeperdb
		чтение/запись	
			dbo.rSetRMHist;
			dbo.rModelComplect;
			dbo.rModelDevice;
			dbo.rMaterialLink;
			dbo.rMaterialRashod;
			dbo.rMaterialAnalog;
			dbo.rMaterialOriginal;
			dbo.rAsset
		чтение			все остальные таблицы
		

