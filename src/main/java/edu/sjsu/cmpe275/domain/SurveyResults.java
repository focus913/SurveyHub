package edu.sjsu.cmpe275.domain;

import javax.persistence.Entity;

@Entity
public class SurveyResults {
    private String startTime;
    private String endTime;
    private int participants;
    private double participationRate;

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
}
