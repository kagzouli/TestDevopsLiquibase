#!/bin/bash
# =============================================================================
# generate-update.sh
# Parse un fichier SQL généré par Liquibase et crée un fichier .sql numéroté
# par changeset : 00001-sql-{changeset_id}.sql, 00002-sql-{changeset_id}.sql, ...
# Les changesets sans SQL (ex: start-tag) sont automatiquement ignorés.
#
# Usage:
#   ./generate-update.sh <input_file> [output_dir]
#
# Exemple:
#   ./generate-update.sh update.sql ./output
# =============================================================================

set -euo pipefail

# --- Arguments ---------------------------------------------------------------
INPUT_FILE="${1:-}"
OUTPUT_DIR="${2:-./output}"

if [[ -z "$INPUT_FILE" ]]; then
    echo "Usage: $0 <input_file> [output_dir]"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Erreur : fichier introuvable -> $INPUT_FILE"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# --- Parsing -----------------------------------------------------------------
counter=0          # compteur de fichiers créés
current_file=""    # fichier de sortie courant
in_changeset=0     # sommes-nous dans un bloc changeset ?

flush_if_empty() {
    # Supprime le fichier courant s'il ne contient que des commentaires / lignes vides
    if [[ -n "$current_file" && -f "$current_file" ]]; then
        sql_lines=$(grep -cvE '^\s*(--|$)' "$current_file" || true)
        if [[ "$sql_lines" -eq 0 ]]; then
            rm -f "$current_file"
            (( counter-- )) || true
        fi
    fi
}

while IFS= read -r line || [[ -n "$line" ]]; do

    # Détecte une ligne "-- Changeset ..."
    if echo "$line" | grep -qE '^\-\-[[:space:]]+Changeset[[:space:]]+'; then

        # Ferme le fichier précédent (supprime s'il est vide de SQL)
        flush_if_empty

        # Incrémente le compteur
        (( counter++ )) || true

        # Extrait les métadonnées du changeset
        # Format : db/changelog/vX.X.X/fichier.yml::changeset_id::auteur
        changeset_full=$(echo "$line" | sed 's/^--[[:space:]]*Changeset[[:space:]]*//')

        # Récupère l'id du changeset (entre le 1er et le 2ème ::)
        changeset_id=$(echo "$changeset_full" | sed 's/.*::\([^:]*\)::.*/\1/')

        # Construit le nom de fichier : 00001-sql-{changeset_id}.sql
        filename="$(printf '%05d' "$counter")-sql-${changeset_id}.sql"
        current_file="$OUTPUT_DIR/$filename"

        {
            echo "-- ============================================================"
            echo "-- Changeset #$(printf '%05d' "$counter")"
            echo "-- $changeset_full"
            echo "-- ============================================================"
        } > "$current_file"

        in_changeset=1
        continue
    fi

    # Ignore le header global Liquibase (avant le 1er Changeset)
    if [[ "$in_changeset" -eq 0 ]]; then
        continue
    fi

    # Écrit la ligne dans le fichier courant
    echo "$line" >> "$current_file"

done < "$INPUT_FILE"

# Dernier fichier : vérifie s'il est vide
flush_if_empty

# --- Résumé ------------------------------------------------------------------
echo ""
echo "✅  Parsing terminé."
echo "    Fichiers créés : $counter"
echo "    Dossier de sortie : $OUTPUT_DIR"
echo ""
ls -1 "$OUTPUT_DIR"/*.sql 2>/dev/null || echo "(aucun fichier généré)"