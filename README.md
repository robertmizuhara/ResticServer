# ResticServer

A self-hosted Restic backup server running on Docker.

## Architecture

![Architecture Diagram](diagram.png)

The backup infrastructure consists of:

- **Restic Client** - Laptop/backup source
- **Home Router** - Port forwarding to expose the server
- **ResticServer** - Docker host running restic/rest-server
- **Vault** - Local storage for backup data (`D:/ResticVault/data`)
- **Backblaze B2** - Cloud storage for offsite backups

## Components

### rest-server (Vault)
REST API server for Restic backups, accessible over HTTP.

### Vault Maintenance (Janitor)
Automated cleanup container that:
- Removes old snapshots based on retention policy
- Prunes unreferenced data

## Quick Start

```bash
# Start the server
make up

# Stop the server
make down
```

## Configuration

The server runs on port 8000 with:
- Username: `robert`
- Password: `robertjames`

Backup data is stored at: `D:/ResticVault/data`

## Usage

From a Restic client:

```bash
# Initialize a new repository
restic -r http://your-server:8000/robert init

# Backup data
restic -r http://your-server:8000/robert backup /path/to/data

# List snapshots
restic -r http://your-server:8000/robert snapshots
```

## Retention Policy

- Daily: 7 snapshots
- Weekly: 6 snapshots
- Monthly: 12 snapshots
