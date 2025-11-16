const WelcomePrompt = () => {
  return (
    <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', pointerEvents: 'none', zIndex: 10 }}>
      <div className="bg-white rounded-xl shadow-lg p-8 text-center border border-gray-200" style={{ width: '400px', pointerEvents: 'auto' }}>
        <div className="text-4xl mb-4">👋</div>
        <h3 className="text-xl font-bold text-gray-900 mb-2">Start Building</h3>
        <p className="text-sm text-gray-600 mb-6">
          Drag components from the sidebar onto this canvas
        </p>
        <button className="px-6 py-2.5 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 transition-colors">
          Or Load E-commerce Template
        </button>
      </div>
    </div>
  );
};

export default WelcomePrompt;
