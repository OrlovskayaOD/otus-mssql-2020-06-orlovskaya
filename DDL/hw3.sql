--Создание БД--
create database Project_Clinika;
 go

--Создание таблиц--
create table employes (
                        id int primary key identity(1,1) not null,
						dadd date not null,
						fio varchar(50) not null,
						mob varchar(12) not null unique,
						pasp bigint not null unique,
						inn bigint not null unique,
						educat varchar(100) not null,
						[address] varchar (100) not null,
						dbegin date not null,
						dend date null,
						[status] varchar(1),
											    
						constraint CH_empl_dend check (dend > dbegin)
					  )

create table patient (
                        id int primary key identity(1,1) not null,
						dadd date not null,
						fio varchar(50) not null,
						mob varchar(12) not null unique,
						pasp bigint not null unique,
						gender varchar(1) not null,
						[address] varchar (100) not null
					  )

create table [services] (
                          id int primary key identity(1,1) not null,
						  dadd date not null,
						  servtitle varchar(50) not null,
						  leadtime time not null,
						  price money not null,
						  [status] bit,
						  						  
						  constraint CH_serv_price check (price>0)
					    )


create table ticket (
                      id int primary key identity(1,1) not null,
					  dadd date not null,
					  servid int not null,
					  patid int not null,
					  emplid int not null,
					  daterec date not null,
					  timerec time not null,						  
					  [status] varchar(1),
					  
					  constraint CH_tic_time check (timerec > '08:00:00' or timerec = '08:00:00')			
				    )

--Добавление ограничений--
alter table ticket
 add constraint FK_tic_serv foreign key (servid) references [services] (id)
alter table ticket
 add constraint FK_tic_pat foreign key (patid) references patient (id)
alter table ticket
 add constraint FK_tic_empl foreign key (emplid) references employes (id)
alter table employes
 add constraint DF_empl_dadd default (getdate()) for dadd
alter table patient
 add constraint DF_pat_dadd default (getdate()) for dadd
alter table [services]
 add constraint DF_serv_dadd default (getdate()) for dadd
alter table ticket
 add constraint DF_tic_dadd default (getdate()) for dadd

--Создание индексов--
Create NonClustered Index NX_empl_pasp
 On employes(pasp)

Create NonClustered Index NX_pat_pasp
 On patient(pasp)

Create NonClustered Index NX_serv_titl
 On [services](servtitle)

Create NonClustered Index NX_tic_servid
 On ticket(servid)

Create NonClustered Index NX_tic_patid
 On ticket(patid)

Create NonClustered Index NX_tic_emplid
 On ticket(emplid)