const mongoose = require('mongoose')
const config = require('../config')

const mongoConnect = () => {
    mongoose.connect(config.db.uri)
        .then(() => {
            console.log('Connected!')
        })
        .catch(err => {
            console.log(err)
            throw err
        })
}
module.exports = mongoConnect