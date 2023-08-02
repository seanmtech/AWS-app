exports.handler = async (event) => {
    console.log("hey cool an image was uploaded");

    // Log the event object for debugging purposes
    console.log(JSON.stringify(event, null, 2));
};