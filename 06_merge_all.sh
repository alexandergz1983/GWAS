#!/bin/bash

# Este script realiza la fusión (merge) de los archivos PLINK del cromosoma procesado
# en un único archivo (aunque solo sea un cromosoma). El resultado es un conjunto de datos genotípicos
# listo para análisis posteriores.

mkdir -p 1kg-merge

# Verificar que mergelist.txt existe y no está vacío
if [ ! -s mergelist.txt ]; then
    echo "Error: mergelist.txt está vacío o no existe. Asegúrate de haber ejecutado el script de pruning."
    exit 1
fi

echo "Fusionando archivos del cromosoma en un único conjunto..."
plink \
    --merge-list mergelist.txt \
    --make-bed \
    --out 1kg-merge/ALL.ldpruned.nohla.common.strict.all

echo "Fusión completada. Archivos en 1kg-merge/"