const jwt = require("jsonwebtoken");
const UserModel = require('../model/user');
const createError = require("../utills/error");

const protect = async (req, res, next) => {
  let token;

  console.log("test");
  console.log(req.headers);

  if (req.headers.authorization) {

    // console.log("test2");

    try {

      // print headers

      token = req.headers.authorization.split(" ")[1];
      token = req.headers.authorization;

      // console.log(req.headers.authorization);
      // console.log("token");

      jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        if (err) return next(createError(403, "Token is not valid!"));
        console.log(user);
        req.user = user;

        next();
      });
    } catch (error) {
      next(createError(401, "Not authorized, token failed"));
    }

    // if (!token) {
    //   next(createError(401, "Not authorized, token failed"));
    // }
  } else {
    next(createError(401, "Not authorized, token failed"));
  }
};

// check admin doctor nurse or patient in role in token
const authorize = (...roles) => {
  return (req, res, next) => {

    try {

      token = req.headers.authorization
      jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        if (err) return next(createError(403, "Token is not valid!"));
        console.log(user);
        req.user = user;

        if (!roles.includes(user.role)) {
          return next(createError(401, "Not authorized to access this route"));
        }

        next();
      });

    } catch (error) {
      next(createError(401, "Not authorized, token failed"));
    }


    
  };
};


module.exports = { protect, authorize };