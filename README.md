# GATE on Phoenix
A tutorial and code for running GATE on Phoenix

## Resources

 - [The Phoenix HPC Wiki](https://wiki.adelaide.edu.au/hpc/index.php/Main_Page)

# Cheat Sheet

## Logging into Phoenix

```
ssh a1234567@phoenix.adelaide.edu.au
```

<details>
<summary>Tip</summary>

Set up [SSH keys](https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys) for better security and not having to type your password:

```
ssh-keygen
ssh-copy-id a1234567@phoenix.adelaide.edu.au
```

</details>

## Copying files/folders to/from Phoenix

#### Copy file to phoenix

```
scp path/to/file.txt a1234567@phoenix.adelaide.edu.au:path/to/destination.txt
```

#### Copy folder to Phoenix

```
scp -r path/to/folder a1234567@phoenix.adelaide.edu.au:path/to/destination
```

#### Copy files/folders from Phoenix

```
scp [-r] a1234567@phoenix.adelaide.edu.au:path/to/source path/to/destination
```

<details>
<summary>Tip</summary>

Check out [rsync](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps), an alternative to `scp` that only copies files that have been updated.

For larger, longer-term projects use [git](https://rogerdudler.github.io/git-guide/) and GitHub for version control.

</details>

## Data management on Phoenix

- Your *home* directory has ~10GB of storage and should not be used for active job data.
- Your *fast* directory has 1TB of storage and is intended for active job data.

#### Check your current disk usage

```
rcdu
```

#### Access your *fast* directory

```
cd /fast/users/a1234567
```

or

```
cd $FASTDIR
```

<details>
<summary>Tip</summary>

Create a [symbolic link](https://kb.iu.edu/d/abbe) to your fast directory in your home directory

```
ln -s /fast/users/a1234567 ~/fast
```

so that you can shorten your `scp` commands from

```
scp file a1608007@phoenix.adelaide.edu.au:/fast/users/a1608007/file
```

to

```
scp file a1608007@phoenix.adelaide.edu.au:fast/file
```

</details>

## Software on Phoenix

 - Phoenix uses [Lmod](https://lmod.readthedocs.io/en/latest/) to manage software.

#### List everything that is available

```
module avail
```

#### Search for a package

```
module spider keyword
```

#### Load a package

```
module load package-name
```

## Loading GATE

At the time of writing the latest version of GATE on Phoenix is 8.2.

```
module load GATE/8.2-foss-2016b-c11-Python-2.7.13
```

This also loads GATE's dependencies, including Geant4 10.5 and ROOT 6.09.02.

## Creating a run script

 - Suppose you have a folder of GATE code that is run by executing `main.mac`.

```
project
└─── main.mac
```

#### Create `gate.txt`

```
project
├─── main.mac
└─── gate.txt
```

`gate.txt` contains the initial GATE command to execute and exits when done:

```
/control/execute main.mac
exit
```

This provides a simple way of starting a simulation from the command line:

```
Gate < "gate.txt"
```

#### Create `run.sh`

```
project
├─── main.mac
├─── gate.txt
└─── run.sh
```

`run.sh` creates an output directory from an argument and runs the GATE code:

```
# create output directory variable
export OUTPUTDIR=output/$1

# create output directory
rm -rf $OUTPUTDIR
mkdir -p $OUTPUTDIR

# run
Gate < gate.txt
```

This allows different runs to have different output directories, eg:

```
./run.sh output_1
```

## Setting the output directory in GATE

#### Get the environment variable in GATE

```
/control/getEnv OUTPUTDIR
```

#### Use the environment variable in GATE

```
gate/actor/addActor DoseActor dose
/gate/actor/dose/save {OUTPUTDIR}/output.mhd
```

This sets the output to the correct directory.

## Jobs

 - Keep time/memory limits close to expected usage for better queue priority.
 - Pass job ID and array task ID (index) to run.sh for distinct output locations.

#### Create `job.sh`

```
project
├─── main.mac
├─── gate.txt
├─── run.sh
└─── job.sh
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

# notifications
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=a1234567@adelaide.edu.au

# load modules
module load GATE/8.2-foss-2016b-c11-Python-2.7.13

# run
./run.sh ${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}
```

This ensures that each job and array task get a unique output directory.

#### Submit a job

```
sbatch job.sh
```

#### Check the status of your jobs

```
squeue -u a1234567
```

#### Check the progress of a GATE simulation

```
cat $OUTPUTDIR/output-stat.txt
```

#### Cancel a job

```
scancel JOB_ID
```

#### Cancel all of your jobs

```
scancel -u a1234567
```

## Handling GATE output

#### Install Python packages

[scikit-image](https://scikit-image.org/), [simpleitk](https://simpleitk.org/)

```
pip install scikit-image simpleitk
```

<details>
<summary>Tip</summary>

When scikit-image is installed using [Anaconda](https://www.anaconda.com/products/individual) it also installs low-level libraries that increase performance:

```
conda install scikit-image
```

</details>

#### Read MHD files with python

```
from skimage import io
array = io.imread(path, plugin='simpleitk')
```
