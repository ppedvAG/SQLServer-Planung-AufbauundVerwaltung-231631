---Virtualisierung


/* Ausstattung

16 GB

4 log Prozessoren

Gesamt - 4 GB (wg HyperV)--> 12 GB

				RAM				KERNE
HV-DC          512-2000				2
HV-SQL1			6000 (fix)			4
HV-SQL2         4000 (fix)			4


NUMA

64GB  -- SQL Server 50GB
------------------------------------
		S1 S2				S3 S4


SOCKEL1	K1  K2     Sockel 2 KA  KB
		K3  K4				KC  KD
------------------------------------



VM
64GB  -- SQL Server 50GB
------------------------------------
		S1 S2				


		K1  KA    
		K3  KC				
------------------------------------



Vorsicht beim Kopieren / Migrieren von VMs--> Hardwareausstattung steckt in KonfigFiles
--die nun evtl nicht mehr stimmt

* NUMA ) Zuordnung der Sockets zu Slots


Bestand HV-SQL1

C:\_SQLDBS\
C:\_SQLDBS\
C:\BACKUP

Agent:		schulung\sqlAgent  ppedv2019!
DB Server: schulung\svcSQL ppedv2019!


RAM 2748
MAXDOP 4


				ServerNetz			ClientNetz
HV-DC			192.168.138.1		192.168.137.1
HV-SQL1			192.168.138.2		192.168.137.2
HV-SQL2			192.168.138.3		192.168.137.3
NTCLUST								192.168.137.4
SQLCLUST							192.168.137.5
SQLAVG								192.168.137.6





192.168.1.1
192.168.10.1

TCP://nodetwo.sqldom.dom:5022
TCP://nodeone.sqldom.dom:5022

