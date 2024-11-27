    
    import React from "react";

    const AccessPermissionPage = () => {
      const permissionsData = [
        { user: "Faaiz Akhtar", accessLevel: "Admin", status: "Active" },
        { user: "Anirudh Pandit", accessLevel: "Editor", status: "Inactive" },
        { user: "Jitendra Bhaskar", accessLevel: "Viewer", status: "Active" },
        { user: "Pramod Patil", accessLevel: "Admin", status: "Active" },
        { user: "Technocrafts", accessLevel: "Editor", status: "Inactive" },
      ];
    
      return (
        <div className="permissions-page-container p-6">
          <h1 className="text-4xl font-semibold text-center text-blue-600 mb-6"> Access Permissions</h1>
          
          <div className="permissions-table bg-white rounded-lg shadow-md p-4">
            <h2 className="text-2xl font-semibold text-gray-700 mb-4">User Permissions</h2>
            
            <table className="w-full table-auto">
              <thead className="bg-blue-600 text-white">
                <tr>
                  <th className="py-2 px-4 text-left">User</th>
                  <th className="py-2 px-4 text-left">Access Level</th>
                  <th className="py-2 px-4 text-left">Status</th>
                </tr>
              </thead>
              <tbody>
                {permissionsData.map((permission, index) => (
                  <tr key={index} className="border-t">
                    <td className="py-2 px-4">{permission.user}</td>
                    <td className="py-2 px-4">{permission.accessLevel}</td>
                    <td className="py-2 px-4">
                      <span
                        className={`${
                          permission.status === "Active" ? "text-green-600" : "text-red-600"
                        }`}
                      >
                        {permission.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      );
    };
    
    export default AccessPermissionPage;
    