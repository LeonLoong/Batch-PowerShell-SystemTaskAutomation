rem *get directory*
rem *Z:*
rem *cd Demo\Other\Software\PsExec*
@echo off
psexec \\192.168.0.111 -u local\supp -p demo_adm1n cmd /c cd C:\Users\ ^& C: ^& dir
psexec \\192.168.0.111 -u local\supp -p demo_adm1n cmd /c cd C:\Users\ ^& C: ^& dir
psexec \\192.168.0.111 -u local\supp -p demo_adm1n cmd /c cd D:\Loong ^& D: ^& dir
psexec \\192.168.0.111 -u local\supp -p demo_adm1n cmd /c cd D:\Demo ^& D: ^& dir
