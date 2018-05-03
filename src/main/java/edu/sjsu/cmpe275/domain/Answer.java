package edu.sjsu.cmpe275.domain;

import javax.persistence.*;

@Entity
@Table(name = "answer")
public class Answer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(name = "survey_id", nullable = false)
    private String surveyId;

    @Column(name = "question_id", nullable = false)
    private String questionId;

    @Column(name = "account_id")
    private String accountId;

    @Column(name = "content", nullable = false)
    @Lob
    private String content;
}
