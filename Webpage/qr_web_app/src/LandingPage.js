import React from "react";
import { Shield, FileText, Users, ChevronRight } from "lucide-react";
import { Link } from "react-router-dom";
import Navbar from "./Navbar";

const LandingPage = () => {
  const features = [
    {
      icon: FileText,
      title: "Document Management",
      description:
        "Securely store and manage all your important documents in one centralized location.",
    },
    {
      icon: Shield,
      title: "Access Control",
      description:
        "Manage user permissions and ensure data security with our robust access control system.",
    },
    {
      icon: Users,
      title: "Team Collaboration",
      description:
        "Enable seamless collaboration among team members with real-time document sharing.",
    },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900">
      <Navbar />

      <main className="pt-16">
        {/* Hero Section */}
        <div className="relative overflow-hidden">
          <div className="max-w-7xl mx-auto pt-16 pb-12 px-4 sm:px-6 lg:px-8">
            <div className="relative z-10">
              <div className="text-center">
                <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold text-white mb-6">
                  Welcome to <span className="text-red-500">Technocrafts</span>
                </h1>
                <p className="max-w-2xl mx-auto text-xl text-gray-400 mb-10">
                  Your complete solution for document management and team
                  collaboration. Access, manage, and secure your resources with
                  ease.
                </p>
                <div className="flex justify-center gap-4">
                  <Link
                    to="/dashboard"
                    className="inline-flex items-center px-6 py-3 rounded-lg bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white font-medium transition-all duration-300 shadow-lg shadow-red-600/20"
                  >
                    Get Started
                    <ChevronRight className="ml-2 h-5 w-5" />
                  </Link>
                  <Link
                    to="/resources"
                    className="inline-flex items-center px-6 py-3 rounded-lg bg-gray-800 hover:bg-gray-700 text-gray-200 font-medium transition-all duration-300"
                  >
                    View Resources
                  </Link>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Features Section */}
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {features.map((feature, index) => {
              const IconComponent = feature.icon;
              return (
                <div
                  key={index}
                  className="bg-gray-800/50 backdrop-blur-sm border border-gray-700 rounded-xl p-6 hover:border-red-500/50 transition-all duration-300"
                >
                  <div className="w-12 h-12 bg-red-500/10 rounded-lg flex items-center justify-center mb-4">
                    <IconComponent className="h-6 w-6 text-red-500" />
                  </div>
                  <h3 className="text-xl font-semibold text-white mb-3">
                    {feature.title}
                  </h3>
                  <p className="text-gray-400">{feature.description}</p>
                </div>
              );
            })}
          </div>
        </div>

        {/* Call to Action Section */}
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
          <div className="bg-gradient-to-r from-gray-800 to-gray-900 border border-gray-700 rounded-xl p-8 md:p-12 text-center">
            <h2 className="text-3xl font-bold text-white mb-4">
              Ready to Get Started?
            </h2>
            <p className="text-gray-400 mb-8 max-w-2xl mx-auto">
              Join us today and experience the power of seamless document
              management and team collaboration.
            </p>
            <Link
              to="/dashboard"
              className="inline-flex items-center px-6 py-3 rounded-lg bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white font-medium transition-all duration-300 shadow-lg shadow-red-600/20"
            >
              Access Dashboard
              <ChevronRight className="ml-2 h-5 w-5" />
            </Link>
          </div>
        </div>
      </main>
    </div>
  );
};

export default LandingPage;
