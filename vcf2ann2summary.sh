#!/usr/bin/env zsh
set -e  # Exit on error

# -----------------------------
# Parse command-line arguments
# -----------------------------
while getopts "V:O:DB:" opt; do
  case ${opt} in
    V) VCF_IN="$OPTARG" ;;
    O) OUT_PREFIX="$OPTARG" ;;
    DB) SNPEFF_DB="$OPTARG" ;;
    *) echo "Usage: $0 -V input.vcf -O output_name -DB snpEff_database" >&2
       exit 1 ;;
  esac
done

# Check required arguments
if [[ -z "$VCF_IN" || -z "$OUT_PREFIX" || -z "$SNPEFF_DB" ]]; then
  echo "❌ Error: All arguments -V, -O, -DB are required."
  echo "Usage: $0 -V input.vcf -O output_name -DB snpEff_database"
  exit 1
fi

echo "✅ Input VCF      : $VCF_IN"
echo "✅ Output Prefix  : $OUT_PREFIX"
echo "✅ snpEff DB      : $SNPEFF_DB"

# -----------------------------
# Step 1: Annotate with snpEff
# -----------------------------
echo "🎯 Running snpEff..."
snpEff -canon "$SNPEFF_DB" "$VCF_IN" > "${OUT_PREFIX}.annotated.vcf"

# -----------------------------
# Step 2: Extract summary table
# -----------------------------
echo "📊 Extracting annotation summary..."

awk -F'\t' '
BEGIN {
  OFS = "\t";
  print "CHROM", "POS", "rsID", "REF", "ALT", "AC", "GENE", "cDNA_CHANGE", "PROTEIN_CHANGE", "VARIANT_TYPE", "LOF";
}
# Skip VCF header lines
/^#/ { next }

{
  ref = $4;
  alt = $5;
  ac = lof = ann_field = ".";

  split($8, info, ";");
  for (i in info) {
    if (info[i] ~ /^AC=/)     { split(info[i], a, "="); ac = a[2]; }
    else if (info[i] ~ /^LOF=/) { split(info[i], a, "="); lof = a[2]; }
    else if (info[i] ~ /^ANN=/) { split(info[i], a, "="); ann_field = a[2]; }
  }

  split(ann_field, ann_entries, ",");
  split(ann_entries[1], ann, "|");

  gene           = ann[4];
  var_type       = ann[2];
  cDNA_change    = ann[10];
  protein_change = ann[11];

  print $1, $2, $3, ref, alt, ac, gene, cDNA_change, protein_change, var_type, lof;
}
' "${OUT_PREFIX}.annotated.vcf" > "${OUT_PREFIX}.summary.tsv"

echo "✅ Output written:"
echo "→ Annotated VCF : ${OUT_PREFIX}.annotated.vcf"
echo "→ Summary Table : ${OUT_PREFIX}.summary.tsv"
