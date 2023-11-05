import React from 'react';
import { Link } from 'react-router-dom';
import './App.css';

function App() {
  return (
    <div>
      <h1>AWS Contacts App</h1>
      <nav
        style={{
          borderBottom: "solid 1px",
          paddingBottom: "1rem",
        }}
      >
        <Link to="/PageOne">PageOne</Link> |{" "}
        <Link to="/PageTwo">PageTwo</Link>
      </nav>
    </div>
  );
}

export default App;