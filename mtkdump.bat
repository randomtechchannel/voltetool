@echo off
chcp 65001 >nul
title Auto Tool MTKClient
color 07

REM Kiem tra moi truong Python va file mtk trong mtkclient
if not exist "runtime\python.exe" (
    color 0C
    echo [LỖI] Không tìm thấy Python tại: runtime\python.exe
    echo Vui lòng kiểm tra lại thư mục runtime.
    echo.
    echo Nhấn phím bất kỳ để chuyển sang bước tiếp theo...
    pause >nul
    goto END_SCRIPT
)

if not exist "mtkclient\mtk" (
    color 0C
    echo [LỖI] Không tìm thấy file: mtkclient\mtk
    echo Vui lòng kiểm tra lại thư mục mtkclient.
    echo.
    echo Nhấn phím bất kỳ để chuyển sang bước tiếp theo...
    pause >nul
    goto END_SCRIPT
)

:MENU
cls
echo ========================================================
echo               BƯỚC 1 MTK VOLTE
echo ========================================================
echo.
echo [HƯỚNG DẪN KIỂM TRA TRẠNG THÁI MÁY ĐỂ CHỌN]:
echo 1. Vào [Cài đặt] -^> [Thông tin điện thoại] -^> Nhấp liên tục
echo    vào [Số hiệu bản tạo] để bật Tùy chọn nhà phát triển.
echo 2. Vào [Tùy chọn nhà phát triển] -^> Tìm mục [Mở khóa OEM]:
echo    - Nếu dòng này ghi "Bootloader đã được mở khóa" (hoặc bật
echo      sẵn/bị ẩn không bấm được) -^> Máy ĐÃ UNLOCK (Chọn 1).
echo    - Nếu dòng này đang TẮT hoặc gạt bật được -^> Máy CHƯA UNLOCK (Chọn 2).
echo.
echo ========================================================
echo.
echo  [1] Máy ĐÃ Unlock Bootloader (Chỉ Dump Boot)
echo  [2] Máy CHƯA Unlock Bootloader (Xóa Data + Unlock + Dump Boot)
echo.
echo ========================================================
set /p choice="Lựa chọn thao tác (1 hoặc 2): "

if "%choice%"=="1" goto DUMP_ONLY
if "%choice%"=="2" goto UNLOCK_AND_DUMP
goto MENU

:DUMP_ONLY
cls
echo ========================================================
echo            CHẾ ĐỘ: DUMP BOOT.IMG (ĐÃ UNLOCK BL)
echo ========================================================
echo.
echo HƯỚNG DẪN KẾT NỐI:
echo 1. Tắt hoàn toàn điện thoại.
echo 2. Nhấn và giữ [Giảm Âm Lượng] (hoặc cả 2 phím Tăng/Giảm Âm Lượng).
echo 3. Cắm cáp USB kết nối với máy tính.
echo.
echo Đang chờ thiết bị kết nối BROM...
echo ========================================================
echo.

echo Đang tiến hành sao lưu file boot.img...
runtime\python.exe mtkclient\mtk r boot mtkclient\boot.img
if errorlevel 1 goto DUMP_FAILED

echo.
echo Đang thoát chế độ BROM và reset thiết bị...
runtime\python.exe mtkclient\mtk reset
goto PROCESS_SUCCESS

:UNLOCK_AND_DUMP
cls
echo ========================================================
echo      CHẾ ĐỘ: UNLOCK BOOTLOADER ^& DUMP BOOT.IMG
echo ========================================================
echo.
color 0C
echo [CẢNH BÁO] Nếu bạn chưa unlock bootloader, toàn bộ dữ liệu
echo             trên điện thoại SẼ BỊ XÓA SẠCH!
echo Nên xóa tài khoản Google, Mi,.... trước để tránh bị khóa
color 07
echo.
echo ========================================================
echo Nhấn [ENTER] để xác nhận và bắt đầu quá trình...
pause >nul

cls
echo ========================================================
echo                   HƯỚNG DẪN KẾT NỐI
echo ========================================================
echo 1. Tắt hoàn toàn điện thoại.
echo 2. Nhấn và giữ [Giảm Âm Lượng] (hoặc cả 2 phím Tăng/Giảm Âm Lượng).
echo 3. Cắm cáp USB kết nối với máy tính.
echo.
echo Đang chờ thiết bị kết nối BROM...
echo ========================================================
echo.

REM Buoc 1: Xoa phan vung metadata, userdata, md_udc
echo [1/3] Đang định dạng phân vùng Dữ liệu (Erase Data)...
runtime\python.exe mtkclient\mtk e metadata,userdata,md_udc

REM Buoc 2: Unlock Bootloader
echo.
echo [2/3] Đang tiến hành Unlock Bootloader...
runtime\python.exe mtkclient\mtk da seccfg unlock
if errorlevel 1 goto UNLOCK_FAILED

echo.
echo [THÀNH CÔNG] Đã unlock bootloader!
echo.

REM Buoc 3: Dump file boot.img
echo [3/3] Đang tiến hành sao lưu file boot.img...
runtime\python.exe mtkclient\mtk r boot mtkclient\boot.img
if errorlevel 1 goto DUMP_FAILED

echo.
echo Đang thoát chế độ BROM và reset thiết bị...
runtime\python.exe mtkclient\mtk reset
goto PROCESS_SUCCESS

:PROCESS_SUCCESS
echo.
echo ========================================================
echo  HOÀN THÀNH TOÀN BỘ QUÁ TRÌNH MTKCLIENT!
echo  - File boot: mtkclient\boot.img
echo ========================================================
echo.
echo [Lưu ý 1] Bấm giữ nút nguồn 10 - 15 giây để khởi động lại máy.
echo [Nếu hiện dm-verity thì bấm nút nguồn thêm 1 lần nữa nhé]
echo.
echo [Lưu ý 2] Nếu máy không lên (treo logo/bootloop), hãy
echo            vào Recovery và tiến hành Wipe Data / Factory Reset.
echo.
echo [Lưu ý 3] Sau khi khởi động và thiết lập máy xong:
echo            - BẬT [Gỡ lỗi USB] (USB Debugging)
echo            - TẮT [Giám sát quyền] (Disable permission monitoring) nếu có.
echo.
echo ========================================================
echo Nhấn phím bất kỳ để chuyển sang bước tiếp theo...
pause >nul
goto END_SCRIPT

:DUMP_FAILED
echo.
echo [LỖI] Quá trình sao lưu boot.img THẤT BẠI!
echo Đang gửi lệnh reset...
runtime\python.exe mtkclient\mtk reset
echo.
echo [Lưu ý] Bấm giữ nút nguồn 10 - 15 giây để khởi động lại máy.
echo.
echo Nhấn phím bất kỳ để chuyển sang bước tiếp theo...
pause >nul
goto END_SCRIPT

:UNLOCK_FAILED
echo.
echo [LỖI] Quá trình Unlock Bootloader THẤT BẠI!
echo Đang gửi lệnh reset...
runtime\python.exe mtkclient\mtk reset
echo.

echo [Lưu ý] Bấm giữ nút nguồn 10 - 15 giây để khởi động lại máy.
echo [GỢI Ý] Bạn có thể thử sử dụng tool trả phí: UnlockTool.
echo.
echo Nhấn phím bất kỳ để chuyển sang bước tiếp theo...
pause >nul
goto END_SCRIPT

:END_SCRIPT
color 07
goto :EOF