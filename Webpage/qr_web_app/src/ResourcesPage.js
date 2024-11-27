import React, { useState } from "react";
import { QRCodeSVG } from "qrcode.react"; // Import the QRCodeSVG component
import resourcesData from "./resourcesData"; // Ensure correct import of data

const ResourcesPage = () => {
  const [selectedFolder, setSelectedFolder] = useState(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [filterType, setFilterType] = useState("");
  const [showQR, setShowQR] = useState(null); // State to manage QR visibility

  // Handles the folder click
  const handleFolderClick = (folderName) => {
    setSelectedFolder(folderName);
  };

  // Toggles QR code visibility
  const handleQRToggle = (itemTitle) => {
    // If QR code is already visible for this item, hide it. Otherwise, show it.
    setShowQR((prev) => (prev === itemTitle ? null : itemTitle));
  };

  // Handles the search input change
  const handleSearchChange = (e) => {
    setSearchQuery(e.target.value);
  };

  // Handles the filter type change
  const handleFilterChange = (e) => {
    setFilterType(e.target.value);
  };

  // Filter the resources based on search and filter type
  const filteredData = resourcesData
    .map((folder) => ({
      ...folder,
      subfolders: folder.subfolders.map((subfolder) => ({
        ...subfolder,
        items: subfolder.items.filter(
          (item) =>
            item.title.toLowerCase().includes(searchQuery.toLowerCase()) &&
            (filterType ? item.type === filterType : true)
        ),
      })),
    }))
    .filter(
      (folder) => !selectedFolder || folder.folderName === selectedFolder
    );

  return (
    <div className="resources-page-container flex h-screen">
      {/* Sidebar */}
      <div className="sidebar w-1/4 bg-blue-800 text-white p-4 space-y-4">
        <h2 className="text-2xl font-bold mb-4">Resources</h2>
        <div className="folders">
          {resourcesData.map((folder) => (
            <div key={folder.folderName}>
              <button
                onClick={() => handleFolderClick(folder.folderName)}
                className="folder-name text-lg font-semibold text-left w-full py-2 px-4 hover:bg-blue-700 rounded"
              >
                {folder.folderName}
              </button>
              {selectedFolder === folder.folderName &&
                folder.subfolders.map((subfolder) => (
                  <div key={subfolder.name} className="subfolder pl-4">
                    <button className="text-sm py-2 w-full text-left hover:bg-blue-600">
                      {subfolder.name}
                    </button>
                  </div>
                ))}
            </div>
          ))}
        </div>
      </div>

      {/* Main Content */}
      <div className="main-content flex-1 p-6 bg-gray-100">
        <h1 className="text-4xl font-semibold text-center text-blue-600 mb-8">
          {selectedFolder || "All Resources"}
        </h1>

        {/* Search and Filter */}
        <div className="search-filter mb-4 flex justify-between items-center">
          <div className="search-bar flex items-center border p-2 rounded-lg">
            <input
              type="text"
              placeholder="Search documents..."
              value={searchQuery}
              onChange={handleSearchChange}
              className="outline-none"
            />
          </div>
          <div className="filter">
            <select
              value={filterType}
              onChange={handleFilterChange}
              className="border p-2 rounded-lg"
            >
              <option value="">All Types</option>
              <option value="pdf">PDF</option>
              <option value="image">Image</option>
            </select>
          </div>
        </div>

        {/* Documents List */}
        <div className="document-list grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {filteredData.map((folder) =>
            folder.subfolders.map(
              (subfolder) =>
                subfolder.items.length > 0 && (
                  <div key={subfolder.name} className="folder-docs">
                    <h3 className="text-2xl font-bold text-blue-500 mb-4">
                      {subfolder.name}
                    </h3>
                    <ul className="list-none">
                      {subfolder.items.map((item) => (
                        <li
                          key={item.title}
                          className="flex justify-between items-center p-4 bg-white rounded-lg shadow-md mb-2 hover:bg-gray-50"
                        >
                          <span className="text-lg text-gray-700">
                            {item.title}
                          </span>
                          <div className="action-buttons flex space-x-4">
                            <button className="text-blue-600 hover:text-blue-800">
                              Download
                            </button>

                            {/* View QR Code Button */}
                            <button
                              onClick={() => handleQRToggle(item.title)}
                              className="text-green-600 hover:text-green-800"
                            >
                              {showQR === item.title
                                ? "Hide QR Code"
                                : "View QR Code"}
                            </button>
                          </div>

                          {/* Display QR Code only if item.link exists */}
                          {showQR === item.title ? (
                            <div className="mt-2">
                              {item.link ? (
                                <>
                                  <QRCodeSVG value={item.link} size={128} />
                                  <p>QR Code for {item.title}</p>
                                </>
                              ) : (
                                <p>No link available for this item.</p>
                              )}
                            </div>
                          ) : null}
                        </li>
                      ))}
                    </ul>
                  </div>
                )
            )
          )}
        </div>
      </div>
    </div>
  );
};

export default ResourcesPage;
