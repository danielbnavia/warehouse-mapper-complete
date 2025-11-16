import { useCallback, useRef, DragEvent, useEffect, useState } from 'react';
import ReactFlow, {
  Background,
  Controls,
  MiniMap,
  ReactFlowProvider,
  BackgroundVariant,
  useReactFlow,
} from 'reactflow';
import 'reactflow/dist/style.css';

import { useBoardStore } from '@/store/boardStore';
import { ComponentItem, CustomNode, NodeCategory } from '@/types';
import OperationNode from './nodes/OperationNode';
import MessageNode from './nodes/MessageNode';
import SystemNode from './nodes/SystemNode';
import WelcomePrompt from './WelcomePrompt';

const nodeTypes = {
  operation: OperationNode,
  message: MessageNode,
  system: SystemNode,
};

const CanvasInner = () => {
  const reactFlowWrapper = useRef<HTMLDivElement>(null);
  const {
    nodes,
    edges,
    onNodesChange,
    onEdgesChange,
    onConnect,
    addNode,
  } = useBoardStore();

  const { screenToFlowPosition } = useReactFlow();

  const onDragOver = useCallback((event: DragEvent) => {
    event.preventDefault();
    event.stopPropagation();
    event.dataTransfer.dropEffect = 'move';
  }, []);

  const onDrop = useCallback(
    (event: DragEvent) => {
      event.preventDefault();
      event.stopPropagation();

      const data = event.dataTransfer.getData('application/reactflow');
      if (!data) {
        console.log('No drag data found');
        return;
      }

      console.log('✅ Drop event received, data:', data);
      const component: ComponentItem = JSON.parse(data);
      console.log('✅ Parsed component:', component);

      if (!reactFlowWrapper.current) {
        console.error('❌ ReactFlow wrapper not found');
        return;
      }

      const bounds = reactFlowWrapper.current.getBoundingClientRect();
      console.log('📦 Bounds:', bounds);
      console.log('🖱️ Click position:', { x: event.clientX, y: event.clientY });

      const position = screenToFlowPosition({
        x: event.clientX - bounds.left,
        y: event.clientY - bounds.top,
      });
      console.log('📍 Calculated position:', position);

      let nodeData: CustomNode['data'];

      if (component.type === 'operation' && component.category) {
        nodeData = {
          label: component.label,
          icon: component.icon,
          category: component.category,
        };
      } else if (component.type === 'message' && component.messageType && component.frequency) {
        nodeData = {
          label: component.label,
          icon: component.icon,
          messageType: component.messageType,
          frequency: component.frequency,
        };
      } else if (component.type === 'system' && component.systemType) {
        nodeData = {
          label: component.label,
          icon: component.icon,
          systemType: component.systemType,
        };
      } else {
        // Fallback to operation type
        nodeData = {
          label: component.label,
          icon: component.icon,
          category: 'storage' as NodeCategory,
        };
      }

      const newNode: CustomNode = {
        id: `${component.type}-${Date.now()}`,
        type: component.type,
        position,
        data: nodeData,
      };

      console.log('➕ Adding node:', newNode);
      addNode(newNode);
    },
    [addNode, screenToFlowPosition]
  );

  return (
    <div
      ref={reactFlowWrapper}
      className="w-full h-full relative"
      style={{
        width: '100%',
        height: '100%'
      }}
    >
      {nodes.length === 0 && <WelcomePrompt />}
      <ReactFlow
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        onConnect={onConnect}
        onDrop={onDrop}
        onDragOver={onDragOver}
        nodeTypes={nodeTypes}
        fitView
        snapToGrid
        snapGrid={[15, 15]}
        nodesDraggable={true}
        nodesConnectable={true}
        defaultEdgeOptions={{
          type: 'smoothstep',
          animated: true,
          style: { stroke: '#64748b', strokeWidth: 2 },
        }}
      >
        <Background
          variant={BackgroundVariant.Lines}
          gap={20}
          color="#cbd5e1"
        />
        <Controls className="!bg-white !border !border-gray-200" />
        <MiniMap
          className="!bg-white !border !border-gray-200"
          nodeColor={(node) => {
            switch (node.type) {
              case 'operation':
                return '#dbeafe';
              case 'message':
                return '#fef3c7';
              case 'system':
                return '#f1f5f9';
              default:
                return '#e5e7eb';
            }
          }}
        />
      </ReactFlow>
    </div>
  );
};

const Canvas = () => {
  return (
    <div style={{ width: '100%', height: '100%' }}>
      <ReactFlowProvider>
        <CanvasInner />
      </ReactFlowProvider>
    </div>
  );
};

export default Canvas;
