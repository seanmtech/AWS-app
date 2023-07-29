// WebForm.js
import React from 'react';

const handleSubmit = (event) => {
  event.preventDefault(); // Prevents the default form submission behavior

  // Replace 'YOUR_API_ENDPOINT_URL' with the actual URL of your AWS API Gateway endpoint
  const apiEndpoint = 'https://mzm4cve6gb.execute-api.us-east-1.amazonaws.com/TEST';

  const formData = new FormData(event.target);

  // Use the fetch API to make a POST request to your API endpoint
  fetch(apiEndpoint, {
    method: 'POST',
    body: JSON.stringify({
      name: formData.get('name'),
      email: formData.get('email'),
      phone: formData.get('phone'),
      message: formData.get('message'),
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  })
    .then((response) => response.json())
    .then((data) => {
      // Handle the response from the API if needed
      console.log(data);
    })
    .catch((error) => {
      // Handle any errors that occur during the API call
      console.error('Error:', error);
    });
};

// function for my image upload that connects to api endpoint
function submitImage (event) {
  event.preventDefault(); // Prevents the default form submission behavior




const PageOne = () => {
  return (
    <div>
      <h2>PAGE ONE!!</h2>
      <form onSubmit={handleSubmit}>
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
        <br />
        <input type="file" name="file" />
      </form>
    </div>
  );
};

export default PageOne;
