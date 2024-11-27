import React, { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";

import { createBrowserRouter, RouterProvider } from "react-router-dom";
import Login from "./LoginPage";
import LandingPage from "./LandingPage";
import ResourcesPage from "./ResourcesPage";
import Navbar from "./Navbar"; // Import Navbar here
import DashboardPage from "./DashboardPage";
import AccessPermissionPage from "./AccessPermissionPage";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Login />, // No navbar on Login
  },
  {
    path: "/landing",
    element: (
      <>
        <Navbar /> {/* Navbar will appear here */}
        <LandingPage />
      </>
    ),
  },
  {
    path: "/dashboard",
    element: (
      <>
        <Navbar /> {/* Navbar will appear here */}
        <DashboardPage />
      </>
    ),
  },
  {
    path: "/accesspermission",
    element: (
      <>
        <Navbar /> {/* Navbar will appear here */}
        <AccessPermissionPage />
      </>
    ),
  },
  {
    path: "/resources",
    element: (
      <>
        <Navbar /> {/* Navbar will appear here */}
        <ResourcesPage />
      </>
    ),
  },
]);

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>
);
