--Создание бд для проекта
create database Clinika_Project
use Clinika_Project

--Создание и заполнение таблиц--

--Создание и заполнение таблицы Должность--
create table Position(
                       id nvarchar(36) not null primary key,
					   date_actual datetime2 not null,
					   job_title nvarchar(100) not null,
					   [status] nvarchar(1) not null
					 )

insert into Position
 values ('92193ADC-75BC-4A59-9ABC-E5B9BEECA78B', '2020-07-21', 'Врач-дерматовенеролог', 'A'),
        ('C7B35ED9-9748-4D25-B1BF-AB38A19159BD', '2020-07-21', 'Врач-офтальмолог', 'A'),
        ('7DF79452-7DCB-4FD9-9F83-1DA3F1D1C837', '2020-07-21', 'Врач-отоларинголог', 'A'),
        ('AE1737F9-D66E-4E8D-82BA-D9A52174A7B4', '2020-07-21', 'Врач-кардиолог', 'A'),
        ('DD116EFD-58D2-4B24-A0A3-7202DD65DDB5', '2020-07-21', 'Врач-хирург', 'A'),
        ('E95FCFB0-2E69-4B78-A352-15924286FBCD', '2020-07-21', 'Администратор', 'A'),
        ('8E821714-69B7-42E3-8748-5B5AD589D5D8', '2020-07-21', 'Кассир', 'A')

--Создание и заполнение таблицы Сотрудники--
create table Doctors(
                       id nvarchar(36) not null primary key,
					   date_actual datetime2 not null,
					   fio nvarchar(50),
					   id_position nvarchar(36) not null,
					   date_begin date not null,
					   date_end date null,
					   [status] nvarchar(1)
					   constraint FK_Doctors_To_Position foreign key (id_position) references Position (Id)
					  )

insert into Doctors
 values ('E88EE893-A1EE-41AF-B928-C50C604C906F', '2020-07-21', 'Афанасьева Светлана Владимировна', '92193ADC-75BC-4A59-9ABC-E5B9BEECA78B', '06.22.2020', null, 'A'),
        ('02014401-2284-456C-ADFE-5F366B80B6B6', '2020-07-21', 'Самохвалова Лилия Николаевна', 'C7B35ED9-9748-4D25-B1BF-AB38A19159BD', '06.22.2020', null, 'A'),
		('22F350FC-85E7-4342-B81F-AE80615E5F1F', '2020-07-21', 'Зимина Марина Геннадьевна', '7DF79452-7DCB-4FD9-9F83-1DA3F1D1C837', '06.22.2020', null, 'A'),
		('8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', '2020-07-21', 'Фют Наталья Геннадьевна', 'AE1737F9-D66E-4E8D-82BA-D9A52174A7B4', '06.22.2020', null, 'A'),
		('37AA7D59-FD58-4B8C-8C40-60A120950AB3', '2020-07-21', 'Борисов Иван Евгеньевич', 'DD116EFD-58D2-4B24-A0A3-7202DD65DDB5', '06.22.2020', null, 'A'),
		('AEF61A14-B606-4598-BF15-F6F346494862', '2020-07-21', 'Ленский Олег Вячеславович', 'DD116EFD-58D2-4B24-A0A3-7202DD65DDB5', '06.22.2020', null, 'A'),
		('F4BD9963-BB43-411C-994B-122FB8335C23', '2020-07-21', 'Сопина Василиса Дмитриевна', '8E821714-69B7-42E3-8748-5B5AD589D5D8', '06.22.2020', null, 'A'),
		('B5ABA50F-7F89-4FAC-A5EE-08DCACF0154E', '2020-07-21', 'Алексеева Дарья Владимировна', 'E95FCFB0-2E69-4B78-A352-15924286FBCD', '06.22.2020', null, 'A'),
		('39EF3218-E810-434C-883B-868E66DA7706', '2020-07-21', 'Савельева Мария Николаевна', '8E821714-69B7-42E3-8748-5B5AD589D5D8', '06.22.2020', null, 'A'),
		('C790CC37-8384-43EF-A595-8B05BE47523B', '2020-07-21', 'Пухова Ольга Петровна', 'E95FCFB0-2E69-4B78-A352-15924286FBCD', '06.22.2020', null, 'A')

