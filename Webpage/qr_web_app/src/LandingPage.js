import React from 'react';
import Navbar from './Navbar';
import './LandingPage.css'; // Import the CSS file for styling

const LandingPage = () => {
  return (
    <div className="landing-page">
      <Navbar />
      <div className="landing-content">
        <h1>Welcome to the Landing Page!</h1>
        
      </div>
    </div>
  );
};

export default LandingPage;
