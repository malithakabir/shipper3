from fastapi import FastAPI
import logging

app = FastAPI()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.get("/")
def read_root():
    logger.info("Root endpoint was called")
    return {"message": "Hello, World!"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: str = None):
    logger.info(f"Item endpoint was called with item_id: {item_id} and query: {q}")
    return {"item_id": item_id, "q": q}