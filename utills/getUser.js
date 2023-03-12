const jwt = require('jsonwebtoken');

function getUserFromToken(token) {
    try {


        // token = req.headers.authorization;
        // jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        //     if (err) return next(createError(403, "Token is not valid!"));
        //     console.log(user);
        //     req.user = user;

        //     return(user)

        //     next();
        // });


        const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
        const id = decodedToken.id;
        const role = decodedToken.role;
        return { id, role };
    } catch (error) {
        console.error(error);
        return null;
    }
}

module.exports = { getUserFromToken };