package edu.sjsu.cmpe275.domain;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.*;

public class SurveyResult {
    private String startTime;
    private String endTime;
    private int participants;
    private double participationRate;

    private static final String JSON_PREFIX = "{\"chart\":{\"type\": \"pie\", \"data\":[";
    private static final String JSON_SUFFIX = "]}}";

    public Map<String, String> getMcq() {
        return mcq;
    }

    public void setMcq(Map<String, String> mcq) {
        this.mcq = mcq;
    }

    private Map<String, String> mcq = new HashMap();
    private Map<String, Map<String, Integer>> mcqToCount = new HashMap<>();
    private Map<String, List<String>> textAnswers = new HashMap<>();
    private Map<Integer, String> responseRates = new LinkedHashMap<>();

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


    public void prepareMCQ() {
        for (Map.Entry<String, Map<String, Integer>> each: mcqToCount.entrySet()) {
            String key = each.getKey();
            String jsonContent = JSON_PREFIX;
            int size = each.getValue().size();
            int count = 0;

            for(Map.Entry<String, Integer> entry: each.getValue().entrySet()) {
                count++;
                jsonContent += "[\"" + entry.getKey() + "\", " + entry.getValue().toString() + "]";
                if (count != size) {
                    jsonContent += ", ";
                }
            }

            jsonContent += JSON_SUFFIX;

            mcq.put(key, jsonContent);
        }
    }

    public void setTextAnswers(Map<String, List<String>> textAnswers) {
        this.textAnswers = textAnswers;
    }

    public Map<Integer, String> getResponseRates() {
        return responseRates;
    }

    public void setResponseRates(Map<Integer, String> responseRates) {
        this.responseRates = responseRates;
    }
}
