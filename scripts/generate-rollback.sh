#!/bin/bash
# =============================================================================
# generate-rollback.sh
# Parcourt tout le fichier rollback SQL Liquibase et crée un fichier
# {prefix}-sql-{changeset_id}-rollback.sql pour chaque changeset trouvé
# dont le pattern est CONTENU dans le nom d'un fichier de generatedsql.
#
# Usage:
#   ./generate-rollback.sh <rollback_sql_file> <generatedsql_dir>
#
# Exemple:
#   ./generate-rollback.sh ./liquibase/rollback.sql ./generatedsql
# =============================================================================

set -euo pipefail

# --- Arguments ---------------------------------------------------------------
ROLLBACK_FILE="${1:-}"
GENERATED_DIR="${2:-}"

if [[ -z "$ROLLBACK_FILE" || -z "$GENERATED_DIR" ]]; then
    echo "Usage: $0 <rollback_sql_file> <generatedsql_dir>"
    echo "Exemple: $0 ./liquibase/rollback.sql ./generatedsql"
    exit 1
fi

if [[ ! -f "$ROLLBACK_FILE" ]]; then
    echo "Erreur : fichier rollback introuvable -> $ROLLBACK_FILE"
    exit 1
fi

if [[ ! -d "$GENERATED_DIR" ]]; then
    echo "Erreur : dossier introuvable -> $GENERATED_DIR"
    exit 1
fi

# --- Parsing -----------------------------------------------------------------
current_id=""
current_file=""
has_sql=0
created=0
skipped=0

flush_changeset() {
    if [[ -n "$current_id" && -n "$current_file" ]]; then
        if [[ "$has_sql" -eq 1 ]]; then
            echo "Create : $(basename "$current_file")"
            (( created++ )) || true
        else
            rm -f "$current_file"
            echo "Ignore (rollback vide) : $current_id"
            (( skipped++ )) || true
        fi
    fi
}

while IFS= read -r line || [[ -n "$line" ]]; do

    # Détecte -- Rolling Back ChangeSet: ...
    if echo "$line" | grep -qE '^\-\-[[:space:]]+Rolling Back ChangeSet:'; then

        # Flush le changeset précédent
        flush_changeset

        # Réinitialise
        current_id=""
        current_file=""
        has_sql=0

        # Extrait l'id du changeset (entre :: et ::)
        changeset_id=$(echo "$line" | sed 's/.*::\([^:]*\)::.*/\1/')

        # Cherche le fichier SQL dont le nom CONTIENT le pattern changeset_id
        # Exclut les fichiers -rollback.sql déjà générés
        matched_file=$(ls "$GENERATED_DIR"/*.sql 2>/dev/null \
            | grep -v "\-rollback\.sql" \
            | grep "${changeset_id}" \
            | head -1 || true)

        if [[ -z "$matched_file" ]]; then
            echo "Pas de fichier SQL trouve pour : $changeset_id (ignore)"
            continue
        fi

        # Récupère le préfixe numérique (ex: 00004)
        prefix=$(basename "$matched_file" | sed 's/-sql-.*//')

        current_id="$changeset_id"
        current_file="$GENERATED_DIR/${prefix}-sql-${changeset_id}-rollback.sql"

        # Entête du fichier rollback
        {
            echo "-- ============================================================"
            echo "-- Rollback Changeset : $changeset_id"
            echo "-- ============================================================"
        } > "$current_file"

        continue
    fi

    # Si on est dans un changeset valide, on écrit la ligne
    if [[ -n "$current_file" ]]; then
        echo "$line" >> "$current_file"
        # Vérifie si la ligne contient du vrai SQL
        if echo "$line" | grep -qvE '^\s*(--|$)'; then
            has_sql=1
        fi
    fi

done < "$ROLLBACK_FILE"

# Flush le dernier changeset
flush_changeset

# --- Résumé ------------------------------------------------------------------
echo ""
echo "✅  Génération rollback terminée."
echo "    Fichiers crees  : $created"
echo "    Ignores         : $skipped"
echo "    Dossier         : $GENERATED_DIR"
echo ""
ls -1 "$GENERATED_DIR"/*-rollback.sql 2>/dev/null || echo "(aucun fichier rollback généré)"