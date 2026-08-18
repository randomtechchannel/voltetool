import os, sys, time, curses, requests, tempfile, platform, subprocess, zipfile, shutil
from cursesmenu import *
from cursesmenu.items import *

runtime = os.environ["RUNTIME_PATH"]

curses.initscr()

exited = False

def exit_curses():
    curses.endwin()
    clear_terminal()

def download_and_install_usbdk():
    exit_curses()

    found = False

    usbdk_latest = requests.get("https://api.github.com/repos/daynix/UsbDk/releases").json()[0]
    for asset in usbdk_latest["assets"]:
        if platform.machine().endswith("64") and "x64" in asset["name"]:
            found = True
            url = asset["browser_download_url"]
            name = asset["name"]
        elif platform.machine().endswith("86") and "x86" in asset["name"]:
            found = True
            url = asset["browser_download_url"]
            name = asset["name"]

    if not found:
        print("Cant determine CPU architecture")
        time.sleep(3)
        return

    tempdir = tempfile.mkdtemp()

    f = open(f"{tempdir}/{name}", "wb")

    stream = requests.get(url, stream=True, allow_redirects=True)

    print(f"Downloading {name}")
    for chunk in stream.iter_content(chunk_size=512):
        f.write(chunk)

    f.close()

    print(f"Installing {name}")
    subprocess.call(f"msiexec /i {tempdir}\\{name}")

    shutil.rmtree(tempdir)

def cancel_usbdk():
    global exited

    exit_curses()

    print("Sorry but mtkclient-gui cant work without UsbDk, the program will exit now.")
    time.sleep(3)
    exited = True

def oppo_realme_volte():
    exit_curses()
    clear_terminal()
    subprocess.call(f"coloros.bat")
    input("Press Enter to continue")



def mtk_volte():
    exit_curses()


    clear_terminal()
    subprocess.call(f"3step.bat")
    input("Press Enter to continue")

def volte_2_steps():
    exit_curses()
    clear_terminal()
    subprocess.call(f"2step.bat")
    input("Press Enter to continue")

def pixel_ims():
    exit_curses()
    clear_terminal()
    subprocess.call(f"ims.bat")
    input("Press Enter to continue")

def support_me():
    exit_curses()
    clear_terminal()
    subprocess.call(f'start "" "https://sites.google.com/view/voltetool/"', shell=True)
    input("Press Enter to continue")
        
if os.name == "nt":
    while not os.path.exists("C:\\Program Files\\UsbDk Runtime Library") and not os.path.exists("C:\\Program Files (x86)\\UsbDk Runtime Library"):
        if exited:
            sys.exit()

        exit_curses()

        menu = CursesMenu("UsbDk not found", "Do you want me to download and install UsbDk for you?", show_exit_option=False)
        menu.append_item(FunctionItem("Yes", download_and_install_usbdk, should_exit=True))
        menu.append_item(FunctionItem("No", cancel_usbdk, should_exit=True))
        menu.show()

while not os.path.exists("mtkclient"):
    exit_curses()

    tempdir = tempfile.mkdtemp()

    f = open(f"{tempdir}/mtkclient.zip", "wb")

    stream = requests.get("https://github.com/bkerler/mtkclient/archive/refs/heads/main.zip", stream=True, allow_redirects=True)

    print("Downloading mtkclient")
    for chunk in stream.iter_content(chunk_size=512):
        f.write(chunk)

    f.close()

    print("Unpacking mtkclient")
    with zipfile.ZipFile(f"{tempdir}/mtkclient.zip", "r") as zip_file:
        zip_file.extractall(".")

    shutil.move("mtkclient-main", "mtkclient")
    shutil.rmtree(tempdir)

menu = CursesMenu("VoLTE/VoWifi Tool Free", "Chọn một phương pháp", show_exit_option=False)
menu.append_item(FunctionItem("Oppo/Realme/Oneplus (hên xui, nên thử)", oppo_realme_volte))
menu.append_item(FunctionItem("MediaTek (Helio, Dimensity, MTxxxx) (Android 8+)", mtk_volte))
menu.append_item(FunctionItem("Android 8+ (cần unlock bootloader)", volte_2_steps))
menu.append_item(FunctionItem("Pixel IMS (Android 10+) (dùng đc nhiều loại máy)", pixel_ims))
menu.append_item(FunctionItem("Hỗ trợ/Báo lỗi", support_me))
menu.append_item(FunctionItem("Ủng hộ tác giả <3", support_me))
menu.append_item(FunctionItem("Exit", exit_curses, should_exit=True))
menu.show()
