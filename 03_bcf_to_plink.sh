#!/bin/bash

# Este script convierte un archivo BCF (Binary Call Format) previamente normalizado de un cromosoma específico
# del proyecto 1000 Genomas al formato binario de PLINK (BED/BIM/FAM). El objetivo es preparar los datos genotípicos
# para su uso en análisis genéticos con PLINK, como estudios de asociación, control de calidad o cálculos de parentesco.

# Definir el cromosoma de interés (cambia este valor según el que hayas procesado, por ejemplo 22)
chr=22

mkdir -p 1kg-plink

echo "Convirtiendo cromosoma ${chr} a formato PLINK..."

plink \
    --bcf 1kg-norm-nodup/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bcf \
    --keep-allele-order \
    --vcf-idspace-to _ \
    --const-fid \
    --allow-extra-chr 0 \
    --split-x b37 no-fail \
    --make-bed \
    --out 1kg-plink/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes

echo "Conversión completada para el cromosoma ${chr}."