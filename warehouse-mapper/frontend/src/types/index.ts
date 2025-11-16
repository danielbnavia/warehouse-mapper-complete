import { Node, Edge } from 'reactflow';

export type NodeCategory = 
  | 'receiving' 
  | 'putaway' 
  | 'storage' 
  | 'picking' 
  | 'packing' 
  | 'dispatch'
  | 'qc'
  | 'returns';

export type MessageType = 
  | 'ASN' 
  | 'PickOrder' 
  | 'PackConfirm' 
  | 'Manifest' 
  | 'InventoryUpdate' 
  | 'Exception';

export type Frequency = 'realtime' | 'batch' | 'scheduled' | 'event-driven';

export interface OperationNodeData {
  label: string;
  category: NodeCategory;
  icon: string;
  properties?: {
    capacity?: string;
    hours?: string;
    notes?: string;
    [key: string]: string | undefined;
  };
}

export interface MessageNodeData {
  label: string;
  messageType: MessageType;
  frequency: Frequency;
  sourceSystem?: string;
  targetSystem?: string;
  icon: string;
  properties?: {
    format?: string;
    volume?: string;
    [key: string]: string | undefined;
  };
}

export interface SystemNodeData {
  label: string;
  systemType: string;
  icon: string;
  version?: string;
  properties?: {
    [key: string]: string;
  };
}

export type CustomNodeData = OperationNodeData | MessageNodeData | SystemNodeData;

export interface CustomNode extends Node {
  data: CustomNodeData;
}

export interface Board {
  id?: string;
  customer_id: string;
  board_name: string;
  board_type?: string;
  nodes: CustomNode[];
  edges: Edge[];
  metadata?: {
    description?: string;
    tags?: string[];
    [key: string]: any;
  };
  created_at?: string;
  updated_at?: string;
  created_by?: string;
  is_template?: boolean;
  version?: number;
}

export interface Template {
  id: string;
  template_name: string;
  description?: string;
  category: string;
  nodes: CustomNode[];
  edges: Edge[];
  thumbnail_url?: string;
  created_at?: string;
  is_active?: boolean;
}

export interface ComponentItem {
  id: string;
  label: string;
  icon: string;
  type: 'operation' | 'message' | 'system';
  category?: NodeCategory;
  messageType?: MessageType;
  frequency?: Frequency;
  systemType?: string;
}
