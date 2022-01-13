const express = require('express')
const router = express.Router()

const authController = require('../controllers/auth')
const validate = require('../middleware/validator')
const verifyToken = require('../middleware/auth')
const mail = require('../util/mail')

router.post('/login', validate.validateLogin, authController.login)

router.post('/signup', validate.validateSignup, authController.signup)

router.post('/refresh-token', authController.refreshToken)

// router.post('/update-password', verifyToken, authController.updatePassword)

// Reset password feature

// router.get('/send-mail-reset-password', mail.sendMailResetPassword)

// router.get('/confirm-reset-password',)




module.exports = router