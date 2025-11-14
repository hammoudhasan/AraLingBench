#!/usr/bin/env bash

# Simple helper to run AraBench difficulty + category evaluations on one model.

set -euo pipefail

MODEL="hammh0a/Hala-350M"
CUSTOM_TASKS="community_tasks/arabic_evals.py"
MODEL_ARGS="model_name=${MODEL},dtype=bfloat16,override_chat_template=True"
MODEL_SAFE=${MODEL//\//_}

DIFFICULTY_TASKS="community|arabench_english:easy|0,community|arabench_english:medium|0,community|arabench_english:hard|0"
CATEGORY_TASKS="community|arabench_english:الإملاء|0,community|arabench_english:التركيب_اللغوي_والأسلوبي|0,community|arabench_english:الصرف|0,community|arabench_english:النحو|0,community|arabench_english:فهم_اللغة|0"

run_eval() {
    local mode=$1
    local tasks=$2
    local out_dir=$3

    mkdir -p "${out_dir}"

    echo "──────────────────────────────────────────────"
    echo "Running ${mode} evaluation for ${MODEL}"
    echo "Output directory: ${out_dir}"
    echo "──────────────────────────────────────────────"

    lighteval accelerate \
        --custom-tasks "${CUSTOM_TASKS}" \
        --output-dir "${out_dir}" \
        "${MODEL_ARGS}" \
        "${tasks}"
}

run_eval "difficulty" "${DIFFICULTY_TASKS}" "results_difficulty/arabench_difficulty_${MODEL_SAFE}"
run_eval "category" "${CATEGORY_TASKS}" "results_category/arabench_category_${MODEL_SAFE}"
