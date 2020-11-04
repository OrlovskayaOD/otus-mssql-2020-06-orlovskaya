use WideWorldImporters;

--�������� �������� ������
ALTER DATABASE [WideWorldImporters] ADD FILEGROUP [OrderDataYear]
GO

--��������� ���� ��
ALTER DATABASE [WideWorldImporters] ADD FILE 
( NAME = N'OrderDataYears', FILENAME = N'C:\mssql2020\OrderDataYear.ndf' , 
SIZE = 1097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [OrderDataYear]
GO

--������� ������� ����������������� �� ����� - �� ��������� left!!
CREATE PARTITION FUNCTION [fnOrderYearPartition](DATE) AS RANGE RIGHT FOR VALUES
('20130101','20140101','20150101');																																																									
GO

--CREATE PARTITION SCHEME [schmYearPartition] AS PARTITION [fnYearPartition] 
--ALL TO ([PRIMARY])


-- ��������������, ��������� ��������� ���� �������
CREATE PARTITION SCHEME [schmOrderYearPartition] AS PARTITION [fnOrderYearPartition] 
ALL TO ([OrderDataYear])
GO