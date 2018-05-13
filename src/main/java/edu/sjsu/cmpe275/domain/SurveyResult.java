package edu.sjsu.cmpe275.domain;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SurveyResult {
    private String startTime;
    private String endTime;
    private int participants;
    private double participationRate;

    private Map<String, Map<String, Integer>> mcqToCount = new HashMap<>();
    private Map<String, List<String>> textAnswers = new HashMap<>();
    private Map<Integer, Double> responseRates = new LinkedHashMap<>();

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public int getParticipants() {
        return participants;
    }

    public void setParticipants(int participants) {
        this.participants = participants;
    }

    public double getParticipationRate() {
        return participationRate;
    }

    public void setParticipationRate(double participationRate) {
        this.participationRate = participationRate;
    }

    public Map<String, Map<String, Integer>> getMcqToCount() {
        return mcqToCount;
    }

    public void setMcqToCount(Map<String, Map<String, Integer>> mcqToCount) {
        this.mcqToCount = mcqToCount;
    }

    public Map<String, List<String>> getTextAnswers() {
        return textAnswers;
    }

    public void setTextAnswers(Map<String, List<String>> textAnswers) {
        this.textAnswers = textAnswers;
    }

    public Map<Integer, Double> getResponseRates() {
        return responseRates;
    }

    public void setResponseRates(Map<Integer, Double> responseRates) {
        this.responseRates = responseRates;
    }
}
