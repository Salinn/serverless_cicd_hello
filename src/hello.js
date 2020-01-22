exports.handler = async (event, context) => {
    const name = event.query.name === undefined 
        ? 'No-Name' 
        : event.query.name
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: `Hello ${name}`
        }),
    };
};