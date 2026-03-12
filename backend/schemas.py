from pydantic import BaseModel, Field, EmailStr
from typing import List, Optional, Dict
from datetime import datetime

# --- User Schemas ---
class UserBase(BaseModel):
    email: EmailStr
    full_name: str = Field(..., min_length=2, max_length=100)
    job_role: Optional[str] = Field(None, description="e.g., Founder, Student, Developer")

class UserCreate(UserBase):
    password: str = Field(..., min_length=8, max_length=71)

class UserLogin(BaseModel):
    email: EmailStr
    password: str = Field(..., max_length=71)

class UserOut(UserBase):
    id: str
    created_at: datetime

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None

# --- Pitch Schemas ---
class PitchRequest(BaseModel):
    pitch_text: str = Field(..., min_length=10, max_length=15000, description="The text of the pitch to analyze.")
    target_audience: Optional[str] = Field("General Investor", description="e.g., Investor, Technical Jury, Professor")

class ImprovementMetrics(BaseModel):
    clarity_delta: int
    persuasion_delta: int
    overall_delta: float

class ChecklistItem(BaseModel):
    label: str
    status: bool

class Slide(BaseModel):
    title: str
    content: List[str]

class Summaries(BaseModel):
    elevator: str
    linkedin: str
    email: str

class Resource(BaseModel):
    title: str
    url: str
    category: str = "General" # YouTube, Blog, Documentation, Pitch Deck

class RoadmapStep(BaseModel):
    title: str
    description: str
    status: str = "pending" # pending, in_progress, completed

class FillerWord(BaseModel):
    word: str
    count: int

class AnalysisResult(BaseModel):
    scores: Dict[str, int]
    overall_score: float
    strengths: List[str]
    weaknesses: List[str]
    suggestions: List[str]
    improved_pitch: str
    # Advanced Evolution Fields
    improvement_metrics: Optional[ImprovementMetrics] = None
    checklist: List[ChecklistItem] = []
    slides: List[Slide] = []
    summaries: Optional[Summaries] = None
    confidence_score: int = 0
    filler_words: List[FillerWord] = []
    suggested_resources: List[Resource] = []
    practice_questions: List[str] = []
    personalized_roadmap: List[RoadmapStep] = []

class AnalysisResponse(BaseModel):
    id: str
    original_pitch: str
    analysis: AnalysisResult
    created_at: datetime
    
    class Config:
        from_attributes = True

class ErrorResponse(BaseModel):
    detail: str
