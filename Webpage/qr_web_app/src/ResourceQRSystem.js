import React, { useState } from "react";
import PropTypes from "prop-types";
import QRCode from "qrcode.react";
import { Download, Share2, QrCode } from "lucide-react";

const ResourceQRSystem = ({ parentFolder }) => {
  const [shareableLink, setShareableLink] = useState("");
  const [showQRModal, setShowQRModal] = useState(false);
  const [qrData, setQrData] = useState("");

  const generateUniqueToken = () => {
    const randomString = Math.random().toString(36).slice(2);
    return `${Date.now()}-${randomString}`;
  };

  const generateShareableContent = () => {
    const token = generateUniqueToken();
    const folderData = {
      folderId: parentFolder.id,
      name: parentFolder.name,
      token: token,
      contents: parentFolder.subFolders.map(folder => ({
        id: folder.id,
        name: folder.name,
        type: folder.type || 'folder',
        lastModified: new Date().toISOString()
      }))
    };
  
    const shareableData = {
      token: token,
      data: folderData
    };
  
    const encodedData = btoa(JSON.stringify(shareableData));
    
    // Use your local IP address here
    const shareLink = `http://192.168.2.173:3000/shared/${encodedData}`;
    
    setShareableLink(shareLink);
    setQrData(shareLink);
  };

  const handleGenerateQR = () => {
    generateShareableContent();
    setShowQRModal(true);
  };

  const handleDownloadQR = () => {
    const canvas = document.getElementById("qr-code");
    if (canvas) {
      const pngUrl = canvas
        .toDataURL("image/png")
        .replace("image/png", "image/octet-stream");
      const downloadLink = document.createElement("a");
      downloadLink.href = pngUrl;
      downloadLink.download = `${parentFolder.name}-QR.png`;
      document.body.appendChild(downloadLink);
      downloadLink.click();
      document.body.removeChild(downloadLink);
    }
  };

  const handleCopyLink = () => {
    navigator.clipboard.writeText(shareableLink);
  };

  return (
    <div>
      <button
        onClick={handleGenerateQR}
        className="flex items-center gap-2 px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg text-white transition-colors"
      >
        <QrCode className="w-5 h-5" />
        <span>Generate QR</span>
      </button>

      {showQRModal && (
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
                <QRCode
                  id="qr-code"
                  value={qrData}
                  size={256}
                  level="H"
                  includeMargin={true}
                  className="w-full h-full"
                />
              </div>
            </div>

            <div className="space-y-4">
              <div className="bg-gray-900/50 p-3 rounded-lg">
                <p className="text-sm text-gray-400 mb-1">Shareable Link</p>
                <div className="flex items-center gap-2">
                  <input
                    type="text"
                    value={shareableLink}
                    readOnly
                    className="bg-transparent text-gray-200 text-sm flex-1 outline-none"
                  />
                  <button
                    onClick={handleCopyLink}
                    className="text-gray-400 hover:text-white"
                  >
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
                <button
                  onClick={handleDownloadQR}
                  className="flex-1 px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors flex items-center justify-center gap-2"
                >
                  <Download className="w-5 h-5" />
                  Download QR
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

ResourceQRSystem.propTypes = {
  parentFolder: PropTypes.shape({
    id: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    subFolders: PropTypes.arrayOf(
      PropTypes.shape({
        id: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired,
        type: PropTypes.string,
      })
    ).isRequired,
  }).isRequired,
};

export default ResourceQRSystem;
