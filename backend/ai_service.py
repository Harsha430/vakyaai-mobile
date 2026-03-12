import os
import json
import google.generativeai as genai
from fastapi import HTTPException
from dotenv import load_dotenv
import logging
import asyncio
from schemas import AnalysisResult
from utils import clean_json_string, calculate_overall_score, validate_scores

load_dotenv()

# Configure Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configure Gemini
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY not found in .env file")

genai.configure(api_key=GEMINI_API_KEY)

# Gemini Model Configuration
generation_config = {
    "temperature": 0.4,
    "top_p": 0.9,
    "max_output_tokens": 4096,
    "response_mime_type": "application/json"
}


model = genai.GenerativeModel("gemini-2.5-flash", generation_config=generation_config)

PROMPT_TEMPLATE = """
Act as an elite Startup Mentor & Pitch Architect. 
Analyze the pitch below for the specific Target Audience: "{target_audience}".

MISSION:
1. Provide a rigorous evaluation with professional scores.
2. Refine the pitch into a "Top-Notch" version tailored EXACTLY for the {target_audience}.
3. Calculate "Improvement Metrics" by comparing your Refined version against the Original.
4. Detect missing components crucial for a high-stakes {target_audience} pitch.
5. Project delivery metrics (Confidence Index, Filler Word prediction).
6. Generate supporting materials:
    - Slides & Summaries.
    - **Personalized Skill Roadmap**: 3 actionable exercises based on lowest scores (e.g., if Clarity < 7, suggest "Concise Framing").
- **Curated Resources**: 4 high-value links. 
    - YouTube: Must be a specific tutorial or guide (e.g., "YouTube: How to Pitch by YC").
    - Category must EXACTLY be one of: "YouTube", "Blog", "Documentation", "Pitch Deck".

OUTPUT RULES:
- **VALID RAW JSON ONLY**. No preamble, no markdown blocks, no explanation text.
- No trailing commas. No comments inside JSON.
- Ensure all strings (like "improved_pitch") are properly escaped for internal quotes.
- Keep the response concise to avoid truncation.
- checklist: Identify 5 components. status=true if present, false if missing.
- summaries: elevator (30s), linkedin (hooky), email (formal).
- slides: 6 key slides (Title, Problem, Solution, Market/Architecture, Impact, Close).
- improvement_metrics: Clarity/Persuasion (0-10 scaled), Overall (score delta).
- filler_words: Predict likely problematic words based on text structure.
- practice_questions: 3 tough questions a {target_audience} would ask.
- personalized_roadmap: 3 steps with "title" and "description".

Pitch Text:
"{pitch_text}"

Response Schema:
{{
    "scores": {{
        "clarity": int, "problem_definition": int, "solution_explanation": int, "technical_depth": int, "innovation": int, "impact": int, "logical_flow": int, "persuasiveness": int
    }},
    "overall_score": float,
    "strengths": [str], "weaknesses": [str], "suggestions": [str],
    "improved_pitch": "Elite Refined Version",
    "improvement_metrics": {{
        "clarity_delta": int, "persuasion_delta": int, "overall_delta": float
    }},
    "checklist": [{{ "label": str, "status": bool }}],
    "slides": [{{ "title": str, "content": [str] }}],
    "summaries": {{ "elevator": str, "linkedin": str, "email": str }},
    "confidence_score": int,
    "filler_words": [{{ "word": str, "count": int }}],
    "suggested_resources": [{{ "title": str, "url": str, "category": "YouTube|Blog|Documentation|Pitch Deck" }}],
    "practice_questions": [str],
    "personalized_roadmap": [{{ "title": str, "description": str }}]
}}
"""

async def analyze_pitch_with_gemini(pitch_text: str, target_audience: str = "General Investor") -> dict:
    prompt = PROMPT_TEMPLATE.format(pitch_text=pitch_text, target_audience=target_audience)
    
    retries = 2
    for attempt in range(retries):
        try:
            response = await asyncio.wait_for(
                model.generate_content_async(prompt),
                timeout=45.0 
            )
            
            try:
                raw_text = response.text
            except Exception:
                 try:
                     raw_text = response.candidates[0].content.parts[0].text
                 except:
                     raw_text = ""
                     
            cleaned_text = clean_json_string(raw_text)
            
            try:
                # clean_json_string now uses json_repair internally
                repaired_json = clean_json_string(raw_text)
                data = json.loads(repaired_json)
                
                # Recalculate score logic
                if "scores" in data:
                     data["scores"] = validate_scores(data["scores"])
                     data["overall_score"] = calculate_overall_score(data["scores"])
                
                return data
                
            except json.JSONDecodeError as e:
                logger.error(f"JSON Parse Error (Attempt {attempt+1}): {e}")
                logger.debug(f"RAW TEXT: {raw_text[:500]}... (truncated)")
                if attempt == retries - 1:
                    # Final attempt fallback
                    return MOCK_ANALYSIS_RESULT
                continue 
                
        except asyncio.TimeoutError:
            logger.error(f"Gemini API Timeout (Attempt {attempt+1})")
            if attempt == retries - 1:
                 raise HTTPException(status_code=504, detail="AI processing timed out.")
            continue
            
        except Exception as e:
            logger.error(f"Gemini API Error: {e}")
            if attempt == retries - 1:
                return MOCK_ANALYSIS_RESULT
            continue

    raise HTTPException(status_code=500, detail="Failed to analyze pitch.")

# Mock Data for Fallback/Demo Mode
MOCK_ANALYSIS_RESULT = {
    "scores": {
        "clarity": 8, "problem_definition": 9, "solution_explanation": 7, "technical_depth": 8, "innovation": 9, "impact": 8, "logical_flow": 8, "persuasiveness": 7
    },
    "overall_score": 8.0,
    "strengths": ["Strong problem definition", "High innovation", "Technical feasibility"],
    "weaknesses": ["Vague monetization", "Weak competitive analysis", "Generic GTM plan"],
    "suggestions": ["Elaborate on subscription model", "Compare with competitors", "Define target audience"],
    "improved_pitch": "Refined Pitch: [DEMO MODE] ...",
    "improvement_metrics": {
        "clarity_delta": 3, "persuasion_delta": 2, "overall_delta": 2.5
    },
    "checklist": [
        {"label": "Problem defined", "status": True},
        {"label": "Market size missing", "status": False},
        {"label": "Solution explained", "status": True}
    ],
    "slides": [
        {"title": "The Problem", "content": ["Manual pitch analysis is slow", "Existing tools lack nuance"]}
    ],
    "summaries": {
        "elevator": "A 30-second elevator pitch...",
        "linkedin": "A hooky LinkedIn post...",
        "email": "A professional follow-up email..."
    },
    "confidence_score": 85,
    "filler_words": [{"word": "actually", "count": 2}],
    "suggested_resources": [
        {"title": "Pitch Perfecting Guide", "url": "https://youtube.com/watch?v=demo1", "category": "YouTube"},
        {"title": "The Art of the Startup Pitch", "url": "https://blog.example.com/pitching", "category": "Blog"},
        {"title": "Airbnb Pitch Deck Analysis", "url": "https://example.com/decks/airbnb", "category": "Pitch Deck"}
    ],
    "practice_questions": ["What is your CAC?", "Why now?"],
    "personalized_roadmap": [
        {"title": "Concise Framing Exercise", "description": "Reduce your 'About' section to exactly 15 words to improve clarity."},
        {"title": "Value Prop Deep-Dive", "description": "Draft 3 different versions of your value proposition and test with peers."},
        {"title": "Metric Validation", "description": "Gather real market data to replace generic 'high potential' claims."}
    ]
}
