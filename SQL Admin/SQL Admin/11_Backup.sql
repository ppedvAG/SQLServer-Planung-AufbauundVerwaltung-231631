/*

Was kann passieren?

1. Logfile defekt
   Datendatei ist defekt	
2. HDD mit DB ist weg/defekt...
3. jemand manipuliert versehentlich Daten
4. SQL Server ist defekt, aber die HDD sind noch da..
5. Wenn man weiss, dass gleich was passieren kann..?
	Bei SP oder UP Installationen 
	wird oft auf ein Backup hingewiesen
6: DB Defekt.. korrupt (fehlerverdächtig)


Welche Sicherungen gibts denn?

Vollsicherung  V

Differentielle Sicherung  D

Transaktionsprotokollsicherung  T


Warum kann ich aber bei einer meiner DB keine T Sicherung machen..?
Weil es ein sog Wiederherstellungsmodel gibt...


pro DB 

Einfach
protokolliert INS UP DEL
werden TX nach Commit aus dem LOG gelöscht...es gibt nichts vernünftiges 
zu sichern

--> keine Logfile Sicherung
protokolliert auch INS UP DEL
aber massenoperation werden nicht exakt protokolliert

Massenprotkolliert

protokolliert INS UP DEL
aber massenoperation werden nicht exakt protokolliert

aber es wird nichts aus dem LOG entfernt


Vollständig
alles exakt protokollieren, was Änderungen in der DB stattfindet
wächst deutlich mehr
es löscht auch nichts aus dem Log

man kann hiermit auf Sekunde restoren....!


Wieviel Datenverlust in Zeit darf ich haben? 15min, 30min, 1h, aber auch 0
Wieviel zeit habe ich zum Restoren? 
-- wie lange darf einen DB ausfallen in Zeit?

diese Fragen ergeben die Sicherungsstrategie?


V
sichert die DB zu einem Zeitpukt, also auch nur diesen Zeitpubkt restoren
sichert die Dateien (nur Daten aber keine Leerräume)
auch Pfade und derern Dateinamen, auch Größenangaben

Differentielle 
sichert nur geänderte Seiten seit dem letzte V
Diff Sicherung ist auch wiedder nur ein Zeitpunkt

T
sichert wie ein Makro. Es werden alle Statements , die irgendwie "ändern"
protokoliert mit Zeitstempel
nur mit Hife des Logifles kann man auf Sekunde restoren

6 Uhr   V!
6:15	T
6:30	T
6:45    T
7 Uhr	D
		T
		T
	XXXX
		T
		T
		T
		T
12:00	D
		T!
		T!
12:30	T!

--Jetzt wissen wir folgendes:
Was ist der schnellste Restore , den man haben kann?
nur das V--> so oft wie möglich V Sicherung



Wie lange braucht man um ein T zu restoren?
so lange wie die darin befindlichen Aktionen dauerten.. in Summe
--> wir wollen nicht viele Ts und auch keinen großen Zeitumfang 
in den Ts haben
--> T sind oft nur im 15min Takt oder 30min


Wie oft mache ich dann eine D Sicherung?
ca alle 3 oder 4 T einen D Sicherung
Weil das D verkürzt sehr stark die restore Dauern
und sichert unseren Restore


Wir machen das T so häufig wie der max Datenverlust sein darf... zb 15min

Nur mit Hilfe der T Sicherung ist ein Sekundengenauer Restore möglich
Allerdings muss das Wiederherstellungsm iodel auf Voll gesetzt sein.




*/

--VOLLSICHERUNG
BACKUP DATABASE [Kurs2014DB] TO  DISK = N'D:\_BACKUP\Kurs2014DB.bak' 
	WITH NOFORMAT, NOINIT,  NAME = N'Kurs2014DB-Voll',
	SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--DIFF
BACKUP DATABASE [Kurs2014DB] TO  DISK = N'D:\_BACKUP\Kurs2014DB.bak'
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  
NAME = N'Kurs2014DB-DIFF',
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


--TLOG
BACKUP LOG [Kurs2014DB] TO  
DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH NOFORMAT, 
NOINIT,  NAME = N'Kurs2014DB-TLOG', SKIP, NOREWIND, 
NOUNLOAD,  STATS = 10
GO


---V TTT D TTT D TTT

--Fall 6:
--DB über das Menü restoren...
USE [master]
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 1, ,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5

GO


--Dateien sind da aber Seerver weg
--Dateien sind akt als jedes backup

use [master];
GO
USE [master]
GO

GO
USE [master]
GO
ALTER DATABASE [sqldb1] SET  OFFLINE
GO


select * from sys.sysfiles



--Sicherungsplan

/*
DB Größe:  300GB

Wie lange darf die DB max ausfallen?  1 Woche

Wie groß darf der Datenverlust in Zeit sein?  5h

Verwendung: werktags   6 Uhr    bis 16 Uhr


Ist der Restore in der ang Zeit nicht zu schaffen
--> Hochverfügbarkeit (Cluster / Availability Groups)
--> Mirroring (depricated)

---5h Datenverlust: RecoveryModel = Einfach

--V und D
--V .. wie lange dauert vermutlich das Backup

select 300000 / 300  /60
--Bak = 100 GB oder weniger

--V jeden Tag um 18 Uhr ausser SA und So 
--D werktags alle 3 h von 9 Uhr bis 15:05 

v D D D v


auf sek das letzte jahr
2 bis 3 Jahre pro Woche eine V Sicherung
älter nur 1 V pro Monat











/*
DB Größe:  300GB

Wie lange darf die DB max ausfallen?  1 h

Wie groß darf der Datenverlust in Zeit sein?  30min
So exakt wie möglich | möglichst ohne Datenverlust

Verwendung: werktags   6 Uhr    bis 16 Uhr

Model: Full

V -- jeden Tag (wt) um 20 Uhr Uhr ausser SA und So 
D -- jeden Tag (wt) alle 2 Ts  7:15 bis 15:15
T -- jeden Tag (wt) alle 30min 6:30 bis 16:00
 


*/

