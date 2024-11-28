import React, { useState } from "react";
import { NavLink, useLocation, useNavigate, Link } from "react-router-dom";
import {
  Search,
  Bell,
  ChevronDown,
  LogOut,
  Settings,
  HelpCircle,
  Menu,
  X,
  User,
} from "lucide-react";

import logo from '../src/assets/Companylogo.png'

const Navbar = () => {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isSearchOpen, setIsSearchOpen] = useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const location = useLocation();
  const navigate = useNavigate();

  const handleSignout = (e) => {
    e.preventDefault();
    const willSignout = window.confirm("Are you sure you want to sign out?");
    if (willSignout) {
      navigate("/");
    }
  };

  const mainNavLinks = [
    { title: "Dashboard", href: "/dashboard" },
    { title: "Resources", href: "/resources" },
    { title: "Access Permissions", href: "/accesspermission" },
  ];

  return (
    <nav className="fixed top-0 w-full z-50 bg-gray-900/95 backdrop-blur-sm border-b border-gray-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <div className="flex-shrink-0 flex items-center">
            <Link to="/landing">
              <img
                src={logo}
                alt="Company Logo"
                className="h-8 w-auto"
              />
            </Link>
          </div>

          {/* Desktop Navigation */}
          <div className="hidden lg:flex items-center space-x-1">
            {mainNavLinks.map((link) => (
              <NavLink
                key={link.title}
                to={link.href}
                className={({ isActive }) =>
                  `px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200 ${
                    isActive
                      ? "text-red-500 bg-red-500/10"
                      : "text-gray-400 hover:text-white hover:bg-gray-800"
                  }`
                }
              >
                {link.title}
              </NavLink>
            ))}
          </div>

          {/* Right Side Icons */}
          <div className="hidden lg:flex items-center space-x-2">
            {/* Search */}
            <button
              className="p-2 text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors"
              onClick={() => setIsSearchOpen(!isSearchOpen)}
            >
              <Search className="h-5 w-5" />
            </button>

            {/* Notifications */}
            <button className="p-2 text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors">
              <Bell className="h-5 w-5" />
            </button>

            {/* User Menu */}
            <div className="relative">
              <button
                className="flex items-center space-x-1 p-2 text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors"
                onClick={() => setIsDropdownOpen(!isDropdownOpen)}
              >
                <User className="h-5 w-5" />
                <ChevronDown className="h-4 w-4" />
              </button>

              {isDropdownOpen && (
                <div className="absolute right-0 mt-2 w-48 bg-gray-900 border border-gray-800 rounded-xl shadow-xl">
                  <ul className="py-1">
                    <li className="px-4 py-2 text-gray-400 hover:bg-gray-800 hover:text-white cursor-pointer flex items-center space-x-2 transition-colors">
                      <Settings className="h-4 w-4" />
                      <span>Settings</span>
                    </li>
                    <li className="px-4 py-2 text-gray-400 hover:bg-gray-800 hover:text-white cursor-pointer flex items-center space-x-2 transition-colors">
                      <HelpCircle className="h-4 w-4" />
                      <span>Help & Support</span>
                    </li>
                    <li
                      className="px-4 py-2 text-red-500 hover:bg-red-500/10 cursor-pointer flex items-center space-x-2 transition-colors"
                      onClick={handleSignout}
                    >
                      <LogOut className="h-4 w-4" />
                      <span>Sign out</span>
                    </li>
                  </ul>
                </div>
              )}
            </div>
          </div>

          {/* Mobile Menu Button */}
          <div className="lg:hidden">
            <button
              className="p-2 text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors"
              onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            >
              {isMobileMenuOpen ? (
                <X className="h-6 w-6" />
              ) : (
                <Menu className="h-6 w-6" />
              )}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu */}
      {isMobileMenuOpen && (
        <div className="lg:hidden bg-gray-900 border-t border-gray-800">
          <div className="px-2 pt-2 pb-3 space-y-1">
            {mainNavLinks.map((link) => (
              <NavLink
                key={link.title}
                to={link.href}
                onClick={() => setIsMobileMenuOpen(false)}
                className={({ isActive }) =>
                  `block px-3 py-2 rounded-lg text-base font-medium transition-colors ${
                    isActive
                      ? "text-red-500 bg-red-500/10"
                      : "text-gray-400 hover:text-white hover:bg-gray-800"
                  }`
                }
              >
                {link.title}
              </NavLink>
            ))}

            <div className="pt-4 pb-3 border-t border-gray-800">
              <div className="flex items-center px-3">
                <div className="flex-shrink-0">
                  <div className="h-10 w-10 rounded-lg bg-gray-800 flex items-center justify-center">
                    <User className="h-6 w-6 text-gray-400" />
                  </div>
                </div>
                <div className="ml-3">
                  <div className="text-base font-medium text-gray-200">
                    User Name
                  </div>
                  <div className="text-sm font-medium text-gray-400">
                    user@example.com
                  </div>
                </div>
              </div>

              <div className="mt-3 space-y-1">
                <button className="w-full px-4 py-2 text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors flex items-center">
                  <Settings className="h-5 w-5 mr-3" />
                  Settings
                </button>
                <button className="w-full px-4 py-2 text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors flex items-center">
                  <HelpCircle className="h-5 w-5 mr-3" />
                  Help & Support
                </button>
                <button
                  onClick={handleSignout}
                  className="w-full px-4 py-2 text-red-500 hover:bg-red-500/10 rounded-lg transition-colors flex items-center"
                >
                  <LogOut className="h-5 w-5 mr-3" />
                  Sign out
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Search Dialog */}
      {isSearchOpen && (
        <div className="absolute top-16 left-0 w-full p-4 bg-gray-900 border-t border-gray-800">
          <input
            type="text"
            placeholder="Search..."
            className="w-full bg-gray-800 text-gray-200 border border-gray-700 rounded-lg px-4 py-2 focus:outline-none focus:border-red-500 transition-colors"
          />
        </div>
      )}
    </nav>
  );
};

export default Navbar;
