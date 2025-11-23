package com.houselogiq.service;

import com.houselogiq.data.Mail;
import com.houselogiq.util.LogiqException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@Service
public class MailService {

    private JavaMailSender mailSender;
//    private Mail otpMailConfig;
//    private Mail invitationMailConfig;

    @Value("${spring.mail.username}")
    private String from;

    @Value("${logiq.otp.message.body}")
    private String otpBody;

    @Value("${logiq.otp.message.subject}")
    private String otpSubject;

    @Value("${logiq.verify.message.subject}")
    private String verifySubject;

    public MailService(JavaMailSender mailSender/*, @Qualifier("otpMailConfig") Mail otpMailConfig,
                       @Qualifier("invitationMailConfig") Mail invitationMailConfig*/) {
        this.mailSender = mailSender;
//        this.otpMailConfig = otpMailConfig;
//        this.invitationMailConfig = invitationMailConfig;
    }

    public void sendEmail(Mail mail) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        try {
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true);
            mimeMessageHelper.setSubject(mail.getMailSubject());
            mimeMessageHelper.setFrom(new InternetAddress(mail.getMailFrom()/*, mail.getMailFrom()*/));
            mimeMessageHelper.setTo(mail.getMailTo());
            mimeMessageHelper.setText(mail.getMailContent());
            mailSender.send(mimeMessageHelper.getMimeMessage());
        } catch (MessagingException e) {
            throw new LogiqException(e.getLocalizedMessage());
        }
    }

    public void sendOtpEmail(String recipient, String otp) {
        Mail mail = Mail.builder()
                .mailFrom(from)
                .contentType("text/plain")
                .mailSubject(otpSubject)
                .mailContent(otpBody.replace("{}", otp))
                .mailTo(recipient).build();
        sendEmail(mail);
    }

    public void sendInvitationEmail(String recipient, String body) {
        Mail mail = Mail.builder()
                .mailFrom(from)
                .contentType("text/plain")
                .mailSubject(verifySubject)
                .mailContent(body)
                .mailTo(recipient).build();
        sendEmail(mail);
    }

}
