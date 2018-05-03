# CMPE-275 Term Project Survey Service

### Entities
---
```
CREATE TABLE account (
	account_id VARCHAR(256) PRIMARY KEY,
	email VARCHAR(128),
	password VARCHAR(256),
	type INT, // surveyor/surveyee
	verified BOOL
);

CREATE TABLE survey (
	survey_id VARCHAR(256) PRIMARY KEY,
	creator VARCHAR(256) FOREIGN KEY,
	survey_type INT,
	status INT, (Editing, Published, Completed, Closed, Expired)
	expire_time DATE
);

CREATE TABLE questions (
	id VARCHAR(256) PRIMARY KEY,
	survey_id VARCHAR(256),
	content_json BLOB, // maybe blob
);

CREATE TABLE answers (
	survey_id   VARCHAR(256),
	question_id VARCHAR(256),
	account_id VARCHAR(256),
	content_json BLOB
);

CREATE TABLE invitations (
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
	Account account;
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

	//ManyToOne
	String survey_id;
	String content;
}

class Answer {
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
/account
Return HTTP 204

POST
/verify?accountId=xxx&code=yyy
Return HTTP 204

GET
/survey/{surveyId}?accountId=xxx
Return Survey for surveyor or surveyee in Json, HTTP 200/404

PUT
/survey/{surveyId}
Return HTTP 200

UPDATE
/survey/{surveyId}?endTime=xxx
Return HTTP 200

PUT
/answer?surveyId=xxx&questionId=yyy&accountId=zzz
Return HTTP 200

POST
/register_surveyee?accountId=xxx&surveyId=yyy
Return HTTP 204

POST
/invitation?surveyId=xxx&email=yy,zz,xx

GET
/invitation/{invitation_url}
Return HTTP 200/404

POST
/submit/surveyId=xxx?accountId
Return HTTP 204
```