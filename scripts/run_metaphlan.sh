#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=12:00:00

# Load MetaPhlan
module load metaphlan/4.2.2

# 1. Merge the paired-end files (Commented out because it is already done!)
# for file1 in ./*R1*; do
#     file2=${file1/R1/R2}
#     zcat ${file1} ${file2} > ${file1%R1*}merged.fastq
# done

# 2. Run MetaPhlan on all merged files (using 16 cores)
for f in *merged.fastq; do
    # NOTE: Changed multifastq to fastq here!
    metaphlan $f --input_type fastq --nproc 16 > ${f%merged.fastq}_profile.txt
done

# 3. Merge all the individual results into one master table
merge_metaphlan_tables.py *_profile.txt > merged_abundance_table.txt

# 4. Clean up the table to only show the Species-level data
grep -E "(s__)|(^ID)" merged_abundance_table.txt | grep -v "t__" | sed 's/^.*s__//g' > merged_abundance_table_species.txt
