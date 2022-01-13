const nodemailer = require('nodemailer')


const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'tranducduy7520@gmail.com',
        pass: 'longdinhkout'
    }
})


const sendMailResetPassword = () => {
    const mailOptions = {
        from: 'Shop App',
        to: 'anovar75@gmail.com',
        subject: 'Reset Password',
        html: '<p>We have just received a password reset request for tranducduy7520@gmail.com.</p> \
        <p> Your code is: 123456</p> '
    }

    transporter.sendMail(mailOptions, function (error, info) {
        if (error) {
            console.log(error)
        } else {
            console.log('Email sent: ' + info.response)
        }
    })
}

module.exports = { sendMailResetPassword }