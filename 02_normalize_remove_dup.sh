#!/bin/bash

# Este script procesa el archivo VCF de un cromosoma específico del proyecto 1000 Genomes (fase 3)
# para normalizarlo, asignarle identificadores únicos y eliminar duplicados,
# generando un archivo BCF indexado listo para su uso en análisis posteriores.
# Ajusta el valor de chr al cromosoma que descargaste (por ejemplo, 22).

chr=22  # Cambia esto al cromosoma que descargaste

mkdir -p 1kg-norm-nodup

# Descomprimir la referencia si no está ya descomprimida
if [ ! -f 1kg/human_g1k_v37.fasta ]; then
    echo "Descomprimiendo referencia..."
    gunzip -k 1kg/human_g1k_v37.fasta.gz  # -k mantiene el archivo comprimido original
fi

echo "Procesando cromosoma ${chr}..."

bcftools norm -m-any --check-ref w -f 1kg/human_g1k_v37.fasta \
    1kg/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz | \
    bcftools annotate -x ID -I +'%CHROM:%POS:%REF:%ALT' | \
    bcftools norm -Ob --rm-dup both \
        > 1kg-norm-nodup/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf

bcftools index 1kg-norm-nodup/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf

echo "Procesamiento completado para el cromosoma ${chr}."