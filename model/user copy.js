const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const userSchema = new Schema(
  {
    name: {
        type: String,
        required: true,
      },
    username: {
      type: String,
      required: true,
    },
    password: {
        type: String,
        required: true,
    },
    // integer
    role: {
        type: Number,
        required: true,
    }
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("user", userSchema);
