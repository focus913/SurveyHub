<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>The example of showing survey as a popup window, jQuery Survey Library Example</title>
    <script src="https://unpkg.com/jquery"></script>
    <script src="https://surveyjs.azureedge.net/1.0.20/survey.jquery.js"></script>
    <link href="https://surveyjs.azureedge.net/1.0.20/survey.css" type="text/css" rel="stylesheet"/>


</head>
<body>
<div id="surveyElement"></div>
<div id="surveyResult"></div>

<script>
    <%@ page import="edu.sjsu.cmpe275.domain.Survey" %>


    var surveyId = "${surveyGeneral.surveyId}";
    console.log(surveyId);
    var cjson = [];

    <c:forEach items="${surveyGeneral.questions}" var="question">
    console.log(${question.questionContent});

    cjson.push(${question.questionContent});
    console.log(cjson);

    </c:forEach>


    console.log(cjson);


    var djson = {};
    djson.questions = cjson;


    /*   $(document).ready(function(urlString){
           $.ajax({
               url: urlString,
               type: "GET",
               success: function(data) {
                   console.log(data);
                   window.survey = new Survey.Model(json);
               }, //data holds {success:true} - see below
               error: function(error) {
                   console.log(error);
                   errorMsg = JSON.parse(error.responseText);}
           });
       })*/
</script>

<script>
    var surveyValueChanged = function(sender, options) {
        var el = document.getElementById(options.name);
        if (el) {
            el.value = options.value;

            console.log(el);
        }
    };



    Survey
        .StylesManager
        .applyTheme("default");

    /*
        var json = {
            questions: [{
                type: "checkbox",
                name: "car",
                title: "What car are you driving?",
                isRequired: true,
                colCount: 4,
                choices: [
                    "None",
                    "Ford",
                    "Vauxhall",
                    "Volkswagen",
                    "Nissan",
                    "Audi",
                    "Mercedes-Benz",
                    "BMW",
                    "Peugeot",
                    "Toyota",
                    "Citroen"
                ]
            }]
        };
    */

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

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "/survey/answer");
            xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
            xhr.send(JSON.stringify(sResult));

            document
                .querySelector('#surveyResult')
            /*.innerHTML = "result: " + JSON.stringify(result.data);*/
        });

    /*    survey.data = {
            name: 'John Doe',
            email: 'johndoe@nobody.com',
            car: ['Ford']
        };*/

    $("#surveyElement").Survey({
        model: survey,
        onValueChanged: surveyValueChanged
    });
</script>

</body>

</html>