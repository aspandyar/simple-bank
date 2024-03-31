
### To extract a .tar.gz file on Linux, you can use the "tar" command in the terminal. Here is the general syntax:

```bash
tar -xvzf filename.tar.gz
```

### Here is a brief explanation of the options used:

#### - `-x`: This option tells tar to extract the contents of the archive.
#### - `-v`: This option is for verbose output, which means that tar will display a list of the files being extracted as it does so.
#### - `-z`: This option tells tar to decompress the archive using gzip.
#### - `-f`: This option is used to specify the archive file to extract.

### So, for example, if you have a .tar.gz file named `mywebsitebackup.tar.gz`, you would extract its contents using the following command:

```bash
tar -xvzf mywebsitebackup.tar.gz
```

### This will extract the contents of the archive into the current directory. If you want to extract the contents of the archive to a specific directory, you can use the following syntax:

```bash
tar -xvzf mywebsitebackup.tar.gz -C /path/to/directory
```

### This will extract the contents of the archive into the specified directory.

### You can learn more about the full options by consulting the related man page of your Linux distribution.

[source](https://help.pressidium.com/en/articles/6979427-how-to-extract-and-unzip-tar-gz-files)
