module.exports.hello = async (event, context) => {
    const name = event.query.name === undefined 
        ? 'No-Name' 
        : event.query.name;
    context.done(null, { 'Hello': name });
};
