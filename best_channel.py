import os
import subprocess

result = subprocess.run(["sudo iwlist wlan0 scan | grep Channel"],shell=True ,stdout = subprocess.PIPE, stderr = subprocess.PIPE , text=True)

print(result)
