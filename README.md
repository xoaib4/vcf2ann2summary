# vcf2ann2summary
A simple, lightweight script that annotates VCF files using **snpEff** and generates a clean, tab-delimited summary table of variant annotations.

---

## Features

- Runs `snpEff` to annotate variants.
- Extracts key information: chromosome, position, rsID, REF/ALT alleles, allele count, gene name, cDNA/protein changes, variant type, and LOF annotation.
- Produces:
  - Annotated VCF file
  - Summary TSV table for downstream analysis or Excel viewing

---

## Requirements

- `zsh` (or `bash` with minor edits)
- [`snpEff`](http://pcingola.github.io/SnpEff/)
- `awk`
- A valid `snpEff` database (e.g., `GRCh38.99`)

---

## Installation

No installation is required. Just make the script executable:

```
chmod +x vcf2ann2summary.sh
```
## Usage
```
./vcf2ann2summary.sh -V input.vcf -O output_prefix -DB snpEff_database
```
### Parameters
```
-V	Input VCF file (uncompressed)
-O	Output prefix (used for VCF and TSV)
-DB	Name of the snpEff database to use (e.g., GRCh38.99)
```
### Output Files
`${output_prefix}.annotated.vcf` — VCF file annotated by snpEff

`${output_prefix}.summary.tsv` — Tab-separated summary table of key annotations

### Example
```
./vcf2ann2summary.sh -V input.vcf -O output -DB GRCh38.99
```
### Example Output Table
```
CHROM	POS	rsID	REF	ALT	AC	GENE	cDNA_CHANGE	PROTEIN_CHANGE	VARIANT_TYPE	LOF
chr1	123456789	rs123456	A	G	12	ABC1	c.123A>G	p.Lys41Arg	missense_variant	YES
```
## Citation
If you use this script, please cite:
```
Akhtar, M.S., Ashino, R., Oota, H., Ishida, H., Niimura, Y., Touhara, K., Melin, A.D. and Kawamura, S., 2022. Genetic variation of olfactory receptor gene family in a Japanese population. Anthropological Science, 130(2), pp.93-106.
```
## Contact
Created by Muhammad Shoaib Akhtar
For questions, suggestions, or issues, please open an issue on GitHub.
