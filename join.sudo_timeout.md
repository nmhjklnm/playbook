---
name: sudo timestamp timeout
description: Extend sudo timestamp cache to 240 minutes for <user>.
---

# join.sudo_timeout

## Goal
Allow non-interactive sudo usage (so an AI agent can run sudo for longer without getting blocked by password prompts) by extending sudo timestamp cache to 240 minutes (4 hours) for user `<user>`.

## Change
- File: `/etc/sudoers.d/<user>-timestamp`
- Content:
  - `Defaults:<user> timestamp_timeout=240`
- Permissions:
  - `0440`

## Apply
1) `sudo visudo -f /etc/sudoers.d/<user>-timestamp`
2) Add line: `Defaults:<user> timestamp_timeout=240`
3) `sudo chmod 0440 /etc/sudoers.d/<user>-timestamp`

## Verify
- `sudo -l` shows `timestamp_timeout=240` under `Matching Defaults entries`.
- `sudo -k`
- `sudo -n true && echo OK || echo NEED_PASSWORD`  (expect NEED_PASSWORD)
- `sudo -v` (enter password once)
- `sudo -n true && echo OK || echo NEED_PASSWORD`  (expect OK)

## Rollback
- `sudo rm /etc/sudoers.d/<user>-timestamp`
- `sudo -k`

## Evidence
- `sudo -l` output included:
  - `Matching Defaults entries ... timestamp_timeout=240`
