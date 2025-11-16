import { ComponentItem } from '@/types';
import { OPERATION_COMPONENTS, MESSAGE_COMPONENTS, SYSTEM_COMPONENTS } from '@/lib/constants';

const Sidebar = () => {
  const onDragStart = (event: React.DragEvent, component: ComponentItem) => {
    console.log('🎯 Drag started:', component.label);
    event.dataTransfer.setData('application/reactflow', JSON.stringify(component));
    event.dataTransfer.effectAllowed = 'move';
  };

  const renderComponentSection = (title: string, components: ComponentItem[]) => (
    <div className="mb-6">
      <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2.5 px-1">
        {title}
      </h3>
      <div className="space-y-1">
        {components.map((component) => (
          <div
            key={component.id}
            draggable
            onDragStart={(e) => onDragStart(e, component)}
            className="flex items-center gap-2.5 p-2.5 bg-white border border-gray-200 rounded cursor-move hover:border-blue-400 hover:bg-blue-50 transition-all group"
          >
            <span className="text-lg">
              {component.icon}
            </span>
            <span className="text-sm font-medium text-gray-800">
              {component.label}
            </span>
          </div>
        ))}
      </div>
    </div>
  );

  return (
    <aside className="w-64 bg-white border-r border-gray-200 overflow-y-auto p-4">
      <div className="mb-5">
        <h1 className="text-lg font-bold text-gray-900">Component Library</h1>
        <p className="text-xs text-gray-500 mt-0.5">
          Drag components onto the canvas
        </p>
      </div>
      
      {renderComponentSection('Physical Operations', OPERATION_COMPONENTS)}
      {renderComponentSection('Data Messages', MESSAGE_COMPONENTS)}
      {renderComponentSection('Systems', SYSTEM_COMPONENTS)}
    </aside>
  );
};

export default Sidebar;
