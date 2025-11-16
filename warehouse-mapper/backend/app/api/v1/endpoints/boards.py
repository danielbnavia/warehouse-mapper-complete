from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List
from uuid import UUID

from app.db.session import get_db
from app.models.board import Board as BoardModel
from app.schemas.board import BoardCreate, BoardUpdate, BoardInDB, ValidationResponse

router = APIRouter()

@router.get("/boards", response_model=List[BoardInDB])
def get_boards(
    customer_id: str = Query(..., description="Customer ID to filter boards"),
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """Get all boards for a customer"""
    boards = db.query(BoardModel).filter(
        BoardModel.customer_id == customer_id
    ).offset(skip).limit(limit).all()
    return boards

@router.get("/boards/{board_id}", response_model=BoardInDB)
def get_board(board_id: UUID, db: Session = Depends(get_db)):
    """Get a specific board by ID"""
    board = db.query(BoardModel).filter(BoardModel.id == board_id).first()
    if not board:
        raise HTTPException(status_code=404, detail="Board not found")
    return board

@router.post("/boards", response_model=BoardInDB, status_code=201)
def create_board(board: BoardCreate, db: Session = Depends(get_db)):
    """Create a new board"""
    db_board = BoardModel(
        customer_id=board.customer_id,
        board_name=board.board_name,
        board_type=board.board_type,
        nodes=[node.model_dump() for node in board.nodes],
        edges=[edge.model_dump() for edge in board.edges],
        board_metadata=board.metadata,
        created_by=board.created_by,
    )
    db.add(db_board)
    db.commit()
    db.refresh(db_board)
    return db_board

@router.put("/boards/{board_id}", response_model=BoardInDB)
def update_board(
    board_id: UUID,
    board: BoardUpdate,
    db: Session = Depends(get_db)
):
    """Update an existing board"""
    db_board = db.query(BoardModel).filter(BoardModel.id == board_id).first()
    if not db_board:
        raise HTTPException(status_code=404, detail="Board not found")
    
    update_data = board.model_dump(exclude_unset=True)
    
    # Convert node/edge objects to dicts if provided
    if 'nodes' in update_data and update_data['nodes']:
        update_data['nodes'] = [node.model_dump() for node in board.nodes]
    if 'edges' in update_data and update_data['edges']:
        update_data['edges'] = [edge.model_dump() for edge in board.edges]
    
    for field, value in update_data.items():
        setattr(db_board, field, value)
    
    db_board.version += 1
    db.commit()
    db.refresh(db_board)
    return db_board

@router.delete("/boards/{board_id}", status_code=204)
def delete_board(board_id: UUID, db: Session = Depends(get_db)):
    """Delete a board"""
    db_board = db.query(BoardModel).filter(BoardModel.id == board_id).first()
    if not db_board:
        raise HTTPException(status_code=404, detail="Board not found")
    
    db.delete(db_board)
    db.commit()
    return None

@router.post("/boards/validate", response_model=ValidationResponse)
def validate_board(board: BoardCreate):
    """Validate board connections and data flow"""
    errors = []
    warnings = []
    
    # Build a map of node IDs
    node_ids = {node.id for node in board.nodes}
    
    # Check that all edges reference valid nodes
    for edge in board.edges:
        if edge.source not in node_ids:
            errors.append(f"Edge {edge.id} references non-existent source node: {edge.source}")
        if edge.target not in node_ids:
            errors.append(f"Edge {edge.id} references non-existent target node: {edge.target}")
    
    # Check for disconnected nodes (optional warning)
    connected_nodes = set()
    for edge in board.edges:
        connected_nodes.add(edge.source)
        connected_nodes.add(edge.target)
    
    disconnected = node_ids - connected_nodes
    if disconnected:
        warnings.append(f"{len(disconnected)} nodes are not connected to any others")
    
    # Check for message nodes without system connections
    for node in board.nodes:
        if node.type == "message":
            # Find if this message has system connections
            has_system_connection = False
            for edge in board.edges:
                if edge.source == node.id or edge.target == node.id:
                    # Check if connected to a system node
                    for other_node in board.nodes:
                        if other_node.id in [edge.source, edge.target] and other_node.type == "system":
                            has_system_connection = True
                            break
            
            if not has_system_connection:
                warnings.append(
                    f"Message node '{node.data.label}' is not connected to any system"
                )
    
    return ValidationResponse(
        valid=len(errors) == 0,
        errors=errors,
        warnings=warnings
    )
