# CMPE-275 Term Project Survey Service

### Entities
---
```
CREATE TABLE account (
	account_id VARCHAR(256) PRIMARY KEY,
	email VARCHAR(128),
	password VARCHAR(256),
	type INT, // surveyor/surveyee
	verify_code VARCHAR(256),
	verified BOOL
);

CREATE TABLE survey (
	survey_id VARCHAR(256) PRIMARY KEY,
	creator VARCHAR(256) FOREIGN KEY,
	survey_type INT,
	status INT, (Editing, Published, Closed)
	expire_time DATE
);

CREATE TABLE question (
	id VARCHAR(256) PRIMARY KEY,
	survey_id VARCHAR(256),
	content_json BLOB, // maybe blob
);

CREATE TABLE answer (
	survey_id   VARCHAR(256),
	question_id VARCHAR(256),
	account_id VARCHAR(256),
	content_json BLOB
);

CREATE TABLE invitation (
	url TEXT,
	survey_id VARCHAR(256),
	to_email VARCHAR(256),
	status INT
)

CREATE TABLE surveyee_register (
	account_id VARCHAR(256),
	survey_id VARCHAR(256)
)

```

### Data Structure
---
```
class Account {
	String id;
	String email;
	String password;
	Type type;
	String verifyCode;
	Boolean verified;

	// ManyToMany
	Set<Survey>
};

class Survey {
	String survey_id;
	Type type;
	Status status;
	Date expireTime;

	OneToMany
	Set<Invitation> invitation;

	// OneToMany
	Set<Question> questions;

	//ManyToMany
	Set<Account> participants;
}

class Invitation {
	String url;
	// ManyToOne
	String survey_id;
	Status status;
}

class Question {
	String question_id;
	Type type;
	//ManyToOne
	String survey_id;
	String content;
}

class Answer {
	Type type;
	String survey_id;
	String question_id;
	String account_id;
	String content;
}

class SurveyResult {
	Date startTime;
	Date endTime;
	int numOfParticipants;
	double ParticipateRate;
	Set<QuestionMetric> metrics;
}

class QuestionMetrics {

}
```
### API
---
```
GET
/account/{accountId}
Return Account Json, HTTP 200/404

GET
/account/{accountId}/surveys
Return All Surveys in Json, HTTP 200

POST
/account?email=xxx&password=yyy&type=xxx
Return HTTP 204

POST
/verify?accountId=xxx&code=yyy
Return HTTP 204

GET
/survey/{surveyId}?accountId=xxx
Return Survey for surveyor or surveyee in Json, HTTP 200/404

POST
/account/{accountId}/survey
Return HTTP 200

PUT
/survey/{surveyId}?action={extend/close/publish/unpublish}&dueDate=xxx
Return HTTP 200

GET
/survey/{surveyId}
Return HTTP 200

PUT
/survey{surveyId}/question
Json Body of question list

DELETE
/question/{questionId}

PUT
/answer?surveyId=xxx&accountId=yyy
Return HTTP 200

GET
/answer?survey_id=xxx[&account_id=zzz]
Return HTTP 200

POST
/register_surveyee?accountId=xxx&surveyId=yyy
Return HTTP 204

POST
/invitation?surveyId=xxx&emails=aa,bb,cc

POST
/confirm?email=xxx

GET
/invitation/{invitation_url}
Return HTTP 200/404

POST
/submit/surveyId=xxx?accountId=yyy
Return HTTP 204
```