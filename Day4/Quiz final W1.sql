CREATE PROCEDURE Production.CreateWorkOrderRouting(
    @productId int,
    @dayToManufacture int,
    @orderQty int,
    @stockedQty int,
    @startDate datetime
) as

BEGIN--BEGIN PROCEDURE
    BEGIN TRY -- Inserting to production.workorder
        BEGIN TRANSACTION
            -- inserting workorder first with parameter value
            insert into Production.WorkOrder(
                ProductID,
                OrderQty,
                ScrappedQty,
                StartDate,
                EndDate,
                DueDate
            )
            VALUES
            (
                @productId,
                @orderQty,
                @stockedQty,
                @startDate,
                DATEADD(day,@dayToManufacture,@startDate), --Make Enddate base on product.daytomanufacture and startdate
                DATEADD(day,@dayToManufacture,@startDate)  -- make due date same as enddate
            )
        PRINT 'Inserting to WorkOrder with productId '+CAST(@productId as NVARCHAR(25))+' has been succesfully'
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Inserting to WorkOrder with productId '+CAST(@productId as NVARCHAR(25))+' has fail';
        THROW;
    END CATCH
    -- end try catch production.workorder

    BEGIN TRY -- Inserting to production.workorderRouting
        BEGIN TRANSACTION
            -- declaring variable
            DECLARE @workOrderId int;
            DECLARE @listPrice money;
            DECLARE @locationBetweenStart int ;
            DECLARE @locationId int ;
            DECLARE @scheduledStartDate datetime;
            DECLARE @scheduledEndDate datetime;
            DECLARE @actualStartDate datetime;
            DECLARE @actualEndDate datetime;
            DECLARE @actualResourceHrs decimal(9,4);
            DECLARE @plannedCost money;
            DECLARE @actualCost money;

            select 
                @productId=ProductID,
                @workOrderId=WorkOrderID,
                @scheduledStartDate=StartDate,
                @scheduledEndDate=EndDate
            from Production.WorkOrder where ProductID=@productId
            set @actualStartDate= @scheduledStartDate;
            set @actualEndDate = @scheduledEndDate;
            set @actualResourceHrs=datediff(hour,@actualStartDate,@actualEndDate)-- get from differen hours between actual startdate and enddate

            -- this fiter below purposed to get location id base on product.listprice case
            select @listPrice=ListPrice from Production.Product where ProductID=@productId
                if @listprice<500
                    set @locationBetweenStart=50
                else if @listPrice>=500
                    set @locationBetweenStart=10

            insert into Production.WorkOrderRouting(
                WorkOrderID,
                ProductID,
                OperationSequence,
                LocationID,
                ScheduledStartDate,
                ScheduledEndDate,
                ActualStartDate,
                ActualEndDate,
                ActualResourceHrs,
                PlannedCost,
                ActualCost)
            select
                @workOrderId,
                @productId,
                ROW_NUMBER() over(order by locationid)as OperationSeq,
                LocationID,
                @scheduledStartDate,
                @scheduledEndDate,
                @actualStartDate,
                @actualEndDate,
                @actualResourceHrs,
                (
                    select CostRate*CAST(@actualResourceHrs as money) -- means location.costrate * actualresourcehours
                ) as plannedCost,
                (
                    select CostRate*CAST(@actualResourceHrs as money) -- make actual cost same as plannedcost
                ) as actualCost
                from Production.Location
                where LocationID BETWEEN @locationBetweenStart and 60 -- filtering fetch data from location.location base on production.listcost 
        PRINT 'Inserting to WorkOrderRoute with workOrderID '+CAST(@workOrderID as NVARCHAR(25))+' has been succesfully'
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Inserting to WorkOrderRoute with workOrderID '+CAST(@workOrderID as NVARCHAR(25))+' has fail';
        THROW;
    END CATCH
    -- End try catch for transaction Production.WorOrderRouting
END --Procedure

