package com.houselogiq.util;

import com.houselogiq.data.Mail;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.springframework.core.env.Environment;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.web.filter.CommonsRequestLoggingFilter;

import java.util.Properties;

@Configuration
public class MailConfiguration {

    private final Environment env;

    public MailConfiguration(Environment env) {
        this.env = env;
    }

    @Bean
    public JavaMailSender getMailSender() {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();

        mailSender.setHost(env.getProperty("spring.mail.host"));
        mailSender.setPort(Integer.valueOf(env.getProperty("spring.mail.port")));
        mailSender.setUsername(env.getProperty("spring.mail.username"));
        mailSender.setPassword(env.getProperty("spring.mail.password"));

        Properties javaMailProperties = new Properties();
        String user = env.getProperty("spring.mail.username","suport@houseLogic.com");
        String pass = env.getProperty("spring.mail.password","123456");
//        javaMailProperties.put("mail.smtp.host", env.getProperty("spring.mail.host","smtp.mail.yahoo.com"));
//        javaMailProperties.put("mail.smtp.port", env.getProperty("spring.mail.port","465"));
//        javaMailProperties.put("mail.smtp.user", user);
//        javaMailProperties.put("mail.smtp.password", pass);
        javaMailProperties.put("mail.smtp.ssl.enable", env.getProperty("mail.smtp.ssl.enable","true"));
        javaMailProperties.put("mail.smtp.auth", env.getProperty("mail.smtp.auth","true"));
//        javaMailProperties.put("mail.transport.protocol", env.getProperty("mail.transport.protocol","smtp"));
        javaMailProperties.put("mail.debug", env.getProperty("mail.debug","true"));
//        Session session = Session.getInstance(javaMailProperties, new javax.mail.Authenticator() {
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(user, pass);
//            }
//        });
//        mailSender.setSession(session);
        mailSender.setJavaMailProperties(javaMailProperties);
        return mailSender;
    }
//
//    @Bean
//    @Qualifier("otpMailConfig")
//    @Scope("prototype")
//    public Mail getOtpMailConfig(){
//        Mail mail = Mail.builder()
//                .mailFrom(env.getProperty("spring.mail.username"))
//                .mailSubject(env.getProperty("logiq.otp.message.subject"))
//                .mailContent(env.getProperty("logiq.otp.message.body"))
//                .contentType("text/plain").build();
//        return mail;
//    }
//
//    @Bean
//    @Qualifier("invitationMailConfig")
//    @Scope("prototype")
//    public Mail getInvitationMailConfig(){
//        Mail mail = Mail.builder()
//                .mailFrom(env.getProperty("spring.mail.username"))
//                .mailContent(env.getProperty("logiq.otp.message.body"))
//                .contentType("text/plain").build();
//        return mail;
//    }

}
