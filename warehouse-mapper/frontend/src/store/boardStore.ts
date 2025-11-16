import { create } from 'zustand';
import { Edge, Connection, addEdge, applyNodeChanges, applyEdgeChanges } from 'reactflow';
import { CustomNode, Board } from '@/types';

interface BoardState {
  nodes: CustomNode[];
  edges: Edge[];
  selectedNode: CustomNode | null;
  boardMetadata: {
    name: string;
    customerId: string;
    boardType: string;
  };
  
  // Node operations
  setNodes: (nodes: CustomNode[]) => void;
  onNodesChange: (changes: any[]) => void;
  addNode: (node: CustomNode) => void;
  updateNode: (nodeId: string, data: Partial<CustomNode['data']>) => void;
  deleteNode: (nodeId: string) => void;
  setSelectedNode: (node: CustomNode | null) => void;
  
  // Edge operations
  setEdges: (edges: Edge[]) => void;
  onEdgesChange: (changes: any[]) => void;
  onConnect: (connection: Connection) => void;
  deleteEdge: (edgeId: string) => void;
  
  // Board operations
  loadBoard: (board: Board) => void;
  clearBoard: () => void;
  setBoardMetadata: (metadata: Partial<BoardState['boardMetadata']>) => void;
  
  // Template operations
  loadTemplate: (nodes: CustomNode[], edges: Edge[]) => void;
  
  // Export
  getBoard: () => Board;
}

export const useBoardStore = create<BoardState>((set, get) => ({
  nodes: [],
  edges: [],
  selectedNode: null,
  boardMetadata: {
    name: 'Untitled Board',
    customerId: '',
    boardType: 'custom',
  },
  
  setNodes: (nodes) => set({ nodes }),
  
  onNodesChange: (changes) => {
    set({
      nodes: applyNodeChanges(changes, get().nodes) as CustomNode[],
    });
  },
  
  addNode: (node) => {
    set((state) => ({
      nodes: [...state.nodes, node],
    }));
  },
  
  updateNode: (nodeId, data) => {
    set((state) => ({
      nodes: state.nodes.map((node) =>
        node.id === nodeId
          ? { ...node, data: { ...node.data, ...data } as CustomNode['data'] }
          : node
      ) as CustomNode[],
    }));
  },
  
  deleteNode: (nodeId) => {
    set((state) => ({
      nodes: state.nodes.filter((node) => node.id !== nodeId),
      edges: state.edges.filter(
        (edge) => edge.source !== nodeId && edge.target !== nodeId
      ),
    }));
  },
  
  setSelectedNode: (node) => set({ selectedNode: node }),
  
  setEdges: (edges) => set({ edges }),
  
  onEdgesChange: (changes) => {
    set({
      edges: applyEdgeChanges(changes, get().edges),
    });
  },
  
  onConnect: (connection) => {
    set((state) => ({
      edges: addEdge(
        {
          ...connection,
          id: `e${connection.source}-${connection.target}`,
          type: 'smoothstep',
          animated: true,
          style: { stroke: '#64748b', strokeWidth: 2 },
        },
        state.edges
      ),
    }));
  },
  
  deleteEdge: (edgeId) => {
    set((state) => ({
      edges: state.edges.filter((edge) => edge.id !== edgeId),
    }));
  },
  
  loadBoard: (board) => {
    set({
      nodes: board.nodes,
      edges: board.edges,
      boardMetadata: {
        name: board.board_name,
        customerId: board.customer_id,
        boardType: board.board_type || 'custom',
      },
    });
  },
  
  clearBoard: () => {
    set({
      nodes: [],
      edges: [],
      selectedNode: null,
    });
  },
  
  setBoardMetadata: (metadata) => {
    set((state) => ({
      boardMetadata: { ...state.boardMetadata, ...metadata },
    }));
  },
  
  loadTemplate: (nodes, edges) => {
    set({
      nodes,
      edges,
      selectedNode: null,
    });
  },
  
  getBoard: () => {
    const state = get();
    return {
      board_name: state.boardMetadata.name,
      customer_id: state.boardMetadata.customerId,
      board_type: state.boardMetadata.boardType,
      nodes: state.nodes,
      edges: state.edges,
    };
  },
}));
