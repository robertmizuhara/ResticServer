@echo off
cd /d "C:\Users\rober\Documents\Projects\ResticServer"

echo Starting vault maintenance sequence...

echo [1/7] Running vault-unlock...
docker compose up -d vault-unlock
powershell -Command "do { Start-Sleep -Seconds 2 } while ((docker inspect restic_unlocker --format '{{.State.Status}}') -eq 'running')"
docker rm restic_unlocker >nul 2>&1

echo [2/7] Running repair index...
docker compose up -d vault-repair-index
powershell -Command "do { Start-Sleep -Seconds 2 } while ((docker inspect restic_repair_index --format '{{.State.Status}}') -eq 'running')"
docker logs restic_repair_index 2>&1
docker rm restic_repair_index >nul 2>&1

echo [3/7] Running repair snapshots...
docker compose up -d vault-repair-snapshots
powershell -Command "do { Start-Sleep -Seconds 2 } while ((docker inspect restic_repair_snapshots --format '{{.State.Status}}') -eq 'running')"
docker logs restic_repair_snapshots 2>&1
docker rm restic_repair_snapshots >nul 2>&1

echo [4/7] Running repair packs...
docker compose up -d vault-repair-packs
powershell -Command "do { Start-Sleep -Seconds 2 } while ((docker inspect restic_repair_packs --format '{{.State.Status}}') -eq 'running')"
docker logs restic_repair_packs 2>&1
docker rm restic_repair_packs >nul 2>&1

echo [5/7] Running check...
docker compose up -d vault-check
powershell -Command "do { Start-Sleep -Seconds 2 } while ((docker inspect restic_check --format '{{.State.Status}}') -eq 'running')"
docker logs restic_check 2>&1
docker rm restic_check >nul 2>&1

echo [6/7] Running forget/prune...
docker compose up -d vault-maintenance
powershell -Command "do { Start-Sleep -Seconds 2 } while ((docker inspect restic_janitor --format '{{.State.Status}}') -eq 'running')"
docker logs restic_janitor 2>&1
docker rm restic_janitor >nul 2>&1

echo Maintenance complete. Starting rest-server...
docker compose up -d rest-server

echo Vault is ready.