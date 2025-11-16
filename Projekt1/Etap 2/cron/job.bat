@echo OFF
ECHO Rozpoczynam zadanie SQL...

sqlcmd -S "KAMILF" -E -d "Projekt1" -i "C:\Users\kfrys\Desktop\Programowanie\ZSBD\Projekt1\Etap 2\sql\cron_job.sql" -o "C:\Users\kfrys\Desktop\Programowanie\ZSBD\Projekt1\Etap 2\cron\output.txt" -b

ECHO Zadanie SQL zakonczone. Sprawdz plik output.txt.