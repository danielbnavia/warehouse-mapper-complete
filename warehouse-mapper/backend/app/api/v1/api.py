from fastapi import APIRouter
from app.api.v1.endpoints import boards, templates, export

api_router = APIRouter()

api_router.include_router(boards.router, tags=["boards"])
api_router.include_router(templates.router, tags=["templates"])
api_router.include_router(export.router, prefix="/export", tags=["export"])
