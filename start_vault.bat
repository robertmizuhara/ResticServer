@echo off
:: Navigate to your project folder
cd /d "C:\Users\rober\Documents\Projects\ResticServer"

:: Force start the vault in the background
docker compose up -d

:: Optional: Keep the window open for 3 seconds so you can see if it worked
timeout /t 5