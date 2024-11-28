import React, { useState } from "react";
import {
  ChevronDown,
  ChevronUp,
  FileText,
  BookOpen,
  Wrench,
  Users,
  Settings,
  Folder,
  QrCode,
  Share2,
  Download,
} from "lucide-react";

const ResourcesPage = () => {
  const [expandedFolders, setExpandedFolders] = useState({});
  const [showQRModal, setShowQRModal] = useState(false);
  const [selectedFolder, setSelectedFolder] = useState(null);

  const toggleFolder = (folderId) => {
    setExpandedFolders((prev) => ({
      ...prev,
      [folderId]: !prev[folderId],
    }));
  };

  const getFolderIcon = (id) => {
    switch (id) {
      case "as-built-drawings":
        return <FileText className="w-6 h-6 text-red-500" />;
      case "test-reports":
        return <BookOpen className="w-6 h-6 text-red-500" />;
      case "product-catalogues":
        return <Wrench className="w-6 h-6 text-red-500" />;
      case "escalation-matrix":
        return <Users className="w-6 h-6 text-red-500" />;
      case "om-manual":
        return <Settings className="w-6 h-6 text-red-500" />;
      default:
        return <Folder className="w-6 h-6 text-red-500" />;
    }
  };

  const parentFolders = [
    {
      id: "technocrafts",
      name: "Technocrafts Switchgear Pvt Ltd",
      subFolders: [
        { id: "as-built-drawings", name: "As Built Drawings" },
        { id: "test-reports", name: "Test Reports" },
        { id: "product-catalogues", name: "Product Catalogues" },
        { id: "escalation-matrix", name: "Escalation Matrix" },
        { id: "om-manual", name: "O&M Manual" },
        { id: "other-documents", name: "Other Documents" },
      ],
    },
    {
      id: "abb",
      name: "ABB",
      subFolders: [
        { id: "technical-specs", name: "Technical Specifications" },
        { id: "installation-guides", name: "Installation Guides" },
        { id: "maintenance-docs", name: "Maintenance Documentation" },
        { id: "warranty-info", name: "Warranty Information" },
        { id: "compliance-certs", name: "Compliance Certificates" },
        { id: "support-docs", name: "Support Documentation" },
      ],
    },
  ];

  const generateShareableLink = (folderId) => {
    return `${window.location.origin}/shared-folder/${folderId}`;
  };

  const handleQRGenerate = (folder) => {
    setSelectedFolder(folder);
    setShowQRModal(true);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 pt-24">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-red-500 mb-4">Resources</h1>
          <p className="text-gray-400">
            Access all your important documents and materials
          </p>
        </div>

        <div className="space-y-6">
          {parentFolders.map((parentFolder) => (
            <div
              key={parentFolder.id}
              className="bg-gray-800/50 backdrop-blur-sm rounded-xl border border-gray-700 overflow-hidden"
            >
              <div className="flex items-center justify-between p-6 bg-gradient-to-r from-red-600 to-red-700">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-lg bg-white/10 flex items-center justify-center">
                    <Folder className="w-6 h-6 text-white" />
                  </div>
                  <span className="text-xl font-semibold text-white">
                    {parentFolder.name}
                  </span>
                </div>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => handleQRGenerate(parentFolder)}
                    className="flex items-center gap-2 px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg text-white transition-colors"
                  >
                    <QrCode className="w-5 h-5" />
                    <span>Generate QR</span>
                  </button>
                  <button
                    onClick={() => toggleFolder(parentFolder.id)}
                    className="p-2 hover:bg-white/10 rounded-lg transition-colors"
                  >
                    {expandedFolders[parentFolder.id] ? (
                      <ChevronUp className="w-6 h-6 text-white" />
                    ) : (
                      <ChevronDown className="w-6 h-6 text-white" />
                    )}
                  </button>
                </div>
              </div>

              {expandedFolders[parentFolder.id] && (
                <div className="p-6">
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    {parentFolder.subFolders.map((folder) => (
                      <div
                        key={folder.id}
                        className="group bg-gray-700/30 hover:bg-gray-700/50 border border-gray-600 hover:border-red-500/50 rounded-xl p-6 cursor-pointer transition-all duration-300 shadow-lg hover:shadow-xl"
                      >
                        <div className="flex items-center gap-4">
                          <div className="w-12 h-12 rounded-lg bg-gray-800/80 group-hover:bg-gray-800 flex items-center justify-center transition-all duration-300">
                            {getFolderIcon(folder.id)}
                          </div>
                          <div>
                            <h3 className="text-gray-200 font-medium group-hover:text-white transition-colors">
                              {folder.name}
                            </h3>
                            <p className="text-sm text-gray-400 group-hover:text-gray-300">
                              Click to view contents
                            </p>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>

        {/* QR Code Modal */}
        {showQRModal && selectedFolder && (
          <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50">
            <div className="bg-gray-800 rounded-xl p-6 max-w-md w-full mx-4">
              <div className="flex justify-between items-center mb-4">
                <h3 className="text-xl font-semibold text-white">
                  Share Folder Access
                </h3>
                <button
                  onClick={() => setShowQRModal(false)}
                  className="text-gray-400 hover:text-white"
                >
                  <svg
                    className="w-6 h-6"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M6 18L18 6M6 6l12 12"
                    />
                  </svg>
                </button>
              </div>

              <div className="bg-white p-4 rounded-lg mb-4">
                <div className="w-full aspect-square bg-gray-100 rounded-lg flex items-center justify-center">
                  <QrCode className="w-32 h-32 text-gray-800" />
                </div>
              </div>

              <div className="space-y-4">
                <div className="bg-gray-900/50 p-3 rounded-lg">
                  <p className="text-sm text-gray-400 mb-1">Shareable Link</p>
                  <div className="flex items-center gap-2">
                    <input
                      type="text"
                      value={generateShareableLink(selectedFolder.id)}
                      readOnly
                      className="bg-transparent text-gray-200 text-sm flex-1 outline-none"
                    />
                    <button className="text-gray-400 hover:text-white">
                      <Share2 className="w-5 h-5" />
                    </button>
                  </div>
                </div>

                <div className="flex gap-2">
                  <button
                    onClick={() => setShowQRModal(false)}
                    className="flex-1 px-4 py-2 bg-gray-700 hover:bg-gray-600 text-white rounded-lg transition-colors"
                  >
                    Close
                  </button>
                  <button className="flex-1 px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors flex items-center justify-center gap-2">
                    <Download className="w-5 h-5" />
                    Download QR
                  </button>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default ResourcesPage;
