<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<body>
<%--
<h1>Can this part show up?</h1>
--%>
<%--<h5 id="participantsNum"></h5>
<script>
    <%@ page import="edu.sjsu.cmpe275.domain.SurveyResult" %>

    var participantsNum = "${surveyR.participants}";
    document.getElementById("participantsNum").innerHTML = participantsNum;

</script>--%>

<div id="container" style="width: 500px; height: 400px;"></div>
<script src="https://cdn.anychart.com/releases/v8/js/anychart-base.min.js" type="text/javascript"></script>
<script>
    anychart.onDocumentReady(function() {
        // create a pie chart
        var chart = anychart.pie([
            ["Chocolate", 5],
            ["Rhubarb compote", 2],
            ["Crêpe Suzette", 2],
            ["American blueberry", 2],
            ["Buttermilk", 1]
        ]);
        chart.title("Top 5 pancake fillings");
        // set the container where chart will be drawn
        chart.container("container");
        //  draw the chart on the page
        chart.draw();
    });
</script>
</body>
</html>