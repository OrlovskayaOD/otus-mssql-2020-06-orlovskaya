-- �������������� �����
SELECT * 
FROM sys.fulltext_languages
WHERE name = 'Russian'


------------------------------------------------�������� �������������� ��������-------------------------------------------------------------

-- ������� �������������� �������
CREATE FULLTEXT CATALOG ClPr_FT_Catalog
WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
AUTHORIZATION [dbo]
-- ON FILEGROUP
GO

-- ������� Full-Text Index �� fio �����
CREATE FULLTEXT INDEX ON Doctors(fio LANGUAGE Russian)
KEY INDEX PK__Doctors__3213E83FB1AD13E6
ON (ClPr_FT_Catalog)
WITH (
  CHANGE_TRACKING = AUTO, /* AUTO, MANUAL, OFF */
  STOPLIST = SYSTEM /* SYSTEM, OFF ��� ���������������� stoplist */
);
GO

-- ������� Full-Text Index �� value_data ����� (������ �����)
CREATE FULLTEXT INDEX ON Doctors_Data(value_data LANGUAGE Russian)
KEY INDEX PK__Doctors___3213E83F3D35E939
ON (ClPr_FT_Catalog)
WITH (
  CHANGE_TRACKING = AUTO, /* AUTO, MANUAL, OFF */
  STOPLIST = SYSTEM /* SYSTEM, OFF ��� ���������������� stoplist */
);
GO

-- ������� Full-Text Index �� fio ��������
CREATE FULLTEXT INDEX ON Patient(fio LANGUAGE Russian)
KEY INDEX PK__Patient__3213E83F5BF81121
ON (ClPr_FT_Catalog)
WITH (
  CHANGE_TRACKING = AUTO, /* AUTO, MANUAL, OFF */
  STOPLIST = SYSTEM /* SYSTEM, OFF ��� ���������������� stoplist */
);
GO

-- ������� Full-Text Index �� value_data �������� (������ � ��������)
CREATE FULLTEXT INDEX ON Patient_Data(value_data LANGUAGE Russian)
KEY INDEX PK__Patient___3213E83FB39884FD
ON (ClPr_FT_Catalog)
WITH (
  CHANGE_TRACKING = AUTO, /* AUTO, MANUAL, OFF */
  STOPLIST = SYSTEM /* SYSTEM, OFF ��� ���������������� stoplist */
);
GO

-- ������� Full-Text Index �� job_title �������� ���������
CREATE FULLTEXT INDEX ON Position(job_title LANGUAGE Russian)
KEY INDEX PK__Position__3213E83FE3379093
ON (ClPr_FT_Catalog)
WITH (
  CHANGE_TRACKING = AUTO, /* AUTO, MANUAL, OFF */
  STOPLIST = SYSTEM /* SYSTEM, OFF ��� ���������������� stoplist */
);
GO

-- ������� Full-Text Index �� service_title �������� �����
CREATE FULLTEXT INDEX ON [Services](service_title LANGUAGE Russian)
KEY INDEX PK__Services__3213E83FF9DF37F1
ON (ClPr_FT_Catalog)
WITH (
  CHANGE_TRACKING = AUTO, /* AUTO, MANUAL, OFF */
  STOPLIST = SYSTEM /* SYSTEM, OFF ��� ���������������� stoplist */
);
GO

-- ���������� Full-Text Index (���� CHANGE_TRACKING != AUTO)
--ALTER FULLTEXT INDEX ON Doctors
--START FULL POPULATION

SELECT *
FROM Doctors
WHERE CONTAINS(fio, N'�����������');

SELECT *
FROM Doctors_Data
WHERE CONTAINS(value_data, N'����');

SELECT *
FROM Patient
WHERE CONTAINS(fio, N'�����');

SELECT *
FROM Patient_Data
WHERE CONTAINS(value_data, N'������');

SELECT *
FROM Position
WHERE CONTAINS(job_title, N'�������������');

SELECT *
FROM [Services]
WHERE CONTAINS(service_title, N'������');


--�������� nonclustered ��������--
--������ ����������-���������--
 Create NonClustered Index NX_doc_posid
  On Doctors (id_position)

--������ ������ � ����������-����������--
 Create NonClustered Index NX_docd_docid
 On Doctors_Data (id_doctor)

--������ ������ ��������-�������--
 Create NonClustered Index NX_pdata_patid
 On Patient_Data (id_patient)

 --������ ����������-����������--
 Create NonClustered Index NX_sched_docid
 On Schedules (id_doctor)

--������ ������� - ����������--
 Create NonClustered Index NX_vac_docid
 On Vacations (id_doctor)

--������ �����-�������--
 Create NonClustered Index NX_tic_patid
 On ticket (id_patient)

--������ �����-������--
 Create NonClustered Index NX_tic_servid
 On ticket (id_service)

--������ �����-���� (����������)--
 Create NonClustered Index NX_tic_docid
 On ticket (id_doctor)


-- -- ������� Column Store ������
--CREATE COLUMNSTORE INDEX IX_Index_ColumnStore_record_day
--ON dbo.Schedules(record_day)
--GO

--SET STATISTICS IO ON
--SET STATISTICS TIME ON 
--GO

--select sum(record_day) from dbo.Schedules where record_day = 3
--SELECT sum(record_day) FROM dbo.Schedules where record_day = 3 OPTION(MAXDOP 1)
--GO

--SET STATISTICS IO OFF
--SET STATISTICS TIME OFF
--GO