package edu.sjsu.cmpe275.web;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sjsu.cmpe275.domain.*;
import edu.sjsu.cmpe275.exceptions.InvalidOperationException;
import edu.sjsu.cmpe275.service.Constants;
import edu.sjsu.cmpe275.service.SurveyHubService;
import org.apache.tomcat.util.bcel.Const;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.InvalidParameterException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/survey")
public class SurveyController {

    @Autowired
    SurveyHubService surveyHubService;

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/question")
    public void saveQuestion(@RequestBody Question question, HttpSession httpSession) throws IOException {
        String surveyId = (String) httpSession.getAttribute(Constants.CURRENT_SURVEY_ID);
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode rootNode = objectMapper.readTree(question.getQuestionContent());
        question.setQuestionId(rootNode.get("name").asText());
        List<Question> questions = new ArrayList<>();
        questions.add(question);
        surveyHubService.saveQuestions(surveyId, questions);
    }

    @PutMapping(path = "/{surveyId}/question", produces = {"application/json"})
    public void saveQuestions(@PathVariable("surveyId") String surveyId,
                              @RequestBody List<Question> questions) {
        surveyHubService.saveQuestions(surveyId, questions);
    }

    @ResponseStatus(HttpStatus.CREATED)
    @PostMapping(path = "/publish")
    public void publishSurvey(HttpSession httpSession) {
        System.out.println("Publish survey");
        String surveyId = (String) httpSession.getAttribute(Constants.CURRENT_SURVEY_ID);
        surveyHubService.updateSurvyStatus(surveyId, Survey.Action.PUBLISH, null);
        httpSession.removeAttribute(Constants.CURRENT_SURVEY_ID);
    }

