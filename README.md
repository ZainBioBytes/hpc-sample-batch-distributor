# hpc-sample-batch-distributor
Round-robin batch distribution of paired-end read files across HPC job batches using symbolic links.

# distribute_samples_to_batches.sh

## Description
Distributes rRNA-removed paired-end read files from rectal scour calf samples
into batches using symbolic links, for use in downstream annotation pipelines.

## Requirements
- PBS job scheduler (HPC)
- Paired-end rRNA-removed reads in `.fq.gz` format

## Input
- rRNA-removed sample directories under `4_rrna_rm/`
- Expected file naming: `{sample}_trim_xh_xrrna_R1.fq.gz` and `_R2.fq.gz`

## Output
- Symbolic links distributed across `input_batch1/`, `input_batch2/`, etc.

## Usage
```bash
qsub distribute_samples_to_batches.sh
```

## Parameters
| Parameter | Default | Description |
|-----------|---------|-------------|
| `BATCHES` | 2 | Number of batches for round-robin distribution |
| `BASE` | `rRNA.direcotory/` | Source directory of rRNA-removed samples |
| `DEST` | `dest.directory/` | Destination for batched symlinks |

## Notes
- Uses round-robin distribution to balance samples evenly across batches
- Skips samples where rRNA-removed paired files are not found
