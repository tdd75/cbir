const mongoose = require('mongoose')

const userSchema = mongoose.Schema({
    email: {
        type: String,
        required: true,
        lowercase: true,
        trim: true,
    },
    password: {
        type: String,
        minlength: 6,
    },
    displayName: {
        type: String,
    },
    favoriteList: {
        type: Array,
    },
}, {
    versionKey: false
})

module.exports = mongoose.model('User', userSchema)