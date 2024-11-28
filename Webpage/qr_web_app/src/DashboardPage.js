import React from "react";
import {
  Users,
  FileText,
  Activity,
  Clock,
  ChevronRight,
  Lock,
  FileBarChart,
} from "lucide-react";

const DashboardPage = () => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 p-8">
      <div className="max-w-7xl mx-auto">
        {/* Dashboard Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-red-500 mb-4">Dashboard</h1>
          <p className="text-gray-400">
            Welcome to the QR Application Dashboard
          </p>
        </div>

        {/* Stats Overview */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-gray-800/50 backdrop-blur-sm border border-gray-700 rounded-xl p-6 shadow-lg">
            <div className="flex items-center justify-between mb-4">
              <div className="w-12 h-12 bg-red-500/10 rounded-lg flex items-center justify-center">
                <Users className="w-6 h-6 text-red-500" />
              </div>
              <span className="text-3xl font-bold text-gray-200">5</span>
            </div>
            <h3 className="text-gray-400 text-sm">Total Users</h3>
            <div className="mt-2 flex items-center text-green-500 text-sm">
              <span>+12% from last month</span>
            </div>
          </div>

          <div className="bg-gray-800/50 backdrop-blur-sm border border-gray-700 rounded-xl p-6 shadow-lg">
            <div className="flex items-center justify-between mb-4">
              <div className="w-12 h-12 bg-red-500/10 rounded-lg flex items-center justify-center">
                <FileText className="w-6 h-6 text-red-500" />
              </div>
              <span className="text-3xl font-bold text-gray-200">50</span>
            </div>
            <h3 className="text-gray-400 text-sm">Total Resources</h3>
            <div className="mt-2 flex items-center text-green-500 text-sm">
              <span>+5 new this week</span>
            </div>
          </div>

          <div className="bg-gray-800/50 backdrop-blur-sm border border-gray-700 rounded-xl p-6 shadow-lg">
            <div className="flex items-center justify-between mb-4">
              <div className="w-12 h-12 bg-red-500/10 rounded-lg flex items-center justify-center">
                <Activity className="w-6 h-6 text-red-500" />
              </div>
              <span className="text-3xl font-bold text-gray-200">3</span>
            </div>
            <h3 className="text-gray-400 text-sm">Active Sessions</h3>
            <div className="mt-2 flex items-center text-red-500 text-sm">
              <span>-2 from peak today</span>
            </div>
          </div>
        </div>

        {/* Main Content Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Recent Activity */}
          <div className="bg-gray-800/50 backdrop-blur-sm border border-gray-700 rounded-xl p-6 shadow-lg">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-semibold text-white flex items-center gap-2">
                <Clock className="w-5 h-5 text-red-500" />
                Recent Activity
              </h2>
            </div>
            <div className="space-y-4">
              {[
                {
                  user: "Faaiz Akhtar",
                  action: "uploaded a new document",
                  time: "2 hours ago",
                },
                {
                  user: "Anirudh Pandit",
                  action: "updated the project details",
                  time: "4 hours ago",
                },
                {
                  user: "Jitendra Bhaskar",
                  action: "granted access permissions",
                  time: "6 hours ago",
                },
              ].map((activity, index) => (
                <div
                  key={index}
                  className="flex items-center gap-4 p-3 rounded-lg bg-gray-700/30 border border-gray-600"
                >
                  <div className="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center flex-shrink-0">
                    <span className="text-red-500 font-medium">
                      {activity.user[0]}
                    </span>
                  </div>
                  <div className="flex-1">
                    <p className="text-gray-200">
                      <span className="font-medium">{activity.user}</span>{" "}
                      {activity.action}
                    </p>
                    <span className="text-sm text-gray-400">
                      {activity.time}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Quick Links */}
          <div className="bg-gray-800/50 backdrop-blur-sm border border-gray-700 rounded-xl p-6 shadow-lg">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-semibold text-white">Quick Links</h2>
            </div>
            <div className="space-y-4">
              {[
                { icon: FileText, name: "View Resources", path: "/resources" },
                {
                  icon: Lock,
                  name: "Manage Permissions",
                  path: "/accesspermission",
                },
                { icon: FileBarChart, name: "View Reports", path: "/reports" },
              ].map((link, index) => {
                const IconComponent = link.icon;
                return (
                  <a
                    key={index}
                    href={link.path}
                    className="flex items-center justify-between p-4 rounded-lg bg-gray-700/30 border border-gray-600 hover:bg-gray-700/50 hover:border-red-500/50 transition-all duration-300 group"
                  >
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-lg bg-gray-800 flex items-center justify-center">
                        <IconComponent className="w-5 h-5 text-red-500" />
                      </div>
                      <span className="text-gray-200 group-hover:text-white">
                        {link.name}
                      </span>
                    </div>
                    <ChevronRight className="w-5 h-5 text-gray-400 group-hover:text-red-500 transition-colors" />
                  </a>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DashboardPage;
