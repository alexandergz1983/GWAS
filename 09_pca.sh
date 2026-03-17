#!/bin/bash

# Este script realiza un análisis de componentes principales (PCA)
# sobre el conjunto de datos genotípicos final (previamente filtrado y fusionado)
# para un cromosoma específico, con el fin de explorar la estructura poblacional
# y detectar posibles valores atípicos.

# Definir el cromosoma de interés (cambia este valor según el que hayas procesado, por ejemplo 22)
chr=22

mkdir -p 1kg-pca

echo "Realizando PCA para el cromosoma ${chr}..."

plink \
    --bfile 1kg-merge/ALL.ldpruned.nohla.common.strict.all \
    --pca \
    --out 1kg-pca/ALL.ldpruned.nohla.common.strict.all.chr${chr}

echo "PCA completado. Resultados en:"
echo "  1kg-pca/ALL.ldpruned.nohla.common.strict.all.chr${chr}.eigenvec"
echo "  1kg-pca/ALL.ldpruned.nohla.common.strict.all.chr${chr}.eigenval"