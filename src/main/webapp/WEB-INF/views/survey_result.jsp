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

        var mcqToCount = {};
        var textAnswers = {};
        var responseRates = {};




        /*
        // display multiple choice
        anychart.onDocumentLoad(function () {
            // create an instance of a pie chart
            var chart = anychart.pie();
            // set the data
            chart.data([
                ["Chocolate", 5],
                ["Rhubarb compote", 2],
                ["Crêpe Suzette", 2],
                ["American blueberry", 2],
                ["Buttermilk", 1]
            ]);
            // set chart title (question title)
            chart.title("Top 5 pancake fillings");
            // set the container element 
            chart.container("container");
            // initiate chart display
            chart.draw();
        });
        */
        

    </script>


</head>

<body>

<div class="container">
    <!-- result header -->
    <div class="row">
        <h1>Survey Result</h1>
    </div>
    <div class="row">
        <div class="col-3">
            <h2>Start Time:</h2>
            <p id="startTime"></p>

            <script>

                document.getElementById("startTime").innerHTML = startTime;

            </script>
        </div>
        <div class="col-3">
            <h2>End Time:</h2>
            <p id="endTime"></p>

            <script>

                document.getElementById("endTime").innerHTML = endTime;

            </script>
        </div>
        <div class="col-3">
            <h2>Number of Participants:</h2>
            <p id="participants"></p>

            <script>

                document.getElementById("participants").innerHTML = participants;

            </script>
        </div>

        <div class="col-3">
            <h2>Participation Rate:</h2>
            <p id="participationRate"></p>

            <script>

                document.getElementById("participationRate").innerHTML = participationRate;

            </script>
        </div>
    </div>


    <!-- display short answer
    -- use list group, each question takes one row
    -->
    <div class="row" id="resultHeader">
        <h2 id="saTitle"></h2>
        <ul id="saAnswer" class="list-group"></ul>
        <script>

        </script>
    </div>

    <!-- display multiple choice
    <div id="container" style="width: 500px; height: 400px;"></div>-->
















    <!-- display rate question
    -- use table, <th> for question title <td> for rate of that question
    -->
    <div class="row">

    </div>


</div>





</body>
</html>