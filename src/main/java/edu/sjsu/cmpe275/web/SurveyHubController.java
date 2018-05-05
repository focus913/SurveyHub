package edu.sjsu.cmpe275.web;

import edu.sjsu.cmpe275.domain.Question;
import edu.sjsu.cmpe275.domain.Survey;
import edu.sjsu.cmpe275.exceptions.InvalidOperationException;
import edu.sjsu.cmpe275.service.SurveyHubService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class SurveyHubController {

    private final static String PUBLISH = "publish";
    private final static String UNPUBLISH = "unpublish";
    @Autowired
    SurveyHubService surveyHubService;

    @PostMapping(path = "/account/{accountId}/survey", produces = {"application/json"})
    public @ResponseBody Survey createSurvey(@PathVariable("accountId") String accountId,
                                             @RequestBody Survey survey) {
        return surveyHubService.createSurvey(accountId, survey);
    }

    @PutMapping(path = "/survey/{surveyId}/question", produces = {"application/json"})
    public void saveQuestions(@PathVariable("surveyId") String surveyId,
                              @RequestBody List<Question> questions) {
        surveyHubService.saveQuestions(surveyId, questions);
    }

    @PutMapping(path = "/survey/{surveyId}")
    public void updateSurveyStatus(@PathVariable("surveyId") String surveyId,
                              @RequestParam String action) {
        if (PUBLISH.equals(action)) {
            surveyHubService.publishSurvey(surveyId);
        } else if (UNPUBLISH.equals(action)) {
            surveyHubService.unpublishSurvey(surveyId);
        } else {
            throw new InvalidOperationException("Invalid survey operation");
        }
    }

    @GetMapping(path = "/survey/{surveyId}")
    public @ResponseBody Survey getSurvey(@PathVariable("surveyId") String surveyId) {
        return surveyHubService.getSurvey(surveyId);
    }
}
