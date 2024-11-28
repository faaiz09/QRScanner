import React from "react";
import { Users, Shield } from "lucide-react";

const AccessPermissionPage = () => {
  const permissionsData = [
    { user: "Faaiz Akhtar", accessLevel: "Admin", status: "Active" },
    { user: "Anirudh Pandit", accessLevel: "Editor", status: "Inactive" },
    { user: "Jitendra Bhaskar", accessLevel: "Viewer", status: "Active" },
    { user: "Pramod Patil", accessLevel: "Admin", status: "Active" },
    { user: "Technocrafts", accessLevel: "Editor", status: "Inactive" },
  ];

  const getAccessLevelBadgeStyles = (level) => {
    switch (level) {
      case "Admin":
        return "bg-red-100 text-red-800 border-red-200";
      case "Editor":
        return "bg-gray-100 text-gray-800 border-gray-200";
      default:
        return "bg-white/10 text-gray-200 border-gray-600";
    }
  };

  const getStatusBadgeStyles = (status) => {
    return status === "Active"
      ? "bg-green-100 text-green-800 border-green-200"
      : "bg-red-100 text-red-800 border-red-200";
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900">
      {/* Add padding-top to account for navbar height */}
      <div className="max-w-7xl mx-auto p-8 pt-24">
        <div className="flex flex-col gap-8">
          <div>
            <h1 className="text-3xl font-bold text-red-500 mb-2">
              Access Permissions
            </h1>
            <p className="text-gray-400">Manage user access and roles</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl p-6 border border-gray-700">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-lg bg-red-500/10 flex items-center justify-center">
                  <Users className="h-6 w-6 text-red-500" />
                </div>
                <div>
                  <p className="text-gray-400">Total Users</p>
                  <p className="text-2xl font-bold text-white">5</p>
                </div>
              </div>
            </div>

            <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl p-6 border border-gray-700">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-lg bg-red-500/10 flex items-center justify-center">
                  <Shield className="h-6 w-6 text-red-500" />
                </div>
                <div>
                  <p className="text-gray-400">Access Levels</p>
                  <p className="text-2xl font-bold text-white">3</p>
                </div>
              </div>
            </div>
          </div>

          <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl border border-gray-700">
            <div className="p-6">
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-semibold text-white">
                  User Permissions
                </h2>
                <button className="bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white px-4 py-2 rounded-lg font-medium transition-colors">
                  Add New User
                </button>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b border-gray-700">
                      <th className="text-left py-4 px-6 text-gray-400 font-medium">
                        User
                      </th>
                      <th className="text-left py-4 px-6 text-gray-400 font-medium">
                        Access Level
                      </th>
                      <th className="text-left py-4 px-6 text-gray-400 font-medium">
                        Status
                      </th>
                      <th className="text-right py-4 px-6 text-gray-400 font-medium">
                        Actions
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {permissionsData.map((permission, index) => (
                      <tr
                        key={index}
                        className="border-b border-gray-700/50 hover:bg-gray-700/30 transition-colors"
                      >
                        <td className="py-4 px-6">
                          <div className="flex items-center gap-3">
                            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-red-500 to-red-700 flex items-center justify-center">
                              <span className="text-white font-medium">
                                {permission.user.charAt(0)}
                              </span>
                            </div>
                            <span className="font-medium text-gray-200">
                              {permission.user}
                            </span>
                          </div>
                        </td>
                        <td className="py-4 px-6">
                          <span
                            className={`px-3 py-1 rounded-lg text-sm border ${getAccessLevelBadgeStyles(
                              permission.accessLevel
                            )}`}
                          >
                            {permission.accessLevel}
                          </span>
                        </td>
                        <td className="py-4 px-6">
                          <span
                            className={`px-3 py-1 rounded-lg text-sm border ${getStatusBadgeStyles(
                              permission.status
                            )}`}
                          >
                            {permission.status}
                          </span>
                        </td>
                        <td className="py-4 px-6">
                          <div className="flex items-center justify-end gap-2">
                            <button className="text-gray-400 hover:text-red-500 p-2 rounded-lg hover:bg-gray-700/50 transition-colors">
                              <svg
                                className="w-5 h-5"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                              >
                                <path
                                  strokeLinecap="round"
                                  strokeLinejoin="round"
                                  strokeWidth="2"
                                  d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
                                />
                              </svg>
                            </button>
                            <button className="text-gray-400 hover:text-red-500 p-2 rounded-lg hover:bg-gray-700/50 transition-colors">
                              <svg
                                className="w-5 h-5"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                              >
                                <path
                                  strokeLinecap="round"
                                  strokeLinejoin="round"
                                  strokeWidth="2"
                                  d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                                />
                              </svg>
                            </button>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AccessPermissionPage;
