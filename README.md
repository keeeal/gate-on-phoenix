# Gate on Phoenix
A tutorial and code for running GATE on Phoenix

## Resources

 - [The Phoenix HPC Wiki](https://wiki.adelaide.edu.au/hpc/index.php/Main_Page)
 - [Compiling GATE Instructions](https://opengate.readthedocs.io/en/latest/compilation_instructions.html)

## Cheat Sheet

### Logging into Phoenix

```
ssh a1234567@phoenix.adelaide.edu.au
```

_Recommendation:_ Set up [SSH keys](https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys) for better security and not having to type your password:

```
ssh-keygen
ssh-copy-id a1234567@phoenix.adelaide.edu.au
```

### Copying files to Phoenix

```
scp path/to/file.txt a1234567@phoenix.adelaide.edu.au:path/to/destination.txt
```

### Copying folders to Phoenix

```
scp -r path/to/folder a1234567@phoenix.adelaide.edu.au:path/to/destination
```

### Copying files/folders from Phoenix

```
scp [-r] a1234567@phoenix.adelaide.edu.au:path/to/source path/to/destination
```

