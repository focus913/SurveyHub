<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">


    <script src="https://cdn.anychart.com/releases/8.2.1/js/anychart-base.min.js" type="text/javascript"></script>

    <script>
        <%@ page import="edu.sjsu.cmpe275.domain.SurveyResult" %>

        var startTime = "${surveyResult.startTime}";
        var endTime = "${surveyResult.endTime}";
        var participants = "${surveyResult.participants}";
        var participationRate = "${surveyResult.participationRate}";

        console.log(startTime);
        console.log(endTime);
        console.log(participants);
        console.log(participationRate);

        // var mcqToCount = {};

        // display multiple choice
        var mcquestions = [];
        var mcanswers = [];
        <c:forEach items="${surveyResult.mcq}" var="mcq">
            var i = 0;
            mcquestions.push("${mcq.key}");
            mcanswers.push(${mcq.value});

            console.log("Question: ", "${mcq.key}");
            console.log("Data: ", ${mcq.value});

            anychart.onDocumentLoad(function () {

                var json = ${mcq.value};
                // create chart from json config
                var chart = anychart.fromJson(json);
                // display a chart
                chart.title("${mcq.key}");
                chart.container('container' + i).draw();

            });
            i += 1;
        </c:forEach>


    </script>


</head>

<body>

<div class="container">
    <!-- result header -->
    <div class="row">
        <h1>Survey Result</h1>
    </div>
    <div class="row">
        <table class="table">
            <tbody>
            <tr>
                <th scope="row">Start Time</th>
                <td id="startTime"></td>
            </tr>
            <tr>
                <th scope="row">End Time</th>
                <td id="endTime"></td>
            </tr>
            <tr>
                <th scope="row">Number of Participants</th>
                <td id="participants"></td>
            </tr>
            <tr>
                <th scope="row">Participation Rate</th>
                <td id="participationRate"></td>
            </tr>
            </tbody>
        </table>


        <script>

            document.getElementById("startTime").innerHTML = startTime;
            document.getElementById("endTime").innerHTML = endTime;
            document.getElementById("participants").innerHTML = participants;
            document.getElementById("participationRate").innerHTML = participationRate;

        </script>

    </div>

    <!-- display rate question
    -- use table, <th> for question title <td> for rate of that question
    -->
    <div id="responserate" class="row"></div>
    <script>
        var str = '<table class="table"><thead><tr><th scope="col">#</th><th scope="col">Response Rate</th></tr></thread><tbody>';
        <%--var s = "${surveyResult.responseRates}";--%>
        <%--console.log("s:", s);--%>

        <c:forEach items="${surveyResult.responseRates}" var="responseRates">
        console.log(${responseRates.key});
        str += '<tr><td>' + ${responseRates.key} + '</td><td>' + "${responseRates.value}" + '</td></tr>';
        </c:forEach>
        str += '</tbody></table>';
        console.log(str);
        document.getElementById("responserate").innerHTML = str;
    </script>


    <hr>

    <!-- display short answer
    -- use list group, each question takes one row
    -->
    <div id="shortanswer" class="row"></div>
    <script>
        // display short answer
        var saquestions = [];

        // var saanswers = $('#shortanswer');

        var str = '<table class="table"><thead>' +
            '<tr><th scope="col">Question</th><th scope="col">Answers</th></tr>' +
            '</thead><tbody>';
        <c:forEach items="${surveyResult.textAnswers}" var="textAnswers">

            console.log("Questions: ", "${textAnswers.key}");
            console.log("Data: ", "${textAnswers.value}");

            saquestions.push("${textAnswers.key}");

            str += '<tr><th scope="row">' + "${textAnswers.key}" + '</th>';

                <c:forEach items="${textAnswers.value}" var="answer">
                    str += '<td>' + "${answer}" + '</td>';
                </c:forEach>

            str += '</tr>';
            console.log(str);

        </c:forEach>
        str += '</tbody></table>';
        document.getElementById("shortanswer").innerHTML = str;

    </script>


    <hr>


    <!-- display multiple choice -->

    <div id="container1" style="width: 500px; height: 400px;"></div>
    <div id="container2" style="width: 500px; height: 400px;"></div>
    <div id="container3" style="width: 500px; height: 400px;"></div>
    <%--<div id="container4" style="width: 500px; height: 400px;"></div>--%>
    <%--<div id="container5" style="width: 500px; height: 400px;"></div>--%>
    <%--<div id="container6" style="width: 500px; height: 400px;"></div>--%>
    <%--<div id="container7" style="width: 500px; height: 400px;"></div>--%>
    <%--<div id="container8" style="width: 500px; height: 400px;"></div>--%>
    <%--<div id="container9" style="width: 500px; height: 400px;"></div>--%>
    <%--<div id="container10" style="width: 500px; height: 400px;"></div>--%>


</div>







</body>
</html>