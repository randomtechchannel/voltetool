@echo off
chcp 65001 >nul
title Công cụ hỗ trợ Shizuku ADB
cd mtkclient
:MENU
cls
echo ===================================================
echo             CÔNG CỤ HỖ TRỢ SHIZUKU ADB
echo ===================================================
echo.
echo 1. Cài đặt Shizuku.apk và Pixel IMS.apk
echo 2. Kích hoạt Shizuku
echo 3. Thoát
echo.
echo ===================================================
set "choice="
set /p choice="Nhập lựa chọn của bạn (1-3): "

if "%choice%"=="1" goto INSTALL
if "%choice%"=="2" goto START_SHIZUKU
if "%choice%"=="3" exit
goto MENU

:: =====================================================
:: HÀM CHỜ KẾT NỐI ADB
:: =====================================================
:WAIT_ADB
cls
echo ===================================================
echo  [KIỂM TRA KẾT NỐI THIẾT BỊ]
echo  Vui lòng đảm bảo:
echo  1. Đã bật "Chế độ nhà phát triển" (Bấm 7 lần Số bản dựng)
echo  2. Đã bật "Gỡ lỗi USB" (USB Debugging)
echo  3. Đã chuyển chế độ USB sang "Truyền tệp" (MTP)
echo  4. Đã tắt "Giám sát quyền" (Disable permission monitoring - nếu có)
echo ===================================================
echo.
echo Đang chờ kết nối ADB từ điện thoại...
adb wait-for-device
echo [OK] Đã kết nối thiết bị thành công! Đang bắt đầu quy trình...
echo.
exit /b 0

:: =====================================================
:: BƯỚC 1: CÀI ĐẶT APK
:: =====================================================
:INSTALL
call :WAIT_ADB

echo ---------------------------------------------------
echo ĐANG CÀI ĐẶT ỨNG DỤNG...
echo ---------------------------------------------------
echo LƯU Ý: Vui lòng chú ý màn hình điện thoại.
echo Nếu hiện thông báo xác nhận, hãy chọn CÀI ĐẶT / INSTALL.
echo ---------------------------------------------------
echo.

echo [+] Đang cài đặt Shizuku...
adb install shizuku.apk
echo.

echo [+] Đang cài đặt Pixel IMS...
adb install ims.apk
echo.
echo ---------------------------------------------------
echo Hoàn tất quá trình cài đặt!
echo.
pause
goto MENU

:: =====================================================
:: BƯỚC 2: KÍCH HOẠT SHIZUKU
:: =====================================================
:START_SHIZUKU
call :WAIT_ADB

echo ---------------------------------------------------
echo ĐANG KÍCH HOẠT SHIZUKU...
echo ---------------------------------------------------
echo.
echo [+] Đang thử kích hoạt bằng lệnh mặc định...

adb shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh > %temp%\shizuku_err.txt 2>&1
findstr /I "No such file or directory" %temp%\shizuku_err.txt >nul

if %errorlevel% neq 0 goto SUCCESS_DEFAULT
goto FALLBACK_METHOD

:FALLBACK_METHOD
echo.
echo [!] Phát hiện lỗi: No such file or directory
echo [+] Đang chuyển sang phương pháp thay thế...
echo.

adb push clip.jar clip /data/local/tmp
adb shell chmod 755 /data/local/tmp/clip

echo [+] Đang mở ứng dụng Shizuku trên điện thoại...
adb shell monkey -p moe.shizuku.privileged.api -c android.intent.category.LAUNCHER 1 >nul 2>&1

echo.
echo ===================================================
echo [HƯỚNG DẪN TRÊN ĐIỆN THOẠI]:
echo 1. Màn hình Shizuku đã được mở trên điện thoại.
echo 2. Bấm vào nút "Xem lệnh" (View command).
echo 3. Bấm "Sao chép" (Copy) lệnh đó.
echo ===================================================
echo.
set /p dummy="Làm xong bấm Enter để tiếp tục..."

echo.
echo [+] Đang đọc lệnh từ bộ nhớ tạm (clipboard)...
adb shell /data/local/tmp/clip > %temp%\shizuku_cmd.txt
set /p MY_CMD=<%temp%\shizuku_cmd.txt

echo [+] Lệnh lấy được là: %MY_CMD%
echo [+] Đang thực thi lệnh kích hoạt...
echo.

%MY_CMD%

goto END_PROCESS

:SUCCESS_DEFAULT
echo.
echo [+] Kích hoạt thành công bằng lệnh mặc định!
echo.
goto END_PROCESS

:END_PROCESS
if exist %temp%\shizuku_err.txt del %temp%\shizuku_err.txt
if exist %temp%\shizuku_cmd.txt del %temp%\shizuku_cmd.txt
echo.
echo ---------------------------------------------------
echo Đã thực hiện xong!
echo ---------------------------------------------------
echo.
pause
goto MENU