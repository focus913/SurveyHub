package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.Invitation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

@Component
public class SurveyHubEmailService {
    @Autowired
    public JavaMailSender mailSender;

    public void sendInvitationMail(Invitation invitation) {
        String content = "Survey Invitation: " + invitation.getUrl();
        String subject = "Survey Invitation";
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(invitation.getToEmail());
        message.setSubject(subject);
        message.setText(content);
        mailSender.send(message);
    }

    public void sendComfirmMail(String to, String surveyId) {
        String subject = "Survey Submission Confirm";
        String content = "Your survey " + surveyId + " has submitted";
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject(subject);
        message.setText(content);
        mailSender.send(message);
    }
}
