#!/bin/bash

# Este script realiza un proceso de pruning (filtrado) de SNPs basado en desequilibrio de ligamiento (LD)
# para un cromosoma específico. El objetivo es obtener un conjunto de SNPs independientes (no correlacionados)
# y comunes (MAF ≥ 0.05), excluyendo regiones de alto LD y utilizando una máscara estricta.

# Definir el cromosoma de interés (cambia este valor según el que hayas procesado, por ejemplo 22)
chr=22

mkdir -p 1kg-prune

# Archivo de lista para fusión (aunque sea un solo cromosoma, se crea por si acaso)
> mergelist.txt

echo "Realizando pruning LD para el cromosoma ${chr}..."

# Paso 1: Calcular la lista de SNPs independientes (pruning)
plink \
    --bfile 1kg-plink/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes \
    --maf 0.05 \
    --extract strict_mask_variants.txt \
    --exclude high_ld_variants.txt \
    --indep-pairwise 500 50 0.2 \
    --out 1kg-prune/ALL.ldpruned.nohla.common.strict.chr${chr}

# Verificar que el archivo .prune.in se haya creado
if [ ! -f 1kg-prune/ALL.ldpruned.nohla.common.strict.chr${chr}.prune.in ]; then
    echo "Error: No se generó el archivo prune.in. Abortando."
    exit 1
fi

# Paso 2: Crear un nuevo archivo BED con solo los SNPs independientes
plink \
    --bfile 1kg-plink/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes \
    --extract 1kg-prune/ALL.ldpruned.nohla.common.strict.chr${chr}.prune.in \
    --make-bed \
    --out 1kg-prune/ALL.ldpruned.nohla.common.strict.chr${chr}

# Agregar la ruta al archivo de fusión (opcional, para mantener compatibilidad)
echo "1kg-prune/ALL.ldpruned.nohla.common.strict.chr${chr}" >> mergelist.txt

echo "Pruning completado para el cromosoma ${chr}."
echo "Resultado: 1kg-prune/ALL.ldpruned.nohla.common.strict.chr${chr}.{bed,bim,fam}"