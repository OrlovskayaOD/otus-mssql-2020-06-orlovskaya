use WideWorldImporters;
--������� ����� ������� � ��� ����������������
select distinct t.name
from sys.partitions p
inner join sys.tables t
	on p.object_id = t.object_id
where p.partition_number <> 1


--������� ��� ��������� �� ���������� ������ ������
SELECT  $PARTITION.fnOrderYearPartition(OrderDate) AS Partition
		, COUNT(*) AS [COUNT]
		, MIN(OrderDate)
		,MAX(OrderDate) 
FROM Sales.OrdersYears
GROUP BY $PARTITION.fnOrderYearPartition(OrderDate)
ORDER BY Partition ;  

select * from sys.partition_range_values;
select * from sys.partition_parameters;
select * from sys.partition_functions;
--EXEC sp_GetDDL PF_TransactionDateTime;

--����� ���������� ������� �������
select	 f.name as NameHere
		,f.type_desc as TypeHere
		,(case when f.boundary_value_on_right=0 then 'LEFT' else 'Right' end) as LeftORRightHere
		,v.value
		,v.boundary_id
		,t.name from sys.partition_functions f
inner join  sys.partition_range_values v
	on f.function_id = v.function_id
inner join sys.partition_parameters p
	on f.function_id = p.function_id
inner join sys.types t
	on t.system_type_id = p.system_type_id
order by NameHere, boundary_id;
