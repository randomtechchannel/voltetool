@echo off

cd mtkclient

echo Thank for sharing ChatlaninWef and https://realme-gadgetlife.net/how-to-enable-volte/ 

echo adb Waiting for device connection - Cho thiet bi ket noi

timeout /t 3 /nobreak >nul

cls

:step_1

adb.exe devices | findstr /e "unauthorized"

echo %ERRORLEVEL%

if "%ERRORLEVEL%"=="0" (

  echo Turn on "USB debugging" in the developer options and approve it on the terminal - Bat USB Debugging 
  echo When finished, press the key again - Khi hoan tat nhan Enter

  pause

  cls

  goto step_1

)

adb.exe devices | findstr /e "device"

echo %ERRORLEVEL%

if "%ERRORLEVEL%"=="0" (

  echo Device is successfully connected - Thiet bi ket noi thanh cong

) else if "%ERRORLEVEL%"=="1" (

  echo Connect your device and switch to "Transfer files" mode - Ket noi thiet bi va chuyen sang che do "Truyen du lieu"
  echo Press the key again when finished - Nhan Enter de tiep tuc

  pause
  
  cls

  goto step_1

)



echo Rebooting device in fastbootd mode - Reboot thiet bi vao che do fastbootd

adb.exe reboot fastboot


echo Waiting for fastboot device connection - Cho ket noi thiet bi fastboot

cls

timeout /t 15 /nobreak >nul



:step_2

fastboot.exe devices | findstr /e "fastboot"

echo %ERRORLEVEL%

if "%ERRORLEVEL%"=="0" (

  echo Device is successfully connected - Thiet bi ket noi thanh cong

) else if "%ERRORLEVEL%"=="1" (

  echo Please wait for a while until it starts - Cho thiet bi khoi dong
  echo When the language setting screen appears, press the key again - Khi xuat hien bang chon ngon ngu, khong can thao tac gi
  echo Thay bang ngon ngu thi bam enter de tiep tuc

  pause
  
  cls
  
  goto step_2

)

echo Switching from fastbootd mode to recovery mode - Chuyen che do fastbootd sang che do recovery

fastboot.exe reboot recovery



echo Waiting for recovery device connection - Cho thiet bi ket noi

cls

timeout /t 3 /nobreak >nul



:step_3

adb.exe devices | findstr /e "unauthorized"

echo %ERRORLEVEL%

if "%ERRORLEVEL%"=="0" (

  echo VoLTE cannot be enabled on your model - Thiet bi cua ban khong the cai VoLTE
  echo Select "Reboot" on the screen and restart -  Nhan "Reset" de khoi dong lai

  pause

  cls
  
  exit

)

adb.exe devices | findstr /e "recovery"

echo %ERRORLEVEL%

if "%ERRORLEVEL%"=="0" (

  echo Device is successfully connected in recovery mode - Thiet bi da vao che doi recovery thanh cong

) else if "%ERRORLEVEL%"=="1" (

  echo Could not recognize device - Khong the nhan dang thiet bi cai lai driver
  echo Connect the device and press the key again - Ket noi thiet bi va nhan phim bat ky

  pause
  
  cls
  
  goto step_3

)
 
echo Writing VoLTE enable settings - Dang thiet lap VoLTE trong cai dat

@echo on

adb.exe shell setprop persist.data.iwlan.enable true
adb.exe shell setprop persist.dbg.ims_volte_enable 1 
adb.exe shell setprop persist.dbg.volte_avail_ovr 1 
adb.exe shell setprop persist.dbg.vt_avail_ovr 1
adb.exe shell setprop persist.dbg.wfc_avail_ovr 1
adb.exe shell setprop persist.radio.rat_on combine
adb.exe shell setprop persist.radio.data_ltd_sys_ind 1
adb.exe shell setprop persist.radio.data_con_rprt 1
adb.exe shell setprop persist.radio.calls.on.ims 1
adb.exe shell setprop persist.data.iwlan 1
adb.exe shell setprop persist.data.iwlan.ipsec.ap 1
adb.exe shell setprop persist.radio.volte.dan_support true
adb.exe shell setprop persist.radio.VT_ENABLE 1
adb.exe shell setprop persist.sys.cust.lte_config true
adb.exe shell setprop persist.rcs.supported 1

@echo off

cls

adb.exe reboot

echo Has completed. restarting device - Da hoan tat. Khoi dong lai thiet bi
echo.
echo Setting of VoLTE enable finished successfully - Kich hoat cai dat VoLTE thanh cong
echo.
echo After inserting the SIM and setting the "Access Point Name", check if the VoLTE mark appears. 
echo.
echo Vao mang di dong - Thong tin va cai dat SIM de bat VoLTE
echo.
echo Device will be rebooted - Thiet bi se tu dong khoi dong lai
echo.
echo Neu khong hien cuoc goi VoLTE - may khong tuong thich - thu dung cach MTK
echo. 
echo Neu hien cuoc goi VoLTE ma van bi xuong 2g - ten diem truy cap - dat lai cac diem truy cap
echo.
echo Khong khoi phuc cai dat goc de giu nhe
echo.
echo Thank for sharing ChatlaninWef and https://realme-gadgetlife.net/how-to-enable-volte/ 
echo.
start https://sites.google.com/view/voltetool/done
pause

cls

adb.exe kill-server

exit
