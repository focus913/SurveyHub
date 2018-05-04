package edu.sjsu.cmpe275.domain;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "account")
public class Account {
    public enum AccountType {
        SURVEYOR,
        SURVEYEE
    }

    @Id
    @Column(name = "account_id")
    private String accountId;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "type", nullable = false)
    private AccountType type;

    @Column(name = "verify_code", nullable = false)
    private String verifyCode;

    @Column(name = "verified", nullable = false)
    private boolean verified;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "creator")
    private List<Survey> createSurveys = new ArrayList<>();

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "account_to_survey",
                joinColumns = { @JoinColumn(name = "survey_id")},
                inverseJoinColumns = { @JoinColumn(name = "account_id")})
    private List<Survey> joinedSurveys = new ArrayList<>();

    public List<Survey> getCreateSurveys() {
        return createSurveys;
    }

    public void setCreateSurveys(List<Survey> createSurveys) {
        this.createSurveys = createSurveys;
    }

    public AccountType getType() {
        return type;
    }

    public boolean isVerified() {
        return verified;
    }

    public List<Survey> getJoinedSurveys() {
        return joinedSurveys;
    }

    public String getAccountId() {
        return accountId;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getVerifyCode() {
        return verifyCode;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setJoinedSurveys(List<Survey> surveys) {
        this.joinedSurveys = surveys;
    }

    public void setType(AccountType type) {
        this.type = type;
    }

    public void setVerified(boolean verified) {
        this.verified = verified;
    }

    public void setVerifyCode(String verifyCode) {
        this.verifyCode = verifyCode;
    }

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Account)) {
            return false;
        }
        Account other = (Account)o;
        return accountId.equals(other.accountId);
    }

    @Override
    public int hashCode() {
        return accountId.hashCode();
    }

    public Account() {
        this.accountId = "account_" + UUID.randomUUID().toString().replaceAll("-", "");
    }
}
