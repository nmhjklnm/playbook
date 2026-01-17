#!/usr/bin/env bash
set -euo pipefail

# Emit a human-readable index of docs in repo root.
#
# Doc files: <stage>.<topic>.md
# stage: join | secure | build | run
#
# Required frontmatter in each doc:
# ---
# name: ...
# description: ...
# ---

shopt -s nullglob

extract_fm_field() {
  local file="$1"
  local field="$2"
  awk -v field="$field" 'BEGIN{in_fm=0}
    $0=="---"{if(in_fm==0){in_fm=1;next}else{exit}}
    in_fm==1 && $1==field":"{
      sub("^"field":[[:space:]]*","",$0);
      print $0;
      exit
    }
  ' "$file"
}

print_stage() {
  local stage="$1"
  shift
  local files=("$@")

  printf "\n[%s]\n" "$stage"

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi

  local f name desc
  for f in "${files[@]}"; do
    name=$(extract_fm_field "$f" "name")
    desc=$(extract_fm_field "$f" "description")

    if [[ -z "${name}" || -z "${desc}" ]]; then
      printf -- "- %s  (missing name/description frontmatter)\n" "$f" 1>&2
      continue
    fi

    printf -- "- %s → %s: %s\n" "$f" "$name" "$desc"
  done
}

echo "playbook index"

join_files=()
secure_files=()
build_files=()
run_files=()

for path in "$PWD"/*.md; do
  f=$(basename "$path")
  [[ "$f" == "README.md" ]] && continue

  stage=${f%%.*}
  case "$stage" in
    join) join_files+=("$f") ;;
    secure) secure_files+=("$f") ;;
    build) build_files+=("$f") ;;
    run) run_files+=("$f") ;;
    *) echo "- $f  (unknown stage prefix: $stage)" 1>&2 ;;
  esac
done

IFS=$'\n' join_files=($(printf '%s\n' "${join_files[@]}" | sort))
IFS=$'\n' secure_files=($(printf '%s\n' "${secure_files[@]}" | sort))
IFS=$'\n' build_files=($(printf '%s\n' "${build_files[@]}" | sort))
IFS=$'\n' run_files=($(printf '%s\n' "${run_files[@]}" | sort))
unset IFS

print_stage "join" "${join_files[@]}"
print_stage "secure" "${secure_files[@]}"
print_stage "build" "${build_files[@]}"
print_stage "run" "${run_files[@]}"
