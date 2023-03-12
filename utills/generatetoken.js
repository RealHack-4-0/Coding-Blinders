const jwt = require("jsonwebtoken");

const generateToken = (id, role = "patient") => {
  console.log(id, role)
  return jwt.sign({ id, role }, process.env.JWT_SECRET, {
    expiresIn: "30d",
  });

  // return jwt.sign({ id }, process.env.JWT_SECRET, {
  //   expiresIn: "30d",
  // });
};

module.exports = { generateToken }