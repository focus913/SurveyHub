package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.*;
import edu.sjsu.cmpe275.exceptions.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

@Component("SurveyHubService")
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

    @Autowired
    SurveyHubEmailService surveyHubEmailService;

    public Survey createSurvey(String accountId, Survey survey) {
        // Get account
        Optional<Account> maybeAccount = accountRepository.findById(accountId);
        if (!maybeAccount.isPresent()) {
            throw new AccountNotExistException("Account " + accountId + " not exist");
        }

        survey.setCreator(maybeAccount.get());
        survey.setCreateTime(new Date());
        survey.setStatus(Survey.SurveyStatus.EDITTING);
        for (Question question : survey.getQuestions()) {
            question.setSurvey(survey);
        }

        // Save survey
        surveyRepository.save(survey);
        return survey;
    }

    public void saveQuestions(String surveyId, List<Question> questions) {
        Survey survey = getSurvey(surveyId);
        List<Question> added = new ArrayList<>();
        for (Question q : questions) {
            boolean existed = false;
            for (Question existedQuestion : survey.getQuestions()) {
                if (existedQuestion.getQuestionId().equals(q.getQuestionId())) {
                    existedQuestion.setQuestionContent(q.getQuestionContent());
                    existed = true;
                    break;
                }
            }
            if (!existed) {
                added.add(q);
            }
        }
        for (Question toAdd : added) {
            toAdd.setSurvey(survey);
        }
        questionRepository.saveAll(added);
        surveyRepository.save(survey);
    }

    public void deleteQuestion(Question question) {
        questionRepository.deleteById(question.getQuestionId());
    }

    public void checkSurvey(String accountId, Survey survey) {
        boolean hasAccount = null != accountId && !accountId.isEmpty();
        for (Question question : survey.getQuestions()) {
            if (hasAccount) {
                List<Answer> answers = new ArrayList<>();
                for (Answer answer : question.getAnswers()) {
                    if (accountId.equals(answer.getAccountId())) {
                        answers.add(answer);
                    }
                }
                question.setAnswers(answers);
            } else {
                question.getAnswers().clear();
            }
        }

        if (!hasAccount) {
            survey.setProtectMode(true);
            return;
        }

        Optional<AccountToSurvey> maybeVal =
                accountToSurveyRepository.findBySurveyIdAndAccountId(survey.getSurveyId(), accountId);
        if (!maybeVal.isPresent()) {
            return;
        }
        AccountToSurvey val = maybeVal.get();
        survey.setProtectMode(val.isSubmitted());
    }

    public Survey getSurvey(String surveyId) {
        Optional<Survey> maybeSurvey = surveyRepository.findById(surveyId);
        if (!maybeSurvey.isPresent()) {
            throw new SurveyNotExistException("Survey with id: " + surveyId + " not exist");
        }
        Survey survey = maybeSurvey.get();
        Date now = new Date();
        if (survey.getExpireTime().before(now)) {
            throw new SurveyExpiredException("Survey expired");
        }
        return survey;
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
                publishSurvey(surveyId);
                break;
            case UNPUBLISH:
                unpublishSurvey(surveyId);
                break;
            default:
                    throw new InvalidOperationException("Unsupported exception");

        }
    }

    private void publishSurvey(String surveyId) {
        Survey survey = getSurvey(surveyId);
        if (survey.getStatus() != Survey.SurveyStatus.EDITTING) {
            throw new InvalidOperationException("Survey " + surveyId + " already published");
        }
        survey.setStatus(Survey.SurveyStatus.PUBLISHED);
        surveyRepository.save(survey);
    }

    private void unpublishSurvey(String surveyId) {
        Survey survey = getSurvey(surveyId);
        if (survey.getStatus() == Survey.SurveyStatus.CLOSED) {
            throw new InvalidOperationException("Closed survey can't be unpublished");
        }
        if (survey.getParticipantNum() > 0) {
            throw new InvalidOperationException("Taken survey can't be unpublished");
        }
        survey.setStatus(Survey.SurveyStatus.EDITTING);
        surveyRepository.save(survey);
    }

    public void createAccount(Account account) {
        Optional<Account> maybeAccount = accountRepository.findByEmail(account.getEmail());
        if (maybeAccount.isPresent()) {
            throw new InvalidOperationException("Account with " + account.getEmail() + " already existed");
        }
        account.setVerified(false);
        String verifyCode = genterateVerifyCode();
        account.setVerifyCode(verifyCode);
        accountRepository.save(account);
        surveyHubEmailService.sendVerificationCode(account.getEmail(), verifyCode);
    }

    public Account getAccountByEmail(String email) {
        Optional<Account> maybeAccount = accountRepository.findByEmail(email);
        if (!maybeAccount.isPresent()) {
            throw new AccountNotExistException("Account " + email + " not exist");
        }
        return maybeAccount.get();
    }

    public Account getAccountById(String accountId) {
        Optional<Account> maybeAccount = accountRepository.findById(accountId);
        if (!maybeAccount.isPresent()) {
            throw new AccountNotExistException("Account " + accountId + " not exist");
        }
        return maybeAccount.get();
    }

    public Account loginAccount(String email, String password) {
        Optional<Account> maybeAccount = accountRepository.findByEmail(email);
        if (!maybeAccount.isPresent()) {
            throw new InvalidOperationException("Invalid account name or password");
        }
        Account account = maybeAccount.get();
        if (!account.isVerified()) {
            throw new InvalidOperationException("Account is not verified");
        }

        if (null == password || !password.equals(account.getPassword())) {
            throw new InvalidOperationException("Invalid account name or password");
        }
        return account;
    }

    private String genterateVerifyCode() {
        return UUID.randomUUID().toString().replaceAll("-", "")
                   .substring(0, 7).toUpperCase();
    }

    public void verifyAccount(String email, String code) {
        Account account = getAccountByEmail(email);
        System.out.println("Account Code " + account.getVerifyCode() + " User code: " + code);
        if (!account.getVerifyCode().equals(code)) {
            throw new VerifyFailedException("Account verify failed");
        }
        account.setVerified(true);
        accountRepository.save(account);
    }

    public void saveAnswers(String accountId, List<Answer> answers, List<String> questionIds) {
        Map<String, Question> questionMap = new HashMap<>();
        List<Answer> toSave = new ArrayList<>();
        for (int i = 0; i < answers.size(); ++i) {
            Answer answer = answers.get(i);
            Question question;
            if (!questionMap.containsKey(questionIds.get(i))) {
                question = getQuestion(questionIds.get(i));
                questionMap.put(questionIds.get(i), question);
            } else {
                question = questionMap.get(questionIds.get(i));
            }
            boolean duplicate = false;
            for (Answer existed : question.getAnswers()) {
                if (existed.getSurveyId().equals(answer.getSurveyId())
                        && existed.getAccountId().equals(accountId)) {
                    existed.setContent(answer.getContent());
                    toSave.add(existed);
                    duplicate = true;
                }
            }
            if (null == accountId || accountId.isEmpty() || !duplicate) {
                answer.setQuestion(question);
                question.getAnswers().add(answer);
                toSave.add(answer);
            }
        }
        answerRepository.saveAll(toSave);
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
        // No need to record submission for non-login user
        if (null == accoundId || accoundId.isEmpty()) {
            return;
        }
        Optional<AccountToSurvey> maybeVal =
                accountToSurveyRepository.findBySurveyIdAndAccountId(surveyId, accoundId);
        if (!maybeVal.isPresent()) {
            throw new InvalidOperationException("No account to survey record");
        }
        AccountToSurvey accountToSurvey = maybeVal.get();
        accountToSurvey.setSubmitted(true);

        Survey survey = getSurvey(surveyId);
        survey.setParticipantNum(survey.getParticipantNum() + 1);
        surveyRepository.save(survey);
        accountToSurveyRepository.save(accountToSurvey);
        Account account = getAccountById(accoundId);
        surveyHubEmailService.sendCreateSurveyComfirmMail(account.getEmail(), surveyId);
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

    public void sendInvitation(String surveyId, List<Invitation> invitations) {
        Survey survey = getSurvey(surveyId);
        survey.setInvitationNum(survey.getInvitationNum() + invitations.size());
        for (Invitation invitation: invitations) {
            surveyHubEmailService.sendInvitationMail(invitation);
        }
        surveyRepository.save(survey);
    }
}
