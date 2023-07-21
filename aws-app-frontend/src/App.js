import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import PageOne from './PageOne';
import PageTwo from './PageTwo'; 
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <div className='content'>
          <PageOne />
          {/* <Switch>
            <Route path="/PageOne">
              <PageOne />
            </Route>
          </Switch> */}
        </div>
      </div>
    </Router>
  );
}

export default App;



// <div className="App">
// <header className="App-header">
//   <img src={logo} className="App-logo" alt="logo" />
//   <p>
//     Edit <code>src/App.js</code> and save to reload.
//   </p>
//   <a
//     className="App-link"
//     href="https://reactjs.org"
//     target="_blank"
//     rel="noopener noreferrer"
//   >
//     Learn Amazing Things
//   </a>
// </header>
// </div>