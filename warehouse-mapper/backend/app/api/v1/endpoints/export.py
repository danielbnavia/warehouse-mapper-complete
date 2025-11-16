from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import JSONResponse, FileResponse
from sqlalchemy.orm import Session
from uuid import UUID
import json
from datetime import datetime

from app.db.session import get_db
from app.models.board import Board as BoardModel

router = APIRouter()

@router.get("/export/json/{board_id}")
def export_json(board_id: UUID, db: Session = Depends(get_db)):
    """Export board as JSON"""
    board = db.query(BoardModel).filter(BoardModel.id == board_id).first()
    if not board:
        raise HTTPException(status_code=404, detail="Board not found")
    
    export_data = {
        "id": str(board.id),
        "board_name": board.board_name,
        "customer_id": board.customer_id,
        "board_type": board.board_type,
        "nodes": board.nodes,
        "edges": board.edges,
        "metadata": board.metadata,
        "created_at": board.created_at.isoformat() if board.created_at else None,
        "version": board.version,
        "exported_at": datetime.utcnow().isoformat()
    }
    
    return JSONResponse(content=export_data)

@router.get("/export/integration-spec/{board_id}")
def export_integration_spec(board_id: UUID, db: Session = Depends(get_db)):
    """Export integration specification"""
    board = db.query(BoardModel).filter(BoardModel.id == board_id).first()
    if not board:
        raise HTTPException(status_code=404, detail="Board not found")
    
    # Analyze board to generate integration spec
    integrations = []
    systems = [n for n in board.nodes if n.get('type') == 'system']
    messages = [n for n in board.nodes if n.get('type') == 'message']
    
    # Build integration map from edges
    for edge in board.edges:
        source_node = next((n for n in board.nodes if n['id'] == edge['source']), None)
        target_node = next((n for n in board.nodes if n['id'] == edge['target']), None)
        
        if source_node and target_node:
            integration = {
                "integration_id": f"int_{edge['id']}",
                "source": source_node['data']['label'],
                "target": target_node['data']['label'],
                "source_type": source_node['type'],
                "target_type": target_node['type'],
                "message_type": source_node['data'].get('messageType') or target_node['data'].get('messageType'),
                "frequency": source_node['data'].get('frequency') or target_node['data'].get('frequency'),
                "notes": f"Connect {source_node['data']['label']} to {target_node['data']['label']}"
            }
            integrations.append(integration)
    
    spec = {
        "board_id": str(board.id),
        "board_name": board.board_name,
        "generated_at": datetime.utcnow().isoformat(),
        "summary": {
            "total_systems": len(systems),
            "total_integrations": len(integrations),
            "message_types": list(set(m['data'].get('messageType') for m in messages if m['data'].get('messageType')))
        },
        "systems": [
            {
                "name": s['data']['label'],
                "type": s['data'].get('systemType'),
                "id": s['id']
            } for s in systems
        ],
        "integrations": integrations
    }
    
    return JSONResponse(content=spec)

@router.get("/export/pdf/{board_id}")
def export_pdf(board_id: UUID, db: Session = Depends(get_db)):
    """Export board as PDF (placeholder - requires additional implementation)"""
    # This would require a library like ReportLab or WeasyPrint
    # For now, return a placeholder response
    raise HTTPException(
        status_code=501,
        detail="PDF export not yet implemented. Use frontend PDF generation with jsPDF."
    )
