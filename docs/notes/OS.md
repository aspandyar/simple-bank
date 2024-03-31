
# Navigation

- [Download](#download)
- [FHS](#FHS)

# Download

#### Here a quick manual of download it using [assets](https://github.com/golang-migrate/migrate/releases)


![[migration assets.png]]


#### 1. migrate.**darwin**, darwin is mac OS, and IOS.
#### 2. linux-386, 386 is 32-bit architecture for x86 processors. 
#### 3. \*.deb is debian based OS, as Ubuntu, and Pop-OS
#### 4. \*.tar is **archive** with based size, also it called tar-ball. 
#### 5. \*.tar.gz is compressed tar archive, using gzip algorithm.
#### 6. linux-amd64 is 64-bit architecture for x86 processor, also called x86_64
#### 7. linux-arm64 is a new architecture with simplify and limited number of instructions
#### 8. linux-armv7 is a previous version of arm, with 32-bit architecture

### Installation 

```bash
arch
```

`x86_64` => so I should to download a linux-amd64.tar.gz.

---
## [FHS](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
### File Hierarchy Standard (FHS) in Linux

The File Hierarchy Standard (FHS) defines the structure of the Linux filesystem.

#### Root Directory `/`

- The root directory is the top-level directory in the filesystem.

## Binaries

#### `/bin`

- Essential binaries executable such as `ls` and others.
- These binaries are crucial for basic system functionality.

#### `/sbin`

- System binaries essential for superuser (root) operations.
- Commands in this directory often require the use of `sudo`.

#### `/lib`

- Libraries and shared code utilized by system binaries.

## User Binaries

#### `/usr/bin`

- User binaries, non-essential installed binaries.

#### `/usr/local/bin`

- Locally compiled binaries.

- All binaries in `/bin`, `/sbin`, `/usr/bin`, and `/usr/local/bin` are accessed through the `$PATH` environment variable.

  - Use `echo $PATH` command to view the current paths.

## Finding Binaries

- Use the `which` command to find the path of a binary:
  ```bash
  which curl
  ```

## Configuration Files

#### `/etc`

- Configuration files, editable text configs typically ending with `.conf`.

## Home Directory

#### `/home`

- User data directory, each user has their own subdirectory here.
- The `~` symbol is a shortcut to the user's home directory.

## Boot Files

#### `/boot`

- Contains files needed to boot the system, including the Linux kernel.

## Device Files

#### `/dev`

- Contains hardware or driver-related regular files.

## Optional Software

#### `/opt`

- Directory reserved for optional or third-party software installations.

## Variable Files

#### `/var`

- Variable files that change while the Linux OS is in use, including logs, backups, and cache files.

## Temporary Files

#### `/tmp`

- Directory for temporary files that exist only between reboots.

## Process Information

#### `/proc`

- Virtual filesystem providing kernel and process information.
- De-facto standard method for handling process and system information.




