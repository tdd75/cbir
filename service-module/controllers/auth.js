const { validationResult } = require('express-validator')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')

const User = require('../models/user')
const config = require('../config')

const refreshTokens = {}

const login = (req, res, next) => {
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.status(422).json({ errors: errors.array() })
    }

    User.findOne({ email: req.body.email }).then(userDoc => {
        if (!userDoc) {
            return res.status(401).json({
                code: 401,
                message: 'The account does not exist, please register an account.'
            })
        }

        bcrypt.compare(req.body.password, userDoc.password)
            .then(doMatch => {
                if (!doMatch) {
                    return res.status(401).json({
                        code: 401,
                        message: 'Incorrect password.'
                    })
                }

                const loginInfo = {
                    'email': req.body.email,
                    'password': req.body.password,
                }

                const token = jwt.sign(loginInfo, config.auth.secret, {
                    expiresIn: config.auth.tokenLife
                })
                const refreshToken = jwt.sign(loginInfo, config.auth.secretRefresh, {
                    expiresIn: config.auth.refreshTokenLife
                })

                refreshTokens[refreshToken] = loginInfo

                const resposnseData = {
                    accessToken: token,
                    expiresIn: parseInt(config.auth.tokenLife.replace('d', '')) * 86400,    // convert days to seconds
                    refreshToken: refreshToken,
                    refreshExpiresIn: parseInt(config.auth.refreshTokenLife.replace('d', '')) * 86400,
                }

                return res.status(200).json({
                    code: 200,
                    message: 'Login successfully',
                    data: resposnseData,
                })
            })
    })
}

const signup = (req, res, next) => {
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.status(422).json({ errors: errors.array() })
    }

    User.findOne({ email: req.body.email }).then(userDoc => {
        if (userDoc) {
            return res.status(401).json({
                code: 401,
                message: 'That email is taken. Try another.'
            })
        }

        bcrypt.hash(req.body.password, config.auth.salt)
            .then(hashedPassword => {
                const user = User({
                    email: req.body.email,
                    displayName: req.body.displayName,
                    password: hashedPassword,
                })
                return user.save()
                    .then(
                        () => res.status(201).json({
                            code: 201,
                            message: 'Create account successfuly.',
                        }))
            })
            .catch(err => {
                console.log(err)
                return res.status(500).json({
                    code: 500,
                    message: 'Something went wrong!',
                })
            })
    })
}

const refreshToken = (req, res, next) => {
    const refreshToken = req.body.refreshToken

    if ((refreshToken) && (refreshToken in refreshTokens)) {
        const user = refreshTokens[refreshToken]

        const token = jwt.sign(user, config.auth.secret, {
            expiresIn: config.auth.tokenLife,
        })

        return res.status(200).json({
            code: 200,
            token: token,
        })
    } else {
        return res.status(400).json({
            code: 400,
            message: 'Invalid request',
        })
    }
}

const updatePassword = (req, res, next) => {
    return res.status(200).json({
        code: 200,
        token: 200,
    })
}

const confirmResetPassword = (req, res, next) => {
    return res.status(200).json({
        code: 200,
        token: 200,
    })
}

module.exports = { login, signup, refreshToken, updatePassword, confirmResetPassword }