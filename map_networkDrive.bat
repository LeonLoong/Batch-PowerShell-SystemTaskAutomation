:DisconnectDrive
echo "Disconnect Drive"
net use D: /d
net use X: /d
goto MapDrive001

:MapDrive001
timeout 2
if not exist D:\ (
    net use D: "\\192.168.0.11\Projects\Demo\map_drive\D"
	goto MapDrive002
)

:MapDrive002
timeout 2
if not exist X:\ (
    net use X: "\\192.168.0.11\Projects\Demo\map_drive\X"
	goto :eof
)
