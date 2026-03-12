import os
from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from database import check_database_connection
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    logger.info("Starting up VākyaAI Backend...")
    try:
        await check_database_connection()
    except Exception as e:
        logger.critical(f"Failed to connect to database: {e}")
    yield
    # Shutdown
    logger.info("Shutting down VākyaAI Backend...")

app = FastAPI(title="VākyaAI API", version="1.0.0", lifespan=lifespan)

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    logger.error(f"Validation Error: {exc.errors()}")
    return JSONResponse(
        status_code=422,
        content={"detail": exc.errors()},
    )

# CORS Middleware - Permissive for deployment to avoid blocks
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Global Error: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal Server Error", "message": str(exc)},
        headers={
            "Access-Control-Allow-Origin": "*", # Force CORS header on errors
        }
    )

@app.get("/")
async def root():
    return {
        "message": "VākyaAI Backend is Running", 
        "status": "active",
        "api_v1": "/api"
    }

from routes import router as api_router
app.include_router(api_router, prefix="/api")
