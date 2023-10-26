# AWS-app

This app allows a user to save a contact and upload an image to associate with that contact. 

A lambda function is invoked to save the image to an S3 bucket and make an entry for the contact
  in a Dynamo DB table.
  
Another lambda function is invoked to process/trim the image to a smaller size so it can be served back more quickly in the future.