    @PutMapping(path = "/{surveyId}")
    public void updateSurveyStatus(@PathVariable("surveyId") String surveyId,
                                   @RequestParam String action,
                                   @RequestParam String dueDateStr) {
        if (Constants.PUBLISH.equalsIgnoreCase(action)) {
            surveyHubService.updateSurvyStatus(surveyId, Survey.Action.PUBLISH, null);
        } else if (Constants.UNPUBLISH.equalsIgnoreCase(action)) {
            surveyHubService.updateSurvyStatus(surveyId, Survey.Action.UNPUBLISH, null);
        } else if (Constants.EXTEND.equalsIgnoreCase(action)) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd-HH");
            Date dueDate = null;
            try {
                dueDate = format.parse(dueDateStr);
            } catch (ParseException ex) {
                throw new InvalidParameterException("Invalid time format should be yyyy-MM-dd-HH");
            }
            surveyHubService.updateSurvyStatus(surveyId, Survey.Action.EXTEND, dueDate);
        } else {
            throw new InvalidOperationException("Invalid survey operation");
        }
    }

    @GetMapping(path = "/takeSurvey")
    public String takeSurvey(@RequestParam("surveyId") String surveyId, HttpSession httpSession) {
        httpSession.setAttribute(Constants.SURVEY_TO_TAKE, surveyId);
        return Constants.TAKE_SURVEY_PAGE;
    }

    @GetMapping(path = "/getSurvey", produces = {"application/json"})
    public String getSurvey(HttpSession httpSession, ModelMap model) {
        String surveyId = (String) httpSession.getAttribute(Constants.SURVEY_TO_TAKE);
        System.out.println("GetSurvey " + surveyId);
        Survey survey = surveyHubService.getSurvey(surveyId);
        model.addAttribute("surveyGeneral", survey);
        return "survey";
    }

    // na 05/08/2018
    @GetMapping(path = "/{surveyId}")
    public String getSurvey(@PathVariable("surveyId") String surveyId, ModelMap model) {
        Survey s = surveyHubService.getSurvey(surveyId);
        model.addAttribute("surveyGeneral", s);
        return "survey";
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/answer")
    public void saveAnswer(@RequestBody String answersJson) throws IOException {
        System.out.println("Save answer");
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(answersJson);
        String surveyId = jsonNode.get(Constants.SURVEY_ID_KEY).asText();
        if (null == surveyId || surveyId.isEmpty()) {
            throw new InvalidOperationException("Empty surveyId");
        }

        JsonNode contentNode = jsonNode.get(Constants.CONTENT_KEY);
        List<Answer> answers = new ArrayList<>();
        List<String> questionIds = new ArrayList<>();
        Iterator<String> fieldNames = contentNode.fieldNames();

        while (fieldNames.hasNext()) {
            String questionId = fieldNames.next();
            System.out.println(questionId);
            questionIds.add(questionId);
            Answer answer = new Answer();
            answer.setSurveyId(surveyId);
            if (contentNode.get(questionId).isArray()) {
                if (contentNode.get(questionId).iterator().hasNext())
                    answer.setContent(contentNode.get(questionId).toString());
            } else {
                answer.setContent(contentNode.get(questionId).asText());
            }
            answers.add(answer);
        }
        surveyHubService.saveAnswers(answers, questionIds);
    }

    @PostMapping(path = "/invitation")
    public void sendInvitation(@ModelAttribute Invitation invitation, HttpSession httpSession) {
        String surveyId = (String) httpSession.getAttribute(Constants.CURRENT_SURVEY_ID);
        invitation.setUrl(invitation.getUrl() + "/survey/takeSurvey" + "?surveyId=" + surveyId);
        List<Invitation> invitations = new ArrayList<>();
        invitations.add(invitation);
        surveyHubService.sendInvitation(surveyId, invitations);
    }

    @GetMapping(path = "/{surveyId}/result")
    public String getResult(@PathVariable("surveyId") String surveyId, ModelMap model) throws IOException {
        Survey survey = surveyHubService.getSurvey(surveyId);
        SurveyResult surveyResult = new SurveyResult();
        surveyResult.setStartTime(survey.getCreateTime().toString());
        surveyResult.setEndTime(survey.getExpireTime().toString());
        surveyResult.setParticipants(survey.getParticipantNum());
        surveyResult.setParticipationRate((double) survey.getParticipantNum() / (double) survey.getInvitationNum());

        Map<String, Map<String, Integer>> mcqToCount = surveyResult.getMcqToCount();
        Map<String, List<String>> textAnswers = surveyResult.getTextAnswers();
        Map<Integer, Double> responseRates = surveyResult.getResponseRates();

        int questionNumber = 1;
        for (Question question: survey.getQuestions()) {
            String content = question.getQuestionContent();
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode jsonNode = objectMapper.readTree(content);
            String questionContent = jsonNode.get(Constants.QUESTION).asText();
            String type = jsonNode.get(Constants.QUESTION_TYPE).asText();

            if (type.equals(Constants.MCQ)) {
                Map<String, Integer> optionsCount = new HashMap<>();
                Iterator<JsonNode> mcqOptions = jsonNode.get(Constants.MCQ_OPTIONS).iterator();

                while (mcqOptions.hasNext()) {
                    String mcqOption = mcqOptions.next().asText();
                    optionsCount.put(mcqOption, 0);
                }

                for (Answer answer: question.getAnswers()) {
                    String mcqContent = answer.getContent();
                    String[] options = mcqContent.substring(1,mcqContent.length()-1).split(",");
                    for (String option: options) {
                        String keyOption = option.substring(1, option.length()-1);
                        optionsCount.put(keyOption, optionsCount.get(keyOption)+1);
                    }
                }
                mcqToCount.put(questionContent, optionsCount);
            } else if (type.equals(Constants.TEXT)) {
                List<String> testAnswers = new ArrayList<>();
                for (Answer answer: question.getAnswers()) {
                    testAnswers.add(answer.getContent());
                }

                textAnswers.put(questionContent, testAnswers);
            }

            Double responseRate = ((double)question.getAnswers().size())/survey.getParticipantNum();
            DecimalFormat format = new DecimalFormat("##.00");

            responseRates.put(questionNumber, Double.parseDouble(format.format(responseRate).toString()));
            questionNumber++;
        }
        surveyResult.prepareMCQ();
        model.addAttribute("surveyResult", surveyResult);
        return "survey_result";
    }

    @PostMapping(path = "/submit")
    public void submitSurvey(HttpSession httpSession) {
        String surveyId = (String) httpSession.getAttribute(Constants.SURVEY_TO_TAKE);
        if (null == surveyId || surveyId.isEmpty()) {
            System.out.println("You need to take a survey firstly");
            throw new InvalidOperationException("No survey been taken");
        }
        String accountId = (String) httpSession.getAttribute(Constants.LOGIN_USER_KEY);
        surveyHubService.submitSurvey(surveyId, accountId);
    }
}
