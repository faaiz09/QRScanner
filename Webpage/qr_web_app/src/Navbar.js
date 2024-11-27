import React, { useState } from "react";
import { NavLink, useLocation, useNavigate, Link } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faBell,
  faSearch,
  faChevronDown,
  faSignOutAlt,
  faCog,
  faQuestionCircle,
  faBars,
  faTimes,
  faUserAlt,
} from "@fortawesome/free-solid-svg-icons";

import logo from "./assets/technocrafts.png";

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
      // Your signout logic (like clearing user session, etc.)
      // Then redirect to login page
      navigate("/"); // Redirect to login page
    }
  };

  const mainNavLinks = [
    { title: "Dashboard", href: "/dashboard" },
    { title: "Resources", href: "/resources" },
    { title: "Access Permissions", href: "/accesspermission" },
  ];

  return (
    <nav className="fixed top-0 w-full z-50 bg-white shadow-md">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <div className="flex-shrink-0 flex items-center">
            <Link to="/landing">
              {" "}
              {/* Wrap img inside a Link with the path to /landing */}
              <img src={logo} alt="Company Logo" className="h-8 w-auto" />
            </Link>
          </div>

          {/* Desktop Navigation */}
          <div className="hidden lg:flex items-center space-x-1">
            {mainNavLinks.map((link) => (
              <NavLink
                key={link.title}
                to={link.href}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-colors duration-200
                  ${
                    location.pathname === link.href
                      ? "text-blue-600"
                      : "text-gray-600 hover:text-blue-600 hover:bg-gray-50"
                  }`}
              >
                {link.title}
              </NavLink>
            ))}
          </div>

          {/* Right Side Icons */}
          <div className="hidden lg:flex items-center space-x-4">
            {/* Search Dialog */}
            {isSearchOpen && (
              <div className="dialog">
                <div className="dialog-content">
                  <input
                    type="text"
                    placeholder="Search..."
                    className="focus:ring-0 p-2"
                  />
                </div>
              </div>
            )}
            <button
              className="hover:bg-gray-100 p-2"
              onClick={() => setIsSearchOpen(!isSearchOpen)}
              aria-label="Open search"
            >
              <FontAwesomeIcon
                icon={faSearch}
                className="h-5 w-5 text-gray-600"
              />
            </button>

            {/* Notifications Button */}
            <button
              className="hover:bg-gray-100 p-2"
              aria-label="Open notifications"
            >
              <FontAwesomeIcon
                icon={faBell}
                className="h-5 w-5 text-gray-600"
              />
            </button>

            {/* User Menu */}
            <div className="relative">
              <button
                className="hover:bg-gray-100 p-2"
                aria-label="Open user menu"
                onClick={() => setIsDropdownOpen(!isDropdownOpen)}
              >
                <FontAwesomeIcon
                  icon={faUserAlt}
                  className="h-5 w-5 text-gray-600"
                />
                <FontAwesomeIcon
                  icon={faChevronDown}
                  className="ml-2 h-4 w-4 text-gray-600"
                />
              </button>

              {/* Conditionally render the dropdown menu */}
              {isDropdownOpen && (
                <div className="absolute right-0 mt-2 w-48 bg-white shadow-lg rounded-md">
                  <ul className="py-1">
                    <li className="px-4 py-2 text-gray-700 hover:bg-gray-100 cursor-pointer">
                      <FontAwesomeIcon icon={faCog} className="mr-2 h-4 w-4" />
                      Settings
                    </li>
                    <li className="px-4 py-2 text-gray-700 hover:bg-gray-100 cursor-pointer">
                      <FontAwesomeIcon
                        icon={faQuestionCircle}
                        className="mr-2 h-4 w-4"
                      />
                      Help & Support
                    </li>
                    <li
                      className="px-4 py-2 text-red-600 hover:bg-red-50 cursor-pointer"
                      onClick={handleSignout}
                    >
                      <FontAwesomeIcon
                        icon={faSignOutAlt}
                        className="mr-2 h-4 w-4"
                      />
                      Sign out
                    </li>
                  </ul>
                </div>
              )}
            </div>
          </div>

          {/* Mobile Menu Button */}
          <div className="lg:hidden">
            <button
              className="hover:bg-gray-100 p-2"
              onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
              aria-label="Toggle mobile menu"
            >
              {isMobileMenuOpen ? (
                <FontAwesomeIcon
                  icon={faTimes}
                  className="h-6 w-6 text-gray-600"
                />
              ) : (
                <FontAwesomeIcon
                  icon={faBars}
                  className="h-6 w-6 text-gray-600"
                />
              )}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu */}
      {isMobileMenuOpen && (
        <div className="lg:hidden">
          <div className="px-2 pt-2 pb-3 space-y-1 bg-white border-t">
            {mainNavLinks.map((link) => (
              <NavLink
                key={link.title}
                to={link.href}
                onClick={() => setIsMobileMenuOpen(false)}
                className={`block px-3 py-2 rounded-md text-base font-medium transition-colors duration-200
                  ${
                    location.pathname === link.href
                      ? "text-blue-600 bg-blue-50"
                      : "text-gray-600 hover:text-blue-600 hover:bg-gray-50"
                  }`}
              >
                {link.title}
              </NavLink>
            ))}
            <div className="pt-4 pb-3 border-t border-gray-200">
              <div className="flex items-center px-3">
                <div className="flex-shrink-0">
                  <img
                    src="/api/placeholder/40/40"
                    alt="User"
                    className="h-10 w-10 rounded-full"
                  />
                </div>
                <div className="ml-3">
                  <div className="text-base font-medium text-gray-800">
                    User Name
                  </div>
                  <div className="text-sm font-medium text-gray-500">
                    user@example.com
                  </div>
                </div>
              </div>
              <div className="mt-3 space-y-1">
                <button className="w-full justify-start text-gray-600 hover:text-blue-600 hover:bg-gray-50">
                  <FontAwesomeIcon icon={faCog} className="mr-3 h-5 w-5" />
                  Settings
                </button>
                <button className="w-full justify-start text-gray-600 hover:text-blue-600 hover:bg-gray-50">
                  <FontAwesomeIcon
                    icon={faQuestionCircle}
                    className="mr-3 h-5 w-5"
                  />
                  Help & Support
                </button>
                <button
                  onClick={handleSignout}
                  className="w-full justify-start text-red-600 hover:text-red-700 hover:bg-red-50"
                >
                  <FontAwesomeIcon
                    icon={faSignOutAlt}
                    className="mr-3 h-5 w-5"
                  />
                  Sign out
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </nav>
  );
};

export default Navbar;
