# playbook

## Why
To make device changes transparent and reproducible.

## What
Docs that describe how to turn a blank server/workstation into a baseline environment.

MVP includes:
- user / ssh / sudo
- package management
- docker
- basic tools
- logs
- backups
- ai environment

## How

### Lifecycle stages
- join
- secure
- build
- run

### File naming
- `<stage>.<topic>.md`
- stage: join | secure | build | run
- topic: snake_case

Example:
- join.sudo_timeout.md

### Doc metadata (required)
At the very top of each doc:

---
name: <short human name>
description: <one-line description>
---

### Doc sections (required)
- Goal
- Change
- Apply
- Verify
- Rollback
- Evidence

### Index
Generate an index (stdout):

```bash
./tools/index.sh
```
