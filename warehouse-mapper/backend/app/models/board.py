from sqlalchemy import Column, String, Boolean, Integer, DateTime, Text, JSON
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
import uuid
from app.db.base_class import Base

class Board(Base):
    __tablename__ = "boards"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    customer_id = Column(String(255), nullable=False, index=True)
    board_name = Column(String(255), nullable=False)
    board_type = Column(String(50), index=True)
    nodes = Column(JSON, nullable=False)
    edges = Column(JSON, nullable=False)
    board_metadata = Column(JSON)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    created_by = Column(String(255))
    is_template = Column(Boolean, default=False)
    version = Column(Integer, default=1)


class Template(Base):
    __tablename__ = "templates"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    template_name = Column(String(255), nullable=False)
    description = Column(Text)
    category = Column(String(100), index=True)
    nodes = Column(JSON, nullable=False)
    edges = Column(JSON, nullable=False)
    thumbnail_url = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    is_active = Column(Boolean, default=True)


class Export(Base):
    __tablename__ = "exports"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    board_id = Column(UUID(as_uuid=True))
    export_type = Column(String(50))
    file_url = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
