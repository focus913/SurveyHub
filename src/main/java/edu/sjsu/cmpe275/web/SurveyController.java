package edu.sjsu.cmpe275.web;

import edu.sjsu.cmpe275.domain.Answer;
import edu.sjsu.cmpe275.domain.Invitation;
import edu.sjsu.cmpe275.domain.Question;
import edu.sjsu.cmpe275.domain.Survey;
import edu.sjsu.cmpe275.exceptions.InvalidOperationException;
import edu.sjsu.cmpe275.service.SurveyHubService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.persistence.criteria.CriteriaBuilder;
import javax.servlet.http.HttpSession;
import java.security.InvalidParameterException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/survey")
public class SurveyController {

    private final static String PUBLISH = "publish";
    private final static String UNPUBLISH = "unpublish";
    private final static String EXTEND = "extend";
    private final static String CURRENT_SURVEY_ID = "current_survey_id";

    @Autowired
    SurveyHubService surveyHubService;

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/question")
    public void saveQuestion(@RequestBody Question question, HttpSession httpSession) {
        String surveyId = (String) httpSession.getAttribute(CURRENT_SURVEY_ID);
        List<Question> questions = new ArrayList<>();
        questions.add(question);
        surveyHubService.saveQuestions(surveyId, questions);
    }

    @PutMapping(path = "/{surveyId}/question", produces = {"application/json"})
    public void saveQuestions(@PathVariable("surveyId") String surveyId,
                              @RequestBody List<Question> questions) {
        surveyHubService.saveQuestions(surveyId, questions);
    }

    @PostMapping(path = "/publish")
    public void publishSurvey(HttpSession httpSession) {
        String surveyId = (String) httpSession.getAttribute(CURRENT_SURVEY_ID);
        surveyHubService.updateSurvyStatus(surveyId, Survey.Action.PUBLISH, null);
    }

    @PutMapping(path = "/{surveyId}")
    public void updateSurveyStatus(@PathVariable("surveyId") String surveyId,
                                   @RequestParam String action,
                                   @RequestParam String dueDateStr) {
        if (PUBLISH.equalsIgnoreCase(action)) {
            surveyHubService.updateSurvyStatus(surveyId, Survey.Action.PUBLISH, null);
        } else if (UNPUBLISH.equalsIgnoreCase(action)) {
            surveyHubService.updateSurvyStatus(surveyId, Survey.Action.UNPUBLISH, null);
        } else if (EXTEND.equalsIgnoreCase(action)) {
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

    @GetMapping(path = "/{surveyId}")
    public @ResponseBody Survey getSurvey(@PathVariable("surveyId") String surveyId) {
        return surveyHubService.getSurvey(surveyId);
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path = "/answer")
    public void saveAnswer(@ModelAttribute Answer answer) {
        List<Answer> answers = new ArrayList<>();
        answers.add(answer);
        surveyHubService.saveAnswers(answers);
    }

    @PostMapping(path = "/invitation")
    public void sendInvitation(@ModelAttribute Invitation invitation, HttpSession httpSession) {
        List<Invitation> invitations = new ArrayList<>();
        invitations.add(invitation);
        String surveyId = (String ) httpSession.getAttribute(CURRENT_SURVEY_ID);
        surveyHubService.sendInvitation(surveyId, invitations);
    }

}
