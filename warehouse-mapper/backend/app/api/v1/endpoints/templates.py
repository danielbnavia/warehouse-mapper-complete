from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from uuid import UUID

from app.db.session import get_db
from app.models.board import Template as TemplateModel
from app.schemas.board import TemplateCreate, TemplateInDB

router = APIRouter()

@router.get("/templates", response_model=List[TemplateInDB])
def get_templates(
    category: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get all templates, optionally filtered by category"""
    query = db.query(TemplateModel).filter(TemplateModel.is_active == True)
    
    if category:
        query = query.filter(TemplateModel.category == category)
    
    templates = query.all()
    return templates

@router.get("/templates/{template_id}", response_model=TemplateInDB)
def get_template(template_id: UUID, db: Session = Depends(get_db)):
    """Get a specific template by ID"""
    template = db.query(TemplateModel).filter(
        TemplateModel.id == template_id,
        TemplateModel.is_active == True
    ).first()
    
    if not template:
        raise HTTPException(status_code=404, detail="Template not found")
    
    return template

@router.post("/templates", response_model=TemplateInDB, status_code=201)
def create_template(template: TemplateCreate, db: Session = Depends(get_db)):
    """Create a new template"""
    db_template = TemplateModel(
        template_name=template.template_name,
        description=template.description,
        category=template.category,
        nodes=[node.model_dump() for node in template.nodes],
        edges=[edge.model_dump() for edge in template.edges],
        thumbnail_url=template.thumbnail_url,
    )
    db.add(db_template)
    db.commit()
    db.refresh(db_template)
    return db_template
