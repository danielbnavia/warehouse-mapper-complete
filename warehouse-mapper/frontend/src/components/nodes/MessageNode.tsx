import { memo } from 'react';
import { Handle, Position, NodeProps } from 'reactflow';
import { Clock } from 'lucide-react';
import { MessageNodeData } from '@/types';
import { MESSAGE_TYPE_COLORS } from '@/lib/constants';

const MessageNode = ({ data, selected }: NodeProps<MessageNodeData>) => {
  const colorClass = MESSAGE_TYPE_COLORS[data.messageType] || 'bg-gray-50 border-gray-400';
  
  return (
    <div
      className={`px-3 py-2 rounded-md border-2 min-w-[160px] transition-all ${colorClass} ${
        selected ? 'shadow-lg scale-105' : 'shadow-sm'
      }`}
    >
      <Handle 
        type="target" 
        position={Position.Left} 
        className="w-2 h-2"
      />
      
      <div className="space-y-1">
        <div className="flex items-center gap-2">
          <span className="text-lg">{data.icon}</span>
          <div className="font-semibold text-xs">
            {data.label}
          </div>
        </div>
        
        <div className="flex items-center gap-1 text-[10px]">
          <Clock className="w-3 h-3" />
          <span>{data.frequency}</span>
        </div>
        
        {(data.sourceSystem || data.targetSystem) && (
          <div className="text-[10px] pt-1 border-t border-current/20">
            {data.sourceSystem && <div>From: {data.sourceSystem}</div>}
            {data.targetSystem && <div>To: {data.targetSystem}</div>}
          </div>
        )}
      </div>
      
      <Handle 
        type="source" 
        position={Position.Right} 
        className="w-2 h-2"
      />
    </div>
  );
};

export default memo(MessageNode);
