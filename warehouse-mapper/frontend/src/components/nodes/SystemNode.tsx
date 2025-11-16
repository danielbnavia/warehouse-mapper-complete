import { memo } from 'react';
import { Handle, Position, NodeProps } from 'reactflow';
import { SystemNodeData } from '@/types';

const SystemNode = ({ data, selected }: NodeProps<SystemNodeData>) => {
  return (
    <div
      className={`px-4 py-3 rounded-lg bg-gray-50 border-2 border-gray-400 min-w-[140px] transition-all ${
        selected ? 'shadow-lg border-gray-600' : 'shadow-sm'
      }`}
    >
      <Handle 
        type="target" 
        position={Position.Top} 
        className="w-2 h-2 !bg-gray-600"
      />
      
      <div className="flex items-center gap-2">
        <span className="text-xl">{data.icon}</span>
        <div>
          <div className="font-semibold text-sm text-gray-900">
            {data.label}
          </div>
          {data.version && (
            <div className="text-[10px] text-gray-500">
              v{data.version}
            </div>
          )}
        </div>
      </div>
      
      <Handle 
        type="source" 
        position={Position.Bottom} 
        className="w-2 h-2 !bg-gray-600"
      />
    </div>
  );
};

export default memo(SystemNode);
