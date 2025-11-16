import axios from 'axios';
import { Board, Template } from '@/types';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8001/api';

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add auth token interceptor if using authentication
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('auth_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const boardsApi = {
  // Get all boards for a customer
  getBoards: async (customerId: string): Promise<Board[]> => {
    const response = await apiClient.get(`/boards?customer_id=${customerId}`);
    return response.data;
  },
  
  // Get single board by ID
  getBoard: async (boardId: string): Promise<Board> => {
    const response = await apiClient.get(`/boards/${boardId}`);
    return response.data;
  },
  
  // Create new board
  createBoard: async (board: Board): Promise<Board> => {
    const response = await apiClient.post('/boards', board);
    return response.data;
  },
  
  // Update existing board
  updateBoard: async (boardId: string, board: Partial<Board>): Promise<Board> => {
    const response = await apiClient.put(`/boards/${boardId}`, board);
    return response.data;
  },
  
  // Delete board
  deleteBoard: async (boardId: string): Promise<void> => {
    await apiClient.delete(`/boards/${boardId}`);
  },
  
  // Validate board connections
  validateBoard: async (board: Board): Promise<{ valid: boolean; errors: string[] }> => {
    const response = await apiClient.post('/boards/validate', board);
    return response.data;
  },
};

export const templatesApi = {
  // Get all templates
  getTemplates: async (): Promise<Template[]> => {
    const response = await apiClient.get('/templates');
    return response.data;
  },
  
  // Get single template
  getTemplate: async (templateId: string): Promise<Template> => {
    const response = await apiClient.get(`/templates/${templateId}`);
    return response.data;
  },
  
  // Get templates by category
  getTemplatesByCategory: async (category: string): Promise<Template[]> => {
    const response = await apiClient.get(`/templates?category=${category}`);
    return response.data;
  },
};

export const exportApi = {
  // Export board to PDF
  exportPDF: async (boardId: string): Promise<Blob> => {
    const response = await apiClient.get(`/export/pdf/${boardId}`, {
      responseType: 'blob',
    });
    return response.data;
  },
  
  // Export board to JSON
  exportJSON: async (boardId: string): Promise<any> => {
    const response = await apiClient.get(`/export/json/${boardId}`);
    return response.data;
  },
  
  // Export integration specification
  exportIntegrationSpec: async (boardId: string): Promise<Blob> => {
    const response = await apiClient.get(`/export/integration-spec/${boardId}`, {
      responseType: 'blob',
    });
    return response.data;
  },
};

export default apiClient;
