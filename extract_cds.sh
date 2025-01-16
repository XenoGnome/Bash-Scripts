#!/bin/bash

# Input files
GENOME_FILE="crocus_sativus.gene.gff3"
GENE_LIST="CsFPF1Subject_IDMCScanX.txt"
OUTPUT_FILE="extracted_cds.txt"

# Initialize the output file with a header
echo -e "Chromosome_ID\tGene_ID\tStart_Position\tStop_Position" > $OUTPUT_FILE

# Loop through each gene ID in the list
while read -r gene_id; do
  # Extract CDS lines matching the gene ID
  grep -w "$gene_id" "$GENOME_FILE" | awk -v gene="$gene_id" '
BEGIN { OFS="\t" }
{
  # Check if line contains "CDS" and gene ID in attributes
  if ($3 == "CDS" && $9 ~ gene) {
    print $1, gene, $4, $5
  }
}' >> $OUTPUT_FILE
done < "$GENE_LIST"  # Close the while loop and specify the input file

echo "Extraction complete. Results saved in $OUTPUT_FILE."