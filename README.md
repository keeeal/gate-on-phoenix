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

*Recommendation:* Set up [SSH keys](https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys) for better security and not having to type your password:

```
ssh-keygen
ssh-copy-id a1234567@phoenix.adelaide.edu.au
```

### Copying files/folders to/from Phoenix

#### Copy file to phoenix:

```
scp path/to/file.txt a1234567@phoenix.adelaide.edu.au:path/to/destination.txt
```

#### Copy folder to Phoenix:

```
scp -r path/to/folder a1234567@phoenix.adelaide.edu.au:path/to/destination
```

#### Copy files/folders from Phoenix:

```
scp [-r] a1234567@phoenix.adelaide.edu.au:path/to/source path/to/destination
```

### Data management on Phoenix

- Your *home* directory has ~10GB of storage and should not be used for active job data. 
- Your *fast* directory has 1TB of storage and is intended for active job data.

#### Access your *fast* directory:

```
cd /fast/users/a1234567
```

or

```
cd $FASTDIR
```

#### Check your current disk usage:

```
rcdu
```

### Software on Phoenix

 - Phoenix uses `module` to manage software.
 
#### List everything that is available:

```
module avail
```

#### Search for a package:

```
module spider keyword
```

#### Load a package:

```
module load package-name
```

### Loading GATE on Phoenix

 - GATE is not up to date and has missing data dependencies.
 - Currently only usable when compiled from source.

Simplified instructions coming soon.

### Directory structure

 - Suppose you have folder of GATE code that is run by executing `main.mac`.

```
project
└─── main.mac
```

#### Create `gate.txt`:

```
project
├─── main.mac
└─── gate.txt
```

`gate.txt` contains the initial GATE commands to execute:

```
/control/execute main.mac
exit
```

#### Create `run.sh`:

```
project
├── main.mac
├── gate.txt
└── run.sh
```

`run.sh` creates an output directory from an argument and runs the GATE code:

```
# create output directory variable
export OUTPUTDIR=output/$1

# create output directory
rm -rf $OUTPUTDIR
mkdir -p $OUTPUTDIR

# Run
Gate < gate.txt
```

### Job scripts

 - Keep time/memory limits close to expected usage for better queue priority.
 - Pass job ID and array task ID (index) to run.sh for distinct output locations.

#### Create `job.sh`

```
project
├── main.mac
├── gate.txt
├── run.sh
└── job.sh
```

`job.sh` describes your workload to the job queue:

```
#!/bin/bash
#SBATCH	--job-name="name"
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=01:00:00
#SBATCH --mem=512MB
#SBATCH --array=1-64

# Notifications
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=a1234567@adelaide.edu.au

# Load modules
module load GATE/7.2-foss-2015b

# Run
./run.sh ${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}
```

#### Submit a job

```
sbatch job.sh
```

#### Check the status of your jobs

```
squeue -u a1234567
```

#### Cancel a job

```
scancel 9999
```

where `9999` is the job ID.

#### Cancel all of your jobs

```
scancel -u a1234567
```

### GATE output

Coming soon.

