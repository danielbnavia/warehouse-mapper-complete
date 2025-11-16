import { memo } from 'react';
import { Handle, Position, NodeProps } from 'reactflow';
import { OperationNodeData } from '@/types';

const OperationNode = ({ data, selected }: NodeProps<OperationNodeData>) => {
  return (
    <div
      className={`px-4 py-3 rounded-lg bg-blue-50 border-2 min-w-[180px] transition-all ${
        selected ? 'border-blue-500 shadow-lg' : 'border-blue-300 shadow-md'
      }`}
    >
      <Handle 
        type="target" 
        position={Position.Top} 
        className="w-3 h-3 !bg-blue-500"
      />
      
      <div className="space-y-1">
        <div className="text-[10px] text-gray-500 uppercase tracking-wide font-semibold">
          {data.category}
        </div>
        <div className="flex items-center gap-2">
          <span className="text-xl">{data.icon}</span>
          <div className="font-semibold text-sm text-gray-900">
            {data.label}
          </div>
        </div>
        
        {data.properties?.capacity && (
          <div className="text-xs text-gray-600 mt-1">
            📊 {data.properties.capacity}
          </div>
        )}
      </div>
      
      <Handle 
        type="source" 
        position={Position.Bottom} 
        className="w-3 h-3 !bg-blue-500"
      />
    </div>
  );
};

export default memo(OperationNode);
