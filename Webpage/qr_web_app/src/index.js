import React, { StrictMode } from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { createRoot } from "react-dom/client";
import "./index.css";

import Login from "./LoginPage";
import LandingPage from "./LandingPage";
import ResourcesPage from "./ResourcesPage";
import Navbar from "./Navbar";
import DashboardPage from "./DashboardPage";
import AccessPermissionPage from "./AccessPermissionPage";
import SharedContentViewer from "./components/SharedContentViewer";
import ErrorBoundary from "./ErrorBoundary";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Login />,
    errorElement: <ErrorBoundary />,
  },
  {
    path: "/landing",
    element: (
      <>
        <Navbar />
        <LandingPage />
      </>
    ),
    errorElement: <ErrorBoundary />,
  },
  {
    path: "/dashboard",
    element: (
      <>
        <Navbar />
        <DashboardPage />
      </>
    ),
    errorElement: <ErrorBoundary />,
  },
  {
    path: "/accesspermission",
    element: (
      <>
        <Navbar />
        <AccessPermissionPage />
      </>
    ),
    errorElement: <ErrorBoundary />,
  },
  {
    path: "/resources",
    element: (
      <>
        <Navbar />
        <ResourcesPage />
      </>
    ),
    errorElement: <ErrorBoundary />,
  },
  {
    path: "/shared/:token",
    element: <SharedContentViewer />,
    errorElement: <ErrorBoundary />,
  },
]);

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>
);
