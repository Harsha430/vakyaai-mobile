from fastapi import APIRouter, HTTPException, Path, Depends
from fastapi.security import OAuth2PasswordBearer
from schemas import (
    PitchRequest, AnalysisResponse, AnalysisResult, 
    UserCreate, UserLogin, UserOut, Token
)
from database import analyses_collection, users_collection
from ai_service import analyze_pitch_with_gemini
from auth import get_password_hash, verify_password, create_access_token, decode_token
from bson import ObjectId
from datetime import datetime
import logging

router = APIRouter()
logger = logging.getLogger(__name__)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="api/auth/login")

async def get_current_user(token: str = Depends(oauth2_scheme)):
    payload = decode_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    email = payload.get("sub")
    user = await users_collection.find_one({"email": email})
    if not user:
        raise HTTPException(status_code=401, detail="User not found")
    user["id"] = str(user["_id"])
    return user

# --- Auth Routes ---
@router.post("/auth/register", response_model=UserOut, status_code=201)
async def register(user_data: UserCreate):
    existing_user = await users_collection.find_one({"email": user_data.email})
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    hashed_password = get_password_hash(user_data.password)
    user_dict = user_data.dict()
    user_dict["password"] = hashed_password
    user_dict["created_at"] = datetime.utcnow()
    
    result = await users_collection.insert_one(user_dict)
    user_dict["id"] = str(result.inserted_id)
    return user_dict

@router.post("/auth/login", response_model=Token)
async def login(user_data: UserLogin):
    logger.info(f"Login attempt for: {user_data.email}")
    try:
        user = await users_collection.find_one({"email": user_data.email})
        if not user:
            logger.warning(f"Login failed: User {user_data.email} not found")
            raise HTTPException(status_code=401, detail="Invalid email or password")
            
        if not verify_password(user_data.password, user["password"]):
            logger.warning(f"Login failed: Incorrect password for {user_data.email}")
            raise HTTPException(status_code=401, detail="Invalid email or password")
        
        logger.info(f"User {user_data.email} authenticated successfully. Creating token...")
        access_token = create_access_token(data={"sub": user["email"]})
        return {"access_token": access_token, "token_type": "bearer"}
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Login process failed: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Login error: {str(e)}")

@router.get("/user/me", response_model=UserOut)
async def get_me(current_user: dict = Depends(get_current_user)):
    return current_user

# --- Pitch Routes ---
@router.post("/analyze", response_model=AnalysisResponse, status_code=201)
async def analyze_pitch(request: PitchRequest, current_user: dict = Depends(get_current_user)):
    """
    Analyzes a pitch and attributes it to the logged-in user.
    """
    logger.info(f"User {current_user['email']} requested pitch analysis.")
    
    try:
        analysis_data = await analyze_pitch_with_gemini(request.pitch_text, request.target_audience)
    except Exception as e:
        logger.error(f"AI Service Failed: {e}")
        raise HTTPException(status_code=500, detail=str(e))

    document = {
        "user_id": current_user["id"],
        "original_pitch": request.pitch_text,
        "analysis": analysis_data,
        "created_at": datetime.utcnow()
    }
    
    result = await analyses_collection.insert_one(document)
    document["id"] = str(result.inserted_id)
    return document

@router.get("/my-analyses", response_model=list[AnalysisResponse])
async def get_user_analyses(current_user: dict = Depends(get_current_user)):
    """
    Retrieves all analyses for the current logged-in user.
    """
    cursor = analyses_collection.find({"user_id": current_user["id"]}).sort("created_at", -1)
    analyses = []
    async for doc in cursor:
        doc["id"] = str(doc["_id"])
        analyses.append(doc)
    return analyses

@router.get("/analysis/{id}", response_model=AnalysisResponse)
async def get_analysis(id: str = Path(..., title="The ID of the analysis to retrieve")):
    """
    Retrieves a stored analysis by its ID.
    """
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid analysis ID format.")
    
    try:
        document = await analyses_collection.find_one({"_id": ObjectId(id)})
    except Exception as e:
        logger.error(f"Database Query Failed: {e}")
        raise HTTPException(status_code=500, detail="Database error.")
        
    if not document:
        raise HTTPException(status_code=404, detail="Analysis not found.")
    
    document["id"] = str(document["_id"])
    return document
