import React from "react";
import LandingPage from "./LandingPage";
import Navbar from "./Navbar"; // Import Navbar here

function App() {
  return (
    <div className="App">
      <Navbar /> {/* Include Navbar in App */}
      <LandingPage />
    </div>
  );
}

export default App;
