import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { FileText, Folder, Download, ExternalLink, Clock } from "lucide-react";

const SharedContentViewer = () => {
  const { token } = useParams();
  const [folderData, setFolderData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    try {
      const decodedData = JSON.parse(atob(token));
      // In a real application, you would verify the token with your backend
      setFolderData(decodedData.data);
      setLoading(false);
    } catch (err) {
      setError("Invalid or expired link");
      setLoading(false);
    }
  }, [token]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 flex items-center justify-center">
        <div className="text-white">Loading shared content...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 flex items-center justify-center">
        <div className="text-red-500 text-center">
          <h2 className="text-2xl font-bold mb-2">Error</h2>
          <p>{error}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 p-8">
      <div className="max-w-4xl mx-auto">
        <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl border border-gray-700 overflow-hidden">
          <div className="p-6 bg-gradient-to-r from-red-600 to-red-700">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-white/10 flex items-center justify-center">
                <Folder className="w-6 h-6 text-white" />
              </div>
              <div>
                <h1 className="text-xl font-semibold text-white">
                  {folderData.name}
                </h1>
                <p className="text-sm text-gray-200">Shared Content</p>
              </div>
            </div>
          </div>

          <div className="p-6">
            <div className="space-y-4">
              {folderData.contents.map((item) => (
                <div
                  key={item.id}
                  className="bg-gray-700/30 hover:bg-gray-700/50 border border-gray-600 rounded-lg p-4 transition-all"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
                        <FileText className="w-5 h-5 text-red-500" />
                      </div>
                      <div>
                        <h3 className="text-white font-medium">{item.name}</h3>
                        <div className="flex items-center gap-2 text-sm text-gray-400">
                          <Clock className="w-4 h-4" />
                          <span>
                            {new Date(item.lastModified).toLocaleDateString()}
                          </span>
                        </div>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <button className="p-2 text-gray-400 hover:text-white rounded-lg hover:bg-gray-600 transition-colors">
                        <Download className="w-5 h-5" />
                      </button>
                      <button className="p-2 text-gray-400 hover:text-white rounded-lg hover:bg-gray-600 transition-colors">
                        <ExternalLink className="w-5 h-5" />
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SharedContentViewer;
