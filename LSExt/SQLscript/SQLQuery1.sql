use lansweeperdb;

go 

delete from dbo.rAsset 
where not exists
( select a.AssetId from dbo.tblAssets as a where a.AssetID = dbo.rAsset.AssetID )