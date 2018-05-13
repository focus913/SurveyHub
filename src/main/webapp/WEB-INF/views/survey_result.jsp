<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

    <script src="https://cdn.anychart.com/releases/8.2.1/js/anychart-base.min.js" type="text/javascript"></script>

    <script>
        <%@ page import="edu.sjsu.cmpe275.domain.SurveyResult" %>



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

        

    </script>

</head>

<body onload="">

<div>
    <!-- header -->
    <div>
        <h1>Survey Title</h1>
    </div>

    <!-- display multiple choice -->
    <div id="container" style="width: 500px; height: 400px;"></div>

    <!-- display short answer
    -- use list group, each question takes one row
    -->
    <div class="row">

    </div>

    <!-- display rate question
    -- use table, <th> for question title <td> for rate of that question
    -->
    <div class="row">

    </div>


</div>





</body>
</html>