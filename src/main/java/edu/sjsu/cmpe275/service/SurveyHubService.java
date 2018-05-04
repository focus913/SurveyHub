package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.*;
import edu.sjsu.cmpe275.exceptions.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.*;

public class SurveyHubService {
    @Autowired
    AccountRepository accountRepository;

    @Autowired
    AnswerRepository answerRepository;

    @Autowired
    InvitationRepository invitationRepository;

    @Autowired
    QuestionRepository questionRepository;

    @Autowired
    SurveyRepository surveyRepository;

    @Autowired
    AccountToSurveyRepository accountToSurveyRepository;

    public void createSurvey(String accountId, Survey survey, boolean publish) {
        // Get account
        Optional<Account> maybeAccount = accountRepository.findById(accountId);
        if (!maybeAccount.isPresent()) {
            throw new AccountNotExistException("Account " + accountId + " not exist");
        }

        survey.setCreator(maybeAccount.get());
        survey.setCreateTime(new Date());
        survey.setStatus(publish ? Survey.SurveyStatus.PUBLISHED : Survey.SurveyStatus.EDITTING);

        // Save survey
        surveyRepository.save(survey);

        // Send invitation email for closed type
        if (publish && survey.getType() == Survey.SurveyType.CLOSED_INVITATION) {
            sendInvitation(survey.getInvitations());
        }
    }

    public Survey getSurvey(String surveyId) {
        Optional<Survey> maybeSurvey = surveyRepository.findById(surveyId);
        if (!maybeSurvey.isPresent()) {
            throw new SurveyNotExistException("Survey with id: " + surveyId + " not exist");
        }
        return maybeSurvey.get();
    }

    public void updateSurvyStatus(String surveyId, Survey.Action action, Date newDueDate) {
        Survey survey = getSurvey(surveyId);
        switch (action) {
            case CLOSE:
                survey.setStatus(Survey.SurveyStatus.CLOSED);
                break;
            case EXTEND:
                Date now = new Date();
                if (survey.getExpireTime().before(now)) {
                    throw new SurveyExpiredException("Survey " + surveyId + " expired");
                }
                survey.setExpireTime(newDueDate);
                break;
            case PUBLISH:
                survey.setStatus(Survey.SurveyStatus.PUBLISHED);
                break;
            case UNPUBLISH:
                if (hasSubmitted(surveyId)) {
                    throw new SurveyUnwritableException("Survey " + surveyId + " has been published");
                }
                survey.setStatus(Survey.SurveyStatus.EDITTING);
                break;
            default:
                    throw new InvalidOperationException("Unsupported exception");

        }
    }

    public void createAccount(Account account) {
        account.setVerified(false);
        String verifyCode = genterateVerifyCode();
        account.setVerifyCode(verifyCode);
        sendVerifyCode(account.getEmail(), verifyCode);
        accountRepository.save(account);
    }

    public Account getAccount(String accountId) {
        Optional<Account> maybeAccount = accountRepository.findById(accountId);
        if (!maybeAccount.isPresent()) {
            throw new AccountNotExistException("Account " + accountId + " not exist");
        }
        return maybeAccount.get();
    }

    public void sendVerifyCode(String email, String code) {

    }

    private String genterateVerifyCode() {
        return UUID.randomUUID().toString().replaceAll("-", "")
                   .substring(0, 7).toUpperCase();
    }

    public void verifyAccount(String accountId, String code) {
        Account account = getAccount(accountId);
        if (!account.getVerifyCode().equals(code)) {
            throw new VerifyFailedException("Account verify failed");
        }
    }

    public void createQuestions(String surveyId, List<Question> questions) {
        Survey survey = getSurvey(surveyId);
        for (Question question : questions) {
            question.setSurvey(survey);
        }
        survey.getQuestions().addAll(questions);
        surveyRepository.save(survey);
    }

    public void deleteQuestion(String surveyId, Question question) {
        Survey survey = getSurvey(surveyId);
        List<Question> questions = new ArrayList<>();
        for (Question q : survey.getQuestions()) {
            if (!q.equals(question)) {
                questions.add(q);
            }
        }
        surveyRepository.save(survey);
    }

    public void saveAnswer(String questionId, Answer answer) {
        Question question = getQuestion(questionId);
        answer.setSubmitted(false);
        answer.setQuestion(question);
        question.getAnswers().add(answer);
        questionRepository.save(question);
    }

    public Question getQuestion(String questionId) {
        Optional<Question> maybeQuestion = questionRepository.findById(questionId);
        if (!maybeQuestion.isPresent()) {
            throw new QuestionNotExistException("Question " + questionId + " not exist");
        }
        return maybeQuestion.get();
    }

    public Iterable<Answer> getAnswers(String questionId) {
        Question question = getQuestion(questionId);
        return question.getAnswers();
    }

    public Answer getAnswer(String questionId, String accountId) {
        Question question = getQuestion(questionId);
        for (Answer answer : question.getAnswers()) {
            if (accountId.equals(answer.getAccountId())) {
                return answer;
            }
        }
        return null;
    }

    public void submitSurvey(String surveyId, String accoundId) {
        Optional<AccountToSurvey> maybeVal =
                accountToSurveyRepository.findBySurveyIdAndAccountId(surveyId, accoundId);
        if (!maybeVal.isPresent()) {
            throw new InvalidOperationException("No account to survey record");
        }
        AccountToSurvey accountToSurvey = maybeVal.get();
        accountToSurvey.setSubmitted(true);

        Survey survey = getSurvey(surveyId);
        for (Question question : survey.getQuestions()) {
            question.getAnswers().forEach(answer -> {
                answer.setSubmitted(true);
            });
        }
        surveyRepository.save(survey);
        accountToSurveyRepository.save(accountToSurvey);
    }

    private boolean hasSubmitted(String surveyId) {
        Iterable<AccountToSurvey> accountToSurveys =
                accountToSurveyRepository.findAllBySurveyId(surveyId);
        Iterator<AccountToSurvey> iter = accountToSurveys.iterator();
        while (iter.hasNext()) {
            AccountToSurvey accountToSurvey = iter.next();
            if (accountToSurvey.isSubmitted()) {
                return true;
            }
        }
        return false;
    }

    private void sendInvitation(List<Invitation> invitations) {

    }
}
