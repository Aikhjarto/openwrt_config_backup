# Nightly config backup for OpenWrt

`create_backup.sh` writes a `sysupgrade -b` configuration backup to a USB stick:

```
/mnt/sda1/backups/backup-<hostname>-YYYYmmdd-HHMMSS.tar.gz
/mnt/sda1/backup_latest.tar.gz -> the newest one
```

The archive is the same as *System → Backup / Flash Firmware → Generate archive* in LuCI:
changed config files plus everything listed in `/etc/sysupgrade.conf`. The options used are:

* `-k`: include the list of installed packages (`/etc/backup/installed_packages.txt`), so the
  same packages can be reinstalled after a fresh flash;
* `-u`: skip files that are unchanged from the defaults in `/rom`;
* `-v`: verbose.

Restore one with `sysupgrade -r <file>`, or in LuCI.

Old backups are not deleted. With ~30 kB each, a 4 GB stick holds them for a long time.

## Install

```sh
scp -O usr/local/bin/create_backup.sh root@router:/usr/local/bin/
ssh root@router 'echo "50 23 * * * /bin/sh /usr/local/bin/create_backup.sh" >> /etc/crontabs/root; /etc/init.d/cron restart'
```

The stick must be mounted at `/mnt/sda1` (package `block-mount`, `/etc/config/fstab`). Add
`/usr/local/` to `/etc/sysupgrade.conf` so the script itself survives an upgrade.
