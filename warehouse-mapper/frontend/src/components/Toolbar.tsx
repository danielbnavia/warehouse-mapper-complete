import { useState } from 'react';
import { Save, Download, FileJson, Trash2, FolderOpen } from 'lucide-react';
import { useBoardStore } from '@/store/boardStore';
import { boardsApi } from '@/services/api';

const Toolbar = () => {
  const { nodes, edges, clearBoard, boardMetadata, getBoard } = useBoardStore();
  const [saving, setSaving] = useState(false);

  const handleSave = async () => {
    try {
      setSaving(true);
      const board = getBoard();
      
      // TODO: Replace with actual customer ID from auth
      board.customer_id = 'demo-customer';
      
      const savedBoard = await boardsApi.createBoard(board);
      alert(`Board saved successfully! ID: ${savedBoard.id}`);
    } catch (error) {
      console.error('Failed to save board:', error);
      alert('Failed to save board. Please try again.');
    } finally {
      setSaving(false);
    }
  };

  const handleExportJSON = () => {
    const board = getBoard();
    const dataStr = JSON.stringify(board, null, 2);
    const dataBlob = new Blob([dataStr], { type: 'application/json' });
    const url = URL.createObjectURL(dataBlob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `${boardMetadata.name.replace(/\s+/g, '-')}.json`;
    link.click();
    URL.revokeObjectURL(url);
  };

  const handleClear = () => {
    if (nodes.length > 0) {
      if (confirm('Are you sure you want to clear the board?')) {
        clearBoard();
      }
    }
  };

  return (
    <div className="h-14 bg-white border-b border-gray-200 flex items-center justify-between px-6 flex-shrink-0">
      <h2 className="text-lg font-semibold text-gray-800">
        {boardMetadata.name}
      </h2>

      <div className="flex items-center gap-2">
        <button
          onClick={handleClear}
          disabled={nodes.length === 0}
          className="px-4 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          Clear Board
        </button>

        <button
          className="px-4 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded hover:bg-gray-50 transition-colors"
        >
          Load Template
        </button>

        <button
          disabled={nodes.length === 0}
          className="px-4 py-1.5 text-sm font-medium text-white bg-blue-600 rounded hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          Export PDF
        </button>
      </div>
    </div>
  );
};

export default Toolbar;
