import React from "react";
import { useRouteError } from "react-router-dom";
import { AlertTriangle } from "lucide-react";

const ErrorBoundary = () => {
  const error = useRouteError();

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 flex items-center justify-center p-4">
      <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl border border-gray-700 p-8 max-w-lg w-full text-center">
        <div className="flex justify-center mb-6">
          <div className="w-16 h-16 bg-red-500/10 rounded-full flex items-center justify-center">
            <AlertTriangle className="w-8 h-8 text-red-500" />
          </div>
        </div>

        <h1 className="text-2xl font-bold text-white mb-2">
          {error.status === 404 ? "Page Not Found" : "Unexpected Error"}
        </h1>

        <p className="text-gray-400 mb-6">
          {error.status === 404
            ? "The page you're looking for doesn't exist or has been moved."
            : "We encountered an unexpected error. Please try again later."}
        </p>

        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <button
            onClick={() => window.history.back()}
            className="px-6 py-2 bg-gray-700 hover:bg-gray-600 text-white rounded-lg transition-colors"
          >
            Go Back
          </button>

          <a
            href="/"
            className="px-6 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors"
          >
            Return Home
          </a>
        </div>
      </div>
    </div>
  );
};

export default ErrorBoundary;
