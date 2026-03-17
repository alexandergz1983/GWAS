#!/bin/bash

# Este script procesa archivos PLINK binarios de un cromosoma específico 
# para extraer listas de variantes (SNPs) que caen dentro de regiones genómicas específicas:
# una máscara estricta y regiones de alto desequilibrio de ligamiento (LD). 
# El objetivo es generar dos archivos acumulativos con los identificadores de esos SNPs,
# que luego podrán usarse para excluirlos en análisis de control de calidad o pruning.

# Definir el cromosoma de interés (cambia este valor según el que hayas procesado, por ejemplo 22)
chr=22

mkdir -p 1kg-prune

# Crear (o vaciar) los archivos acumulativos
> strict_mask_variants.txt
> high_ld_variants.txt

echo "Procesando cromosoma ${chr} para máscara estricta..."

plink \
    --bfile 1kg-plink/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes \
    --make-set 1kg/20141020.strict_mask.whole_genome.bed \
    --write-set \
    --out 1kg-prune/strict_mask_chr${chr}

# Verificar que el archivo .set se haya creado antes de concatenar
if [ -f "1kg-prune/strict_mask_chr${chr}.set" ]; then
    cat "1kg-prune/strict_mask_chr${chr}.set" >> strict_mask_variants.txt
else
    echo "Advertencia: No se encontró el archivo 1kg-prune/strict_mask_chr${chr}.set"
fi

echo "Procesando cromosoma ${chr} para regiones de alto LD..."

plink \
    --bfile 1kg-plink/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes \
    --make-set high_ld_hg19.txt \
    --write-set \
    --out 1kg-prune/high_ld_chr${chr}

if [ -f "1kg-prune/high_ld_chr${chr}.set" ]; then
    cat "1kg-prune/high_ld_chr${chr}.set" >> high_ld_variants.txt
else
    echo "Advertencia: No se encontró el archivo 1kg-prune/high_ld_chr${chr}.set"
fi

echo "Procesamiento completado para el cromosoma ${chr}."
echo "Resultados acumulados en: strict_mask_variants.txt y high_ld_variants.txt"