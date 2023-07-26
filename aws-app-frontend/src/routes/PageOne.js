// WebForm.js
import React from 'react';

const PageOne = () => {
  return (
    <div>
      <h2>Web Form</h2>
      <form>
        <label>
          Name:
          <input type="text" name="name" />
        </label>
        <br />
        <label>
          Email:
          <input type="email" name="email" />
        </label>
        <br />
        <label>
          Phone:
          <input type="tel" name="phone" />
        </label>
        <br />
        <label>
          Message:
          <textarea name="message" rows="4" cols="50" />
        </label>
        <br />
        <button type="submit">Submit</button>
      </form>
    </div>
  );
};

export default PageOne;
