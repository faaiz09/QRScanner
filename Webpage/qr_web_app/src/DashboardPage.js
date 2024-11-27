import React from "react";

const DashboardPage = () => {
  return (
    <div className="dashboard-container p-6">
      {/* Dashboard Header */}
      <div className="dashboard-header mb-8">
        <h1 className="text-4xl font-semibold text-blue-600 text-center">Dashboard</h1>
        <p className="text-center text-gray-600 mt-2">Welcome to the QR Application Dashboard!</p>
      </div>

      {/* Dashboard Content */}
      <div className="dashboard-content grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        {/* Quick Stats */}
        <div className="stats-card p-4 bg-white rounded-lg shadow-md">
          <h2 className="text-2xl font-semibold text-gray-700">Quick Stats</h2>
          <ul className="mt-4">
            <li className="text-gray-600">Total Users: 120</li>
            <li className="text-gray-600">Total Resources: 50</li>
            <li className="text-gray-600">Active Sessions: 12</li>
          </ul>
        </div>

        {/* Recent Activity */}
        <div className="recent-activity p-4 bg-white rounded-lg shadow-md">
          <h2 className="text-2xl font-semibold text-gray-700">Recent Activity</h2>
          <ul className="mt-4">
            <li className="text-gray-600">Faaiz Akhtar uploaded a new document.</li>
            <li className="text-gray-600">Anirudh Pandit updated the project details.</li>
            <li className="text-gray-600">Jitendra Bhaskar granted access permissions to a new user.</li>
          </ul>
        </div>

        {/* Links to Other Pages */}
        <div className="quick-links p-4 bg-white rounded-lg shadow-md">
          <h2 className="text-2xl font-semibold text-gray-700">Quick Links</h2>
          <ul className="mt-4">
            <li><a href="/resources" className="text-blue-600">View Resources</a></li>
            <li><a href="/permissions" className="text-blue-600">Manage Permissions</a></li>
            <li><a href="/reports" className="text-blue-600">View Reports</a></li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default DashboardPage;
