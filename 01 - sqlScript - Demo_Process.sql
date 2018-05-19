

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
		ALTER TABLE dbo.FactInternetSalesReason
			DROP CONSTRAINT FK_FactInternetSalesReason_FactInternetSales
		;
		GO
		DELETE 
		FROM	dbo.FactInternetSales
		WHERE	OrderDateKey BETWEEN 20140101 AND 20141231
		;


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	DEMO 01
	------------------------------------------------------
	1. deploy tabular model (w/ ProcessFull)
	2. query tabular model (DAX Studio)

	(commands below)
	3. add transactions from 2014
	4. process FactInternetSales (ProcessData)
	5. query tabular model (DAX Studio)
	6. process tabular model (ProcessRecalc)
	7. query tabular model (DAX Studio)

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/



USE AWDW_SQLSat_TabularProcessing;
GO

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

ALTER TABLE dbo.FactInternetSalesReason
	ADD CONSTRAINT FK_FactInternetSalesReason_FactInternetSales
		FOREIGN KEY (SalesOrderNumber, SalesOrderLineNumber)
		REFERENCES dbo.FactInternetSales (SalesOrderNumber, SalesOrderLineNumber)
;
GO