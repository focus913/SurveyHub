package edu.sjsu.cmpe275.domain;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "survey")
public class Survey {
    public enum SurveyType {
        GENERAL_SURVEY,
        CLOSED_INVITATION,
        OPEN_UNIQUE
    }

    public enum SurveyStatus {
        EDITING,
        PUBLISHED,
        COMPLETED,
        CLOSED,
        EXPIRED
    }

    @Id
    @Column(name = "sruvey_id")
    private String surveyId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    private Account creator;

    @Column(name = "survey_type", nullable = false)
    private SurveyType type;

    @Column(name = "status", nullable = false)
    private SurveyStatus status;

    @Column(name = "create_time", nullable = false)
    private Date createTime;

    @Column(name = "expire_time", nullable = false)
    private Date expireTime;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "survey")
    List<Invitation> invitations;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "survey")
    List<Question> questions;

    @ManyToMany(fetch = FetchType.LAZY, mappedBy = "joinedSurveys")
    List<Account> participants;

    public void setSurveyId(String surveyId) {
        this.surveyId = surveyId;
    }

    public void setType(SurveyType type) {
        this.type = type;
    }

    public void setStatus(SurveyStatus status) {
        this.status = status;
    }

    public void setExpireTime(Date expireTime) {
        this.expireTime = expireTime;
    }

    public void setInvitations(List<Invitation> invitations) {
        this.invitations = invitations;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }

    public void setParticipants(List<Account> participants) {
        this.participants = participants;
    }

    public SurveyType getType() {

        return type;
    }

    public SurveyStatus getStatus() {
        return status;
    }

    public Date getExpireTime() {
        return expireTime;
    }

    public List<Invitation> getInvitations() {
        return invitations;
    }

    public List<Question> getQuestions() {
        return questions;
    }

    public List<Account> getParticipants() {
        return participants;
    }

    public String getSurveyId() {

        return surveyId;
    }

    public Account getCreator() {
        return creator;
    }

    public void setCreator(Account creator) {
        this.creator = creator;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
