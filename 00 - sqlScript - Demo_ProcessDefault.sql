/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	RESET SOURCE DB
	------------------------------------------------------
		USE [master]
		GO
		ALTER DATABASE [AWDW_SQLSat_TabularProcessing] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
		GO
		DROP DATABASE [AWDW_SQLSat_TabularProcessing]
		GO
		RESTORE DATABASE [AWDW_SQLSat_TabularProcessing] 
			FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\AWDW_SQLSat_TabularProcessing.bak' 
			WITH  FILE = 1,  
			NOUNLOAD,  
			STATS = 5
		GO
		USE AWDW_SQLSat_TabularProcessing;
		GO
		
		/* REMOVE DATA FOR 2014 */
		DELETE 
		FROM	dbo.FactInternetSales
		WHERE	OrderDateKey BETWEEN 20140101 AND 20141231
		;

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	DEMO 00
	------------------------------------------------------
	0. delete tabular model
	1. deploy tabular model
	2. process tabular model (ProcessDefault)
	3. query tabular model (DAX Studio)

	(commands below)
	4. add transactions from 2014
	5. process tabular model (ProcessDefault)
	6. query tabular model (DAX Studio)
	7. process tabular model (ProcessFull)
	8. query tabular model (DAX Studio)

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/



USE AWDW_SQLSat_TabularProcessing;
GO


/* Add transactions for 2014 */
INSERT INTO dbo.FactInternetSales
    (
        ProductKey,
        OrderDateKey,
        DueDateKey,
        ShipDateKey,
        CustomerKey,
        PromotionKey,
        CurrencyKey,
        SalesTerritoryKey,
        SalesOrderNumber,
        SalesOrderLineNumber,
        RevisionNumber,
        OrderQuantity,
        UnitPrice,
        ExtendedAmount,
        UnitPriceDiscountPct,
        DiscountAmount,
        ProductStandardCost,
        TotalProductCost,
        SalesAmount,
        TaxAmt,
        Freight,
        CarrierTrackingNumber,
        CustomerPONumber,
        OrderDate,
        DueDate,
        ShipDate
    )
SELECT	ProductKey,
        OrderDateKey,
        DueDateKey,
        ShipDateKey,
        CustomerKey,
        PromotionKey,
        CurrencyKey,
        SalesTerritoryKey,
        SalesOrderNumber,
        SalesOrderLineNumber,
        RevisionNumber,
        OrderQuantity,
        UnitPrice,
        ExtendedAmount,
        UnitPriceDiscountPct,
        DiscountAmount,
        ProductStandardCost,
        TotalProductCost,
        SalesAmount,
        TaxAmt,
        Freight,
        CarrierTrackingNumber,
        CustomerPONumber,
        OrderDate,
        DueDate,
        ShipDate
FROM	dbo.FactInternetSales_BACKUP
WHERE	OrderDateKey BETWEEN 20140101 AND 20141231
;
GO

SELECT	COUNT(*), SUM(SalesAmount)
FROM	dbo.FactInternetSales
WHERE	OrderDateKey BETWEEN 20140101 AND 20141231
;


/* process default */
/* re-run DAX query */
/* process full */
/* re-run DAX query */