--Создание и заполнение таблицы Данные о сотрудниках--
create table Doctors_Data(
                      id nvarchar(36) not null primary key,
					  date_actual datetime2 not null,
					  id_doctor nvarchar(36) not null,
					  name_data nvarchar(30) not null,
					  value_data nvarchar(300) not null,
					  [status] nvarchar(1)
					  constraint FK_Doctor_Data_To_Doctors foreign key (id_doctor) references Doctors (id)
					  )

insert into Doctors_Data
 values ('C672DF3E-F6EC-4316-A190-1A2842934523', '2020-07-21', 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'mob', '+79041235333', 'A'),
        ('E30846B5-497B-47CB-872F-0EEE5BAA511D', '2020-07-21', 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'pasp', '1122123123', 'A'),
		('4A0A7871-C2DD-47AD-9456-658CC2F1CA5D', '2020-07-21', 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'inn', '345421657800', 'A'),
		('7E37EEA8-5F39-493C-804B-F73E3C9B4114', '2020-07-21', 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'educ', 'МГУ', 'A'),
		('2C8489A0-E9E7-4CB0-A4D2-BB96D528E4B1', '2020-07-21', 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'address', 'Владимирская обл., г. Ковров, ул. Челюскинцев, 18', 'A'),

        ('05F786A1-7295-4A0E-8809-D00D4427829B', '2020-07-21', '02014401-2284-456C-ADFE-5F366B80B6B6', 'mob', '+79041352112', 'A'),
		('DC960615-785E-42D7-ADD1-8176E7A6949F', '2020-07-21', '02014401-2284-456C-ADFE-5F366B80B6B6', 'pasp', '1122254345', 'A'),
		('5F6EC231-11D5-4C68-90D3-48F63A7414DB', '2020-07-21', '02014401-2284-456C-ADFE-5F366B80B6B6', 'inn', '209768404567', 'A'),
		('AD2BF522-3007-4A7E-AF87-B24307C33552', '2020-07-21', '02014401-2284-456C-ADFE-5F366B80B6B6', 'educ', 'МГУ', 'A'),
		('7C6D1067-81D7-4BDB-9E88-20145D37BF3E', '2020-07-21', '02014401-2284-456C-ADFE-5F366B80B6B6', 'address', 'Владимирская обл., г. Ковров, ул. Строителей, д.18, кв. 54', 'A'),

        ('7C34F78C-5A5A-4785-AB0D-B62F6D6EF2DF', '2020-07-21', '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'mob', '+79046547890', 'A'),
		('3EEA9F09-976F-48AA-98EE-900421545D54', '2020-07-21', '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'pasp', '1123090897', 'A'),
		('BCF27129-4887-49C5-918F-ECD96EFCFF2F', '2020-07-21', '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'inn', '655783907005', 'A'),
		('D1B5AB63-E881-438F-8282-6BFE0CD00610', '2020-07-21', '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'educ', 'ИвГУ', 'A'),
		('29E48EF1-8C46-446D-B696-6C1E3B3AA961', '2020-07-21', '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'address', 'Владимирская обл., г. Ковров, ул. Чайкова, 19', 'A'),

        ('22F7298F-15B1-420F-848C-7A8CF3A5C1D2', '2020-07-21', '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', 'mob', '+79050987888', 'A'),
		('A07B7188-E077-4305-A53E-39C5FD77A77C', '2020-07-21', '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', 'pasp', '1122777654', 'A'),
		('2E0A84CF-E3DF-4603-800A-567C0215EBF2', '2020-07-21', '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', 'inn', '321544768994', 'A'),
		('F9F1F0F2-F183-4783-9BEF-BAAAF6E0E606', '2020-07-21', '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', 'educ', 'ВлГУ', 'A'),
		('706CBCF4-9572-4115-9D1D-A2523C33FF9C', '2020-07-21', '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', 'address', 'Владимирская обл., пос. Мелехово, ул. Задойнова, 120', 'A'),

        ('B3932EA3-6CCD-4894-BC13-AAA15638E2CC', '2020-07-21', '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'mob', '+79046900010', 'A'),
		('771A7E8D-8054-435A-825E-B963EF1B2A03', '2020-07-21', '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'pasp', '1122567554', 'A'),
		('56457407-7013-4559-8002-33AEBD1C5E5D', '2020-07-21', '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'inn', '101998093335', 'A'),
		('2228DC51-974C-433B-B41B-D52BEF42A3DD', '2020-07-21', '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'educ', 'ВлГУ', 'A'),
		('3B79B9F3-2216-4083-8443-913C678A62B4', '2020-07-21', '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'address', 'Владимирская обл., г. Ковров, ул. Чкалова, 21', 'A'),

        ('18069BC7-C8DC-4156-AD72-AB3B7888B7FB', '2020-07-21', 'AEF61A14-B606-4598-BF15-F6F346494862', 'mob', '+79041224356', 'A'),
		('563802FA-4024-44EB-B277-E28A582ADF99', '2020-07-21', 'AEF61A14-B606-4598-BF15-F6F346494862', 'pasp', '1124890001', 'A'),
		('E371DD8C-6048-4F6A-8289-F75122CC4B80', '2020-07-21', 'AEF61A14-B606-4598-BF15-F6F346494862', 'inn', '365455300989', 'A'),
		('2A42E2A8-F10E-4C8C-A146-B84B9787C5F4', '2020-07-21', 'AEF61A14-B606-4598-BF15-F6F346494862', 'educ', 'ИвГУ', 'A'),
		('A8ECB6F9-78C5-4898-B758-86CA9D85B4C1', '2020-07-21', 'AEF61A14-B606-4598-BF15-F6F346494862', 'address', 'Владимирская обл., г. Ковров, ул. Брюсова, 10', 'A'),

        ('197B8539-115E-4786-BBF4-BAD928C7C67A', '2020-07-21', 'F4BD9963-BB43-411C-994B-122FB8335C23', 'mob', '+79078909876', 'A'),
		('63B9C7D6-1813-4FD7-BA59-7BDB1A19285F', '2020-07-21', 'F4BD9963-BB43-411C-994B-122FB8335C23', 'pasp', '1112768090', 'A'),
		('323FBD4B-45A3-4B19-95E7-BAFEB515D128', '2020-07-21', 'F4BD9963-BB43-411C-994B-122FB8335C23', 'inn', '542187000547', 'A'),
		('EC6171C5-35E9-4C7A-A23C-630A3A8917E4', '2020-07-21', 'F4BD9963-BB43-411C-994B-122FB8335C23', 'educ', 'КГТА', 'A'),
		('145E4EEA-36DB-4241-9BB1-EBEF9DD0E860', '2020-07-21', 'F4BD9963-BB43-411C-994B-122FB8335C23', 'address', 'Владимирская обл., г. Ковров, ул. Белинская, 16', 'A'),

        ('35760B46-BAC6-486D-A9FB-62CBD3C8E8A7', '2020-07-21', 'B5ABA50F-7F89-4FAC-A5EE-08DCACF0154E', 'mob', '+79009086543', 'A'),
        ('A5F5DCE6-EB98-451E-849A-63EFFE8A1926', '2020-07-21', 'B5ABA50F-7F89-4FAC-A5EE-08DCACF0154E', 'pasp', '1123123432', 'A'),
        ('93EE4BAA-9EFE-48FD-8319-999EDF1BFEAD', '2020-07-21', 'B5ABA50F-7F89-4FAC-A5EE-08DCACF0154E', 'inn', '290065787444', 'A'),
        ('660DEB8B-E1E3-4984-9F8B-4B6013FB535B', '2020-07-21', 'B5ABA50F-7F89-4FAC-A5EE-08DCACF0154E', 'educ', 'ВлГУ', 'A'),
        ('D5C80000-50C1-42CE-ADD1-8FE9A897B107', '2020-07-21', 'B5ABA50F-7F89-4FAC-A5EE-08DCACF0154E', 'address', 'Владимирская обл., г. Ковров, ул. Ковров-8, 26', 'A'),

        ('50066771-921D-4625-91DC-D6C4590E7621', '2020-07-21', '39EF3218-E810-434C-883B-868E66DA7706', 'mob', '+79009086546', 'A'),
        ('34CF5A6D-5704-4681-B468-B7E1126EE860', '2020-07-21', '39EF3218-E810-434C-883B-868E66DA7706', 'pasp', '1123556783', 'A'),
        ('C16255F6-484C-4FB0-AD7A-775DF084EBEB', '2020-07-21', '39EF3218-E810-434C-883B-868E66DA7706', 'inn', '187657389020', 'A'),
        ('B16DA0DE-4B10-473F-B52C-BC4EA1C5A146', '2020-07-21', '39EF3218-E810-434C-883B-868E66DA7706', 'educ', 'ВлГУ', 'A'),
        ('54E00776-5852-45FA-859B-ED3442986DB0', '2020-07-21', '39EF3218-E810-434C-883B-868E66DA7706', 'address', 'Владимирская обл., г. Ковров, ул. Ковров-8, 13', 'A'),

        ('8436ED06-1BFB-4ED0-BD7C-CF9AFD494096', '2020-07-21', 'C790CC37-8384-43EF-A595-8B05BE47523B', 'mob', '+79009086554', 'A'),
        ('2F314107-110A-401F-A353-AF3B36F6F648', '2020-07-21', 'C790CC37-8384-43EF-A595-8B05BE47523B', 'pasp', '1123098907', 'A'),
        ('A6373688-B639-46DF-B192-290A26267EA0', '2020-07-21', 'C790CC37-8384-43EF-A595-8B05BE47523B', 'inn', '265789040333', 'A'),
        ('9814E6C2-10BC-48EF-90C9-CA8AB29215AD', '2020-07-21', 'C790CC37-8384-43EF-A595-8B05BE47523B', 'educ', 'ВлГУ', 'A'),
        ('BF219C7E-2198-4016-9F20-D192FDA386B0', '2020-07-21', 'C790CC37-8384-43EF-A595-8B05BE47523B', 'address', 'Владимирская обл., г. Ковров, ул. Ковров-8, 54', 'A')

--Создание и заполнение таблицы Пациент--
create table Patient (
                      id nvarchar(36) not null primary key,
					  date_actual datetime2 not null,
					  fio nvarchar(200) not null,
					  gender nvarchar(1) not null
					 )

insert into patient
 values ('FE0F39B8-0C9E-4EDD-9BE6-770D4D969373', '2020-07-21', 'Колесникова Ольга Владимировна', 'W'),
        ('9E84C485-75A8-4E2F-AE52-0217F4054C18', '2020-07-21', 'Сокова Наталья Михайловна', 'W'),
		('0EA94A09-C252-47E1-8BC1-11944AFB63E4', '2020-07-21', 'Зотов Виталий Александрович', 'M')

--Создание и заполнение таблицы Данные пациента--
create table Patient_Data (
							  id nvarchar(36) not null primary key,
							  date_actual datetime2 not null,
							  id_patient nvarchar(36) not null,
							  name_data nvarchar(30) not null,
							  value_data nvarchar(300) not null,
							  [status] nvarchar(1) not null
							  constraint FK_Patient_Data_To_Patient foreign key (id_patient) references Patient (id)
						  )

insert into Patient_Data
 values ('F1B6F0F7-E301-4B69-B1E5-330848342619', '2020-07-21', 'FE0F39B8-0C9E-4EDD-9BE6-770D4D969373', 'mob', '+79021322122', 'A'),
        ('EF1597B7-C8C4-44AA-BA64-56D52B1BF70F', '2020-07-21', 'FE0F39B8-0C9E-4EDD-9BE6-770D4D969373', 'pasp', '1133546765', 'A'),
		('3B3994EF-0F49-48B5-8192-D981BE91E311', '2020-07-21', 'FE0F39B8-0C9E-4EDD-9BE6-770D4D969373', 'snills', '123-543-567 77', 'A'),
		('10A7B2A7-1CB3-4D38-9C76-72548D0E1D65', '2020-07-21', 'FE0F39B8-0C9E-4EDD-9BE6-770D4D969373', 'address', 'Владимирская обл., г. Владимир, ул. Горького, 23', 'A'),

		('4C6F8C53-A429-431A-A652-31BCF504763C', '2020-07-21', '9E84C485-75A8-4E2F-AE52-0217F4054C18', 'mob', '+79034560980', 'A'),
		('E17FD5EF-140C-4FCE-891F-5A9A41E705F6', '2020-07-21', '9E84C485-75A8-4E2F-AE52-0217F4054C18', 'pasp', '1132654433', 'A'),
		('AD066506-EE8B-4BC8-B087-47F5F62014C6', '2020-07-21', '9E84C485-75A8-4E2F-AE52-0217F4054C18', 'snills', '111-133-565 75', 'A'),
		('895EF511-65CC-4B1B-9C67-8C78C1110403', '2020-07-21', '9E84C485-75A8-4E2F-AE52-0217F4054C18', 'address', 'Владимирская обл., г. Москва, ул. Большая Московская, 13', 'A'),

		('1F272A86-7F1C-46C9-A41C-9B1DA5510E3B', '2020-07-21', '0EA94A09-C252-47E1-8BC1-11944AFB63E4', 'mob', '+79007652211', 'A'),
		('0C3DAE06-DEE7-4460-B464-9A5558A4FDC3', '2020-07-21', '0EA94A09-C252-47E1-8BC1-11944AFB63E4', 'pasp', '1133678092', 'A'),
		('15A784A0-A33B-4296-AD59-CD11278AC3DA', '2020-07-21', '0EA94A09-C252-47E1-8BC1-11944AFB63E4', 'snills', '122-512-125 23', 'A'),
		('F6B0DC7F-85C2-4D7F-8532-6DC0C651A8FB', '2020-07-21', '0EA94A09-C252-47E1-8BC1-11944AFB63E4', 'address', 'Владимирская обл., г. Ковров, ул. Комсомольская, 9', 'A')

--Создание и заполнение таблицы Услуги--
create table [Services] (
                         id nvarchar(36) not null primary key,
					     date_actual datetime2 not null,
					     service_title nvarchar(100) not null,
					     lead_time time not null,
						 price money not null,
					     [status] nvarchar(1) not null
					    )

insert into [Services]
 values ('B59BC10F-7C07-4087-AD5D-33F098586E15', '2020-07-21', 'Прием врачом-дерматовенерологом', '00:30:00', 800, 'A'),
        ('AE32660F-39D7-4AC9-A85E-E34899E684C3', '2020-07-21', 'Инфильтрационная анестезия в дерматологии', '00:20:00', 200, 'A'),
		('5100673C-566B-4155-874A-295A101450DF', '2020-07-21', 'Чистка лица аппаратом NewAp', '00:50:00', 1800, 'A'),
		('3D75AAB8-2E73-461E-9B56-9C2ECD9A57AE', '2020-07-21', 'Удаление контагиозного моллюска при помощи аппарата "Сургитрон"', '00:25:00', 330, 'A'),
		('A5230152-A3CA-48FD-B0E0-508BC7C4AAC2', '2020-07-21', 'Нецифровая дерматоскопия', '00:30:00', 270, 'A'),
		('AE034BA6-5644-4CF8-9457-B95B2FA071F4', '2020-07-21', 'Прием врачом-офтальмологом', '00:30:00', 1000, 'A'),
		('81822913-E191-4130-9FFF-6739584145F4', '2020-07-21', 'Периметрия компьютерная', '00:50:00', 400, 'A'),
		('9058C9FD-7964-4824-8F72-B1582A4F0357', '2020-07-21', 'Оптическая когерентная томография - ОКТ', '01:00:00', 2500, 'A'),
		('F873B40B-F702-40EB-931F-46E475750C22', '2020-07-21', 'Прием врачом-отоларингологом', '00:30:00', 1000, 'A'),
		('54CEC098-2A05-4B11-AA36-E89F6FB5869E', '2020-07-21', 'Продувание ушей по Политцеру', '00:40:00', 450, 'A'),
		('C98B8991-F0B0-43BD-A619-3DD755F46F7E', '2020-07-21', 'Прием врачом-кардиологом', '00:30:00', 900, 'A'),
		('EFEB1D20-375F-49D2-8FF6-852A58647378', '2020-07-21', 'Прием врачом-кардиологом с проведением ЭКГ', '00:50:00', 1300, 'A'),
		('84F06AD7-8A9F-41A0-9C0C-9671A30D1626', '2020-07-21', 'Прием врачом-хирургом', '00:30:00', 850, 'A'),
		('DED89D31-68E7-4E20-8CC2-70ED6DED8061', '2020-07-21', 'Прием врачом-хирургом с перевязкой чистых ран', '00:50:00', 650, 'A')

--Создание и заполнение таблицы Талон--
create table Ticket(
                    id nvarchar(36) not null primary key,
					date_actual datetime2 not null,
					id_patient nvarchar(36) not null,
					id_service nvarchar(36) not null,
					id_doctor nvarchar(36) not null,
					record_day date not null,
					record_time time not null
					constraint  FK_Ticket_To_Patient foreign key (id_patient) references Patient (id),
					constraint  FK_Ticket_To_Services foreign key (id_service) references [Services] (id),
					constraint  FK_Ticket_To_Doctors foreign key (id_doctor) references Doctors (id),

					sys_start_time datetime2 generated always as row start not null,
					sys_end_time datetime2 generated always as row end not null,
					period for system_time(sys_start_time, sys_end_time)
					)
					with (system_versioning = on (history_table = dbo.TicketHistory))

insert into ticket
 values ('99FBC310-6647-46A7-B2D4-A109B30DC80B', '2020-07-21', 'FE0F39B8-0C9E-4EDD-9BE6-770D4D969373', 'B59BC10F-7C07-4087-AD5D-33F098586E15', 'E88EE893-A1EE-41AF-B928-C50C604C906F', '2020-06-26', '12:00:00', default, default),
        ('06147F32-7F0C-4EEF-8D22-3B4DE61F3CDF', '2020-07-21', '9E84C485-75A8-4E2F-AE52-0217F4054C18', 'AE034BA6-5644-4CF8-9457-B95B2FA071F4', '02014401-2284-456C-ADFE-5F366B80B6B6', '2020-07-04', '10:00:00', default, default),
		('E5D64022-D31E-4FEB-8A48-B5235BA1214F', '2020-07-21', '0EA94A09-C252-47E1-8BC1-11944AFB63E4', 'EFEB1D20-375F-49D2-8FF6-852A58647378', '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', '2020-08-01', '10:00:00', default, default)

--Создание и заполнение таблицы Расписание--
create table Schedules(
                       id nvarchar(36) not null primary key,
					   date_actual datetime2 not null,
					   record_begin time not null,
					   record_end time not null,
					   record_day int not null,
					   id_doctor nvarchar(36) not null,
					   [status] nvarchar(1) not null
					   constraint  FK_Schedules_To_Doctors foreign key (id_doctor) references Doctors (id)
					   )

insert into schedules
 values ('8BAEA335-2514-4E6C-B197-4EE4E70EE106', '2020-07-21', '10:00:00', '14:00:00', datepart(weekday, '2020-07-20'), 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'A'),
        ('C76FBD7F-4747-409B-A0F1-BD9405ED417E', '2020-07-21', '10:00:00', '14:00:00', datepart(weekday, '2020-07-21'), 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'A'),
		('31FBE6A5-DE1F-4E5B-9C39-AF0D5AD24065', '2020-07-21', '15:00:00', '19:00:00', datepart(weekday, '2020-07-22'), 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'A'),
		('E2858A32-8FEA-408C-8E57-2FAC12BFAF38', '2020-07-21', '15:00:00', '18:00:00', datepart(weekday, '2020-07-23'), 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'A'),
		('2AEA68A4-E53A-49B5-991C-9A16FBF9F821', '2020-07-21', '10:00:00', '15:00:00', datepart(weekday, '2020-07-24'), 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'A'),
		('912D24C2-8D74-4994-B0F0-E0147A976528', '2020-07-21', '10:00:00', '12:00:00', datepart(weekday, '2020-07-25'), 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'A'),

		('48F20F63-C6B5-4895-A7FF-E942B740C2AA', '2020-07-21', '12:00:00', '14:00:00', datepart(weekday, '2020-07-20'), '02014401-2284-456C-ADFE-5F366B80B6B6', 'A'),
        ('AF6C463C-968F-4889-8956-15596D5875ED', '2020-07-21', '12:00:00', '16:00:00', datepart(weekday, '2020-07-21'), '02014401-2284-456C-ADFE-5F366B80B6B6', 'A'),
		('DAC4DCE7-D18C-4BDD-B8A5-355996AFF3DB', '2020-07-21', '12:00:00', '16:00:00', datepart(weekday, '2020-07-24'), '02014401-2284-456C-ADFE-5F366B80B6B6', 'A'),
		('05752196-C8E1-4C26-90C2-D0838E8CD53B', '2020-07-21', '08:00:00', '14:00:00', datepart(weekday, '2020-07-25'), '02014401-2284-456C-ADFE-5F366B80B6B6', 'A'),

		('EA46528C-0AD2-4617-A074-510AC0007291', '2020-07-21', '09:00:00', '15:00:00', datepart(weekday, '2020-07-21'), '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'A'),
		('B4A6B75C-29C5-4E60-A928-8F37AF64E866', '2020-07-21', '09:00:00', '15:00:00', datepart(weekday, '2020-07-22'), '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'A'),
		('EE6EAB39-0ED8-4850-8018-EC805E1027D3', '2020-07-21', '08:00:00', '14:00:00', datepart(weekday, '2020-07-23'), '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'A'),
		('DCA0F404-8121-4B41-B613-75AFD3B76A87', '2020-07-21', '10:00:00', '13:00:00', datepart(weekday, '2020-07-24'), '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'A'),

		('2D9D44E3-AA7F-4CF9-8F94-017FC9A4C1DA', '2020-07-21', '10:00:00', '16:00:00', datepart(weekday, '2020-07-20'), '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', 'A'),
        ('DC059BDB-C461-4FFC-8BF8-FADF5B0315BD', '2020-07-21', '10:00:00', '15:00:00', datepart(weekday, '2020-07-24'), '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', 'A'),
		('C0E3C74C-3C6C-463D-81B0-625BF6004349', '2020-07-21', '10:00:00', '14:00:00', datepart(weekday, '2020-07-25'), '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', 'A'),

		('4D6722D2-6A4E-43D8-8D9A-40E5310A594A', '2020-07-21', '10:00:00', '15:00:00', datepart(weekday, '2020-07-20'), '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'A'),
        ('31124A7A-E9DF-4349-90F1-FD5560439932', '2020-07-21', '10:00:00', '14:00:00', datepart(weekday, '2020-07-21'), '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'A'),
		('F98D93B7-061B-43A1-8644-63A29C138325', '2020-07-21', '15:00:00', '20:00:00', datepart(weekday, '2020-07-24'), '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'A'),
		('8AD4A857-2A10-491D-AF95-47FE2F3DE677', '2020-07-21', '16:00:00', '21:00:00', datepart(weekday, '2020-07-25'), '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'A'),

		('9455E02C-DE3E-47CF-BFE4-68CBD622D005', '2020-07-21', '08:30:00', '15:00:00', datepart(weekday, '2020-07-22'), 'AEF61A14-B606-4598-BF15-F6F346494862', 'A'),
		('5CA0590F-950E-4E0D-930E-B58B42A4EAF9', '2020-07-21', '10:00:00', '18:00:00', datepart(weekday, '2020-07-23'), 'AEF61A14-B606-4598-BF15-F6F346494862', 'A'),
		('29B59FA9-C58B-4FEE-B034-B5A62F82BE14', '2020-07-21', '15:00:00', '19:00:00', datepart(weekday, '2020-07-24'), 'AEF61A14-B606-4598-BF15-F6F346494862', 'A')

--Создание и заполнение таблицы Отпуска--
create table Vacations(
                       id nvarchar(36) not null primary key,
					   date_actual datetime2 not null,
					   vacation_begin date not null,
					   vacation_end date not null,
					   id_doctor nvarchar(36) not null,
					   [status] nvarchar(1) not null
					   constraint  FK_Vacations_To_Doctors foreign key (id_doctor) references Doctors (id)
					   )

insert into vacations
 values ('84D1D20F-CD5B-4A56-86A6-33F0021EC504', '2020-07-21', '2021-01-20', '2021-02-03', 'E88EE893-A1EE-41AF-B928-C50C604C906F', 'A'),
        ('A8D310DF-9F4F-49B4-B757-4052906DACC9', '2020-07-21', '2021-02-05', '2021-02-19', '02014401-2284-456C-ADFE-5F366B80B6B6', 'A'),
		('D14409A4-750A-4E26-BF7C-E57078FE2A7B', '2020-07-21', '2021-03-01', '2021-03-15', '22F350FC-85E7-4342-B81F-AE80615E5F1F', 'A'),
		('2633F28B-FEEA-4BED-8A57-3ADCD3C250DB', '2020-07-21', '2021-03-13', '2021-03-27', '8C7B3913-CF41-4D31-8EA5-A55C179F2CE0', 'A'),
		('8E122837-CE97-4E62-95CE-CF1B356B121D', '2020-07-21', '2021-06-15', '2021-06-29', '37AA7D59-FD58-4B8C-8C40-60A120950AB3', 'A'),
		('968C4D09-CC21-43FC-ACED-406CB4B043DB', '2020-07-21', '2021-04-10', '2021-04-24', 'AEF61A14-B606-4598-BF15-F6F346494862', 'A'),
		('7F67AE96-1AAE-4559-8103-370E5C86C0DD', '2020-07-21', '2021-05-24', '2021-06-08', 'F4BD9963-BB43-411C-994B-122FB8335C23', 'A'),
		('1359B3A1-3442-4E0F-B10D-A37B3C1F3961', '2020-07-21', '2021-03-05', '2021-03-19', 'B5ABA50F-7F89-4FAC-A5EE-08DCACF0154E', 'A'),
		('AC80EA91-45CE-4773-B1F0-E2D94657DD44', '2020-07-21', '2021-02-20', '2021-03-03', '39EF3218-E810-434C-883B-868E66DA7706', 'A'),
		('98BF5F87-D4FF-4449-A6F3-3D728446B680', '2020-07-21', '2021-07-01', '2021-07-15', 'C790CC37-8384-43EF-A595-8B05BE47523B', 'A')
