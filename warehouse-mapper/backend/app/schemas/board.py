from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from datetime import datetime
from uuid import UUID

# Node schemas
class NodeData(BaseModel):
    label: str
    icon: str
    category: Optional[str] = None
    messageType: Optional[str] = None
    frequency: Optional[str] = None
    systemType: Optional[str] = None
    sourceSystem: Optional[str] = None
    targetSystem: Optional[str] = None
    properties: Optional[Dict[str, Any]] = None

class NodePosition(BaseModel):
    x: float
    y: float

class Node(BaseModel):
    id: str
    type: str
    position: NodePosition
    data: NodeData

# Edge schemas
class Edge(BaseModel):
    id: str
    source: str
    target: str
    type: Optional[str] = "smoothstep"
    animated: Optional[bool] = True
    style: Optional[Dict[str, Any]] = None
    label: Optional[str] = None

# Board schemas
class BoardBase(BaseModel):
    board_name: str
    customer_id: str
    board_type: Optional[str] = None
    nodes: List[Node] = []
    edges: List[Edge] = []
    metadata: Optional[Dict[str, Any]] = None

class BoardCreate(BoardBase):
    created_by: Optional[str] = None

class BoardUpdate(BaseModel):
    board_name: Optional[str] = None
    board_type: Optional[str] = None
    nodes: Optional[List[Node]] = None
    edges: Optional[List[Edge]] = None
    metadata: Optional[Dict[str, Any]] = None

class BoardInDB(BoardBase):
    id: UUID
    created_at: datetime
    updated_at: Optional[datetime] = None
    is_template: bool = False
    version: int = 1
    metadata: Optional[Dict[str, Any]] = Field(None, alias='board_metadata')

    class Config:
        from_attributes = True
        populate_by_name = True

# Template schemas
class TemplateBase(BaseModel):
    template_name: str
    description: Optional[str] = None
    category: str
    nodes: List[Node]
    edges: List[Edge]
    thumbnail_url: Optional[str] = None

class TemplateCreate(TemplateBase):
    pass

class TemplateInDB(TemplateBase):
    id: UUID
    created_at: datetime
    is_active: bool = True

    class Config:
        from_attributes = True

# Validation response
class ValidationResponse(BaseModel):
    valid: bool
    errors: List[str] = []
    warnings: List[str] = []
