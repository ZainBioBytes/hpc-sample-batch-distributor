#!/bin/bash
#PBS -l ncpus=2
#PBS -l mem=4GB
#PBS -m abe
#PBS -M your_email@institution.edu.au

# =============================================================================
# Script: distribute_samples_to_batches.sh
# Description: Distributes rRNA-removed paired-end read files from rRNA removed
#              samples into batches using symbolic links for downstream
#              annotation analysis.
# Author: Zain
# Usage: qsub distribute_samples_to_batches.sh
# =============================================================================

cd $PBS_O_WORKDIR

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
BASE="/data/project/rrna_input"                    # Input directory containing rRNA-removed sample folders
DEST="/data/project/output_dest" # Output destination for batched input
BATCHES=2                                                              # Number of batches for round-robin distribution

# -----------------------------------------------------------------------------
# Create batch directories
# -----------------------------------------------------------------------------
for ((i=1; i<=BATCHES; i++)); do
    mkdir -p "$DEST/input_batch$i"
done

# -----------------------------------------------------------------------------
# Distribute samples across batches using round-robin
# -----------------------------------------------------------------------------
counter=0

for sample in "$BASE"/*; do
    [ -d "$sample" ] || continue

    name=$(basename "$sample")

    r1="$sample/out/${name}_trim_xh_xrrna_R1.fq.gz" ###check the sample name
    r2="$sample/out/${name}_trim_xh_xrrna_R2.fq.gz" ###check the sample name

    if [[ -f "$r1" && -f "$r2" ]]; then

        # Round-robin batch assignment
        batch=$(( (counter % BATCHES) + 1 ))
        target="$DEST/input_batch$batch"

        echo "Linking $name -> batch $batch"

        ln -sf "$r1" "$target/"
        ln -sf "$r2" "$target/"

        ((counter++))
    else
        echo "Skipping $name (rRNA-removed paired files not found)"
    fi
done

echo "Total samples distributed: $counter"