#!/bin/bash

# Este script prepara una segunda versión del archivo PLINK para un cromosoma específico,
# excluyendo los SNPs problemáticos que causaron conflictos durante el primer intento de merge.
# El resultado es un archivo limpio que puede ser usado en una nueva fusión (aunque sea un único cromosoma).

# Definir el cromosoma de interés (cambia este valor según el que hayas procesado, por ejemplo 22)
chr=22

mkdir -p 1kg-merge

# Crear (o vaciar) el archivo de lista para la segunda fusión
> mergelist2.txt

# Verificar que el archivo de SNPs conflictivos existe (generado en el primer merge)
missnp_file="1kg-merge/ALL.ldpruned.nohla.common.strict.all-merge.missnp"
if [ ! -f "$missnp_file" ]; then
    echo "Advertencia: No se encontró el archivo de SNPs conflictivos: $missnp_file"
    echo "Se procederá sin excluir ningún SNP."
    exclude_arg=""
else
    exclude_arg="--exclude $missnp_file"
fi

# Verificar que el archivo prune.in existe
prune_in="1kg-prune/ALL.ldpruned.nohla.common.strict.chr${chr}.prune.in"
if [ ! -f "$prune_in" ]; then
    echo "Error: No se encuentra el archivo prune.in: $prune_in"
    exit 1
fi

echo "Generando archivo PLINK limpio para el cromosoma ${chr} (excluyendo SNPs conflictivos)..."

plink \
    --bfile 1kg-plink/ALL.chr"${chr}".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes \
    --extract "$prune_in" \
    $exclude_arg \
    --make-bed \
    --out 1kg-merge/ALL.ldpruned.nohla.common.strict.chr${chr}

# Agregar la ruta al archivo generado a la nueva lista de fusión
echo "1kg-merge/ALL.ldpruned.nohla.common.strict.chr${chr}" >> mergelist2.txt

echo "Procesamiento completado para el cromosoma ${chr}."
echo "Archivo generado: 1kg-merge/ALL.ldpruned.nohla.common.strict.chr${chr}.{bed,bim,fam}"
echo "Lista actualizada en mergelist2.txt"