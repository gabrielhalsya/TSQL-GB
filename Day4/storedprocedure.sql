-- cursor
create procedure UpdateSummaryOrder(@pageNumber int, @pageSize int) as
-- try to use sales schema( order, order_detail)
DECLARE @orderId int;
DECLARE @totalPrice money;
DECLARE @totalQty int;
DECLARE @orderDate datetime;
declare cursor_order CURSOR forward_only READ_ONLY FOR
  select order_id, 
  from sales.orders
  order by order_id
  offset @pageNumber rows fetch next @pageSize row only;
  --select above, meant to save result of select result into cursor
begin
  --1 open cursor
    OPEN cursor_order;
  --2 Fetch record to variable
  while @@FETCH_STATUS=0
  BEGIN
    fetch next from cursor_order into @orderId, @orderDate;
  --3 display record 
    select 
      @totalPrice=sum(ordet_price),
      @totalQty=sum(ordet_quantity) 
    from sales.orders_detail 
    where ordet_order_id=@orderId
    begin try
      begin TRANSACTION
      -- update table sales.orders
      update sales.orders set 
        order_subtotal=@totalPrice,
        order_total_qty=@totalQty,
        order_status='SHIPPED',
        order_shipped_date=GETDATE()
        where order_id=@orderId
        print 'update for '+ cast(@orderId as nvarchar(25))+' successfully'
      commit TRANSACTION
    end try
    BEGIN CATCH
      ROLLBACK;
      SELECT 'Transaction Rollback for orderId '+@orderId;
      THROW; 
    end CATCH
  END;
  --4 close cursor
    CLOSE cursor_order;
  --5 delete cursor from memory
    DEALLOCATE cursor_order;
END
