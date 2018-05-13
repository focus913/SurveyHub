<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Survey</title>
    <script src="https://unpkg.com/jquery"></script>
    <script src="https://surveyjs.azureedge.net/1.0.20/survey.jquery.js"></script>
    <link href="https://surveyjs.azureedge.net/1.0.20/survey.css" type="text/css" rel="stylesheet"/>

    <script src="https://unpkg.com/jquery-bar-rating"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
    <!-- Themes -->
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-1to10.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-movie.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-square.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-pill.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-reversed.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bars-horizontal.css">

    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/fontawesome-stars.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/css-stars.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/bootstrap-stars.css">
    <link rel="stylesheet" href="https://unpkg.com/jquery-bar-rating@1.2.2/dist/themes/fontawesome-stars-o.css">
    <script src="https://unpkg.com/surveyjs-widgets"></script>


</head>
<body>
<div id="surveyElement"></div>
<div id="surveyResult"></div>

<script>
    <%@ page import="edu.sjsu.cmpe275.domain.Survey" %>
    <%@ page import="edu.sjsu.cmpe275.domain.Answer" %>
    <%@ page import="edu.sjsu.cmpe275.domain.Question" %>

    var surveyId = "${surveyGeneral.surveyId}";

    var surveyName = "${surveyGeneral.surveyName}";

    var rJson = {
        surveyId : surveyId
    };

    var cjson = [];

    var initData = {};
    <c:forEach items="${surveyGeneral.questions}" var="question">
    console.log(${question.questionContent});
    cjson.push(${question.questionContent});
    console.log("Inside for loop", cjson);
    var questionId = "${question.questionId}";
    console.log("question id: ", questionId);
    <c:forEach items="${question.answers}" var="answer">
    console.log("answer surveyId: ", surveyId);
    var answerContent = "${answer.content}";
    console.log("answer content: ", answerContent);
    initData[questionId] = answerContent;
    </c:forEach>
    </c:forEach>

    console.log("outside for loop", cjson);

    function loadState(survey) {
        survey.data = initData;
        console.log("survey.data = ", initData);
    }

    Survey
        .StylesManager
        .applyTheme("default");


    var djson = {};
    djson.elements = cjson;
    djson.title = surveyName;


    console.log(djson);

    var surveyValueChanged = function(sender, options) {
        var el = document.getElementById(options.name);
        if (el) {
            el.value = options.value;
            console.log("when click on element: ",el);
        }
    };

    window.survey = new Survey.Model(djson);
    var sResult = [];

    survey.onValueChanged.add(function (sender, options) {
        var mySurvey = sender;
        console.log(sender);
        console.log("options", options);
        var questionName = options.name;
        var newValue = options.value;
        console.log("questionName", questionName);

        console.log("newValue", newValue);

        console.log("sender data is ", sender.data);
        sResult = sender.data;
    });



    survey
        .onComplete
        .add(function () {
            console.log("sResult is ", sResult);
            rJson.content = sResult;

            console.log("survey", survey);

            console.log("stringify rJson: ", JSON.stringify(rJson));

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "/survey/answer");
            xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
            xhr.send(JSON.stringify(rJson));

            document
                .querySelector('#surveyResult')
        });

    //Load the initial state
    loadState(survey);

    $("#surveyElement").Survey({
        model: survey,
        onValueChanged: surveyValueChanged
    });
</script>

</body>

</html>
