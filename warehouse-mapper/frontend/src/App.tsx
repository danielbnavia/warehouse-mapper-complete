import Sidebar from './components/Sidebar';
import Canvas from './components/Canvas';
import Toolbar from './components/Toolbar';

function App() {
  return (
    <div className="flex flex-col h-screen w-screen overflow-hidden bg-gray-50">
      <Toolbar />
      <div className="flex flex-1 overflow-hidden" style={{ minHeight: 0, position: 'relative' }}>
        <Sidebar />
        <div style={{ position: 'absolute', top: 0, left: '256px', right: 0, bottom: 0 }}>
          <Canvas />
        </div>
      </div>
    </div>
  );
}

export default App;
