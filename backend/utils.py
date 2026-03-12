import re
import json
import logging

from json_repair import repair_json

def clean_json_string(text: str) -> str:
    """
    Robustly extracts the first balanced JSON object from a string and repairs it.
    """
    # Remove markdown blocks
    text = re.sub(r"```json|```", "", text).strip()
    
    # Simple extract using regex for first { and last }
    match = re.search(r"\{.*\}", text, re.DOTALL)
    extracted = text
    if match:
        extracted = match.group(0)
    
    try:
        # Use json-repair to fix common issues like unescaped quotes or missing braces
        repaired = repair_json(extracted)
        return repaired
    except Exception:
        return extracted

def calculate_overall_score(scores: dict) -> float:
    """
    Calculates the average score from a dictionary of scores.
    """
    if not scores:
        return 0.0
    return round(sum(scores.values()) / len(scores), 1)

def validate_scores(scores: dict):
    """
    Ensures all scores are integers between 0 and 10.
    """
    for key, value in scores.items():
        if not isinstance(value, (int, float)):
             scores[key] = 0
        if value < 0:
            scores[key] = 0
        if value > 10:
             scores[key] = 10
    return scores
