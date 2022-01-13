const jwt = require('jsonwebtoken')

const config = require('../config')

const verifyToken = async (req, res, next) => {
    const token = req.header('Authorization').replace('Bearer ', '')
    if (!token) {
        return res.status(401).json({
            code: 401,
            message: 'A token is required for authentication',
        })
    }

    try {
        const decoded = jwt.verify(token, config.auth.secret)

        req.email = decoded.email
    } catch (err) {
        return res.status(401).send('Invalid token!')
    }

    next()
}

module.exports = verifyToken