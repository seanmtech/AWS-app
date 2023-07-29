const AWS = require('aws-sdk');
const sharp = require('sharp');

const s3 = new AWS.S3();

exports.handler = async (event, context) => {

  // TODO: write metadata to dynamodb as well to link users with both uploaded and edited images

  try {
    // Retrieve the image file from the event payload (assuming it's in the 'image' key)
    const image = Buffer.from(event.image, 'base64');

    // Perform image cropping using Sharp
    const croppedImageBuffer = await sharp(image)
      .resize(500, 500)
      .toBuffer();

    // Upload the cropped image to S3 bucket
    const params = {
      Bucket: 'your-s3-bucket-name',
      Key: 'path/to/cropped-image.jpg', // TODO Set file path
      Body: croppedImageBuffer,
      ACL: 'public-read', 
      ContentType: 'image/jpeg', // add PNG to this too somehow?
    };

    await s3.upload(params).promise();
    return { statusCode: 200, body: 'Image cropped and uploaded successfully!' };
  } catch (err) {
    console.error(err);
    return { statusCode: 500, body: 'An error occurred while cropping the image.' };
  }
};
