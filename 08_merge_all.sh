#!/bin/bash

# Este script realiza la segunda fusión (merge) de los archivos PLINK del cromosoma procesado,
# utilizando la lista mergelist2.txt generada en el paso anterior después de excluir los SNPs problemáticos.
# El objetivo es obtener un único archivo PLINK final con los SNPs que pasaron todos los filtros,
# listo para análisis posteriores.

mkdir -p 1kg-merge

# Verificar que mergelist2.txt existe y no está vacío
if [ ! -s mergelist2.txt ]; then
    echo "Error: mergelist2.txt está vacío o no existe."
    echo "Asegúrate de haber ejecutado el script de segunda ronda (segunda_ronda_un_cromosoma.sh)."
    exit 1
fi

echo "Realizando la segunda fusión del cromosoma (merge final)..."
plink \
    --merge-list mergelist2.txt \
    --make-bed \
    --out 1kg-merge/ALL.ldpruned.nohla.common.strict.all

echo "Fusión completada."
echo "Archivos finales generados en:"
echo "  1kg-merge/ALL.ldpruned.nohla.common.strict.all.bed"
echo "  1kg-merge/ALL.ldpruned.nohla.common.strict.all.bim"
echo "  1kg-merge/ALL.ldpruned.nohla.common.strict.all.fam"