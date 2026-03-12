import os
import motor.motor_asyncio
from dotenv import load_dotenv
import logging

load_dotenv()

# Get the URI and clean it thoroughly
RAW_URI = os.getenv("MONGO_URI", "").strip()

def hyper_clean_uri(uri: str) -> str:
    if not uri:
        return ""
    
    # Remove common prefix accidents
    if uri.lower().startswith("mongo_uri="):
        uri = uri[len("mongo_uri="):]
    
    # Remove any non-printable or hidden whitespace characters
    uri = "".join(char for char in uri if char.isprintable() and not char.isspace())
    
    # Remove surrounding quotes recursively
    while (uri.startswith('"') and uri.endswith('"')) or \
          (uri.startswith("'") and uri.endswith("'")):
        uri = uri[1:-1].strip()
    
    # Ensure it starts with mongodb
    if not uri.startswith("mongodb"):
        return uri # Let it fail normally if it's completely wrong
        
    # Reconstruct the query string to be absolutely certain it's clean
    if '?' in uri:
        base, query = uri.split('?', 1)
        # Split by & and keep only parts that have a valid key=value structure
        # Drop everything else. Force trim each part.
        parts = []
        for p in query.split('&'):
            clean_part = p.strip()
            if '=' in clean_part:
                parts.append(clean_part)
        
        if parts:
            uri = f"{base.strip()}?{'&'.join(parts)}"
        else:
            uri = base.strip()
            
    return uri.rstrip('/')

MONGO_URI = hyper_clean_uri(RAW_URI)

# Diagnostic Logging (Safely Masked)
if MONGO_URI:
    # Check for hidden characters in the first 30 chars
    chars_debug = [f"{ord(c)}" for c in RAW_URI[:10]]
    logging.info(f"URI Diagnostic - Prefix Char Codes: {', '.join(chars_debug)}")
    
    masked = f"{MONGO_URI[:15]}...{MONGO_URI[-5:]}" if len(MONGO_URI) > 20 else "***"
    logging.info(f"Connecting to MongoDB. Cleaned URI: {masked}")
    
    # Warn about Python 3.14 in logs
    import sys
    if sys.version_info.major == 3 and sys.version_info.minor >= 14:
        logging.warning("CRITICAL: Python 3.14 detected. This experimental version often breaks MongoDB/Pymongo. PLEASE DOWNGRADE TO 3.11 IN RENDER SETTINGS.")

if not MONGO_URI:
    raise ValueError("MONGO_URI not found in environment variables")

client = motor.motor_asyncio.AsyncIOMotorClient(MONGO_URI)
db = client.vakyaai_db
# Collection names
analyses_collection = db.get_collection("analyses")
users_collection = db.get_collection("users")

async def check_database_connection():
    try:
        # Send a ping to confirm a successful connection
        await client.admin.command('ping')
        logging.info("Pinged your deployment. You successfully connected to MongoDB!")
    except Exception as e:
        logging.error(f"MongoDB Not Connected: {e}")
        raise e
