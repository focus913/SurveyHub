<html>
<head>
    <meta charset="utf-8"/>

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script defer src="https://code.getmdl.io/1.2.1/material.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.17.1/moment-with-locales.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>


    <!--<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">-->
    <link rel="stylesheet" href="https://code.getmdl.io/1.2.1/material.indigo-pink.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css"/>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.43/css/bootstrap-datetimepicker.min.css" />
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

</head>

<script>

    $(document).ready(function() {

        // add question
        $("#questionContent").submit(function(e) {
            e.preventDefault();
            if(document.getElementById('questionTitle').value == '') {
                alert("Title cannot be empty");
            }
            else {
                submitQuestion();
            }
        });

        function submitQuestion() {

            var question = {
                title: document.getElementById("questionTitle").value,
                inputType: document.getElementById("surveyType").value,
                choice: [
                    document.getElementById("choice1").value,
                    document.getElementById("choice2").value,
                    document.getElementById("choice3").value,
                    document.getElementById("choice4").value
                ]
            };

            $.ajax({
                type: "POST",
                url: "/survey/question",
                data:  JSON.stringify({"questionContent" : JSON.stringify(question)}),
                dataType: "json",
                contentType: "application/json",
                success: function (data) {
                },
                error: function (error) {
                    window.errorMsg = JSON.parse(error.responseText);
                    showError(errorMsg.errorMessage);
                    console.log(error);
                },
                statusCode : {
                    200 : function() {
                        window.location = '/account/createsurvey';
                    },
                    400 : function() {
                        console.log(errorMsg);
                    },
                    500 : function() {

                    },
                    404 : function() {


                    },
                    409 : function() {
                    }
                },
                complete : function(e) {
                    if (e.status == 200) {

                    }
                }
            })

        }

    });


    // send invation
    $('#invitation').submit(function (e) {
        e.preventDefault();
        sendInvitation();
    });

    function sendInvitation() {
        $.ajax({
            type: "POST",
            url: "/",
            data: $('#invitation').serialize(),
            success: function (data) {
            },
            error: function (error) {
                window.errorMsg = JSON.parse(error.responseText);
                showError(errorMsg.errorMessage);
                console.log(error);
            },
            statusCode : {
                200 : function() {
                    window.location = '/account/createsurvey';
                },
                400 : function() {

                },
                500 : function() {

                },
                404 : function() {


                },
                409 : function() {
                }
            },
            complete : function(e) {
                if (e.status == 200) {

                }
            }

        });
    }

    // publish survey
    $('#publish').submit(function (e) {
        e.preventDefault();
        publishSurvey();
    });

    function publishSurvey() {
        $.ajax({
            type: "POST",
            url: "/survey/publish",
            data: $('#publish').serialize(),
            success: function (data) {
            },
            error: function (error) {
                window.errorMsg = JSON.parse(error.responseText);
                showError(errorMsg.errorMessage);
                console.log(error);
            },
            statusCode : {
                200 : function() {
                    window.location = '/account';
                },
                400 : function() {

                },
                500 : function() {

                },
                404 : function() {


                },
                409 : function() {
                }
            },
            complete : function(e) {
                if (e.status == 200) {

                }
            }

        });
    }




    $('#logout').click(function(e){
        console.log("clicked button");
        logOutLibrarian();
    });
    function logOutLibrarian() {
        $.ajax({
            type : "GET",
            url : "/logout",
            success : function(data) {
            },
            error: function(error){
                window.errorMsg = JSON.parse(error.responseText);
                showError(errorMsg.errorMessage);
                console.log(error);
            },
            statusCode : {
                200 : function() {
                    window.location = '/signup';
                },
                400 : function() {

                },
                500 : function() {

                },
                404 : function() {


                },
                409 : function() {
                }
            },
            complete : function(e) {
                if (e.status == 200) {

                }
            }
        });
    }


</script>

<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-4">
            Survey Ape
        </div>
        <div class="col-4">
            <button id="logout" class="mdl-button mdl-js-button mdl-js-ripple-effect" onclick="logOutLibrarian();">
                Log Out
            </button>
        </div>
    </div>

    <!--
    <div class="row justify-content-center">
        <div class="col-6">
            <form id="sa">
                <fieldset>Short Answer Question</fieldset>
                <div class="form-group">
                    <label for="questionContent" class="bmd-label-floating">Title</label>
                    <input type="text" class="form-control" id="questionContent" name="questionContent" />
                    <span>
                        <button type="submit">Add</button>
                    </span>
                </div>
            </form>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-6">
            <form id="yn">
                <fieldset>Yes or No Question</fieldset>
                <div class="form-group">
                    <label for="ynTitle" class="bmd-label-floating">Title</label>
                    <input type="text" class="form-control" id="ynTitle" name="questionContent" />
                    <button type="submit">Add</button>
                </div>
            </form>
        </div>
    </div>
    -->

    <div class="row justify-content-center">
        <div class="col-6">
            <form id="questionContent">
                <fieldset>Add Question</fieldset>
                <div class="form-group">
                    <label for="surveyType" class="bmd-label-floating">Question Type</label>
                    <select class="form-control" id="surveyType" name="surveyType">
                        <option value="1">Short Answer</option>
                        <option value="2">Yes or No</option>
                        <option value="3">Multiple Choice</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="questionTitle" class="bmd-label-floating">Title</label>
                    <input type="text" class="form-control" id="questionTitle" required/>

                    <label for="choice1" class="bmd-label-floating">Choice 1</label>
                    <input type="text" class="form-control" id="choice1" />

                    <label for="choice2" class="bmd-label-floating">Choice 2</label>
                    <input type="text" class="form-control" id="choice2" />

                    <label for="choice3" class="bmd-label-floating">Choice 3</label>
                    <input type="text" class="form-control" id="choice3" />

                    <label for="choice4" class="bmd-label-floating">Choice 4</label>
                    <input type="text" class="form-control" id="choice4" />

                </div>
                <div class="form-group">
                    <button type="submit">Add</button>
                </div>
            </form>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-6">
            <form id="invitation" class="form-inline">
                <label for="toEmail" class="bmd-label-floating"></label>
                <input type="text" class="form-control" id="toEmail" name="toEmail" required/>
                <span class="form-group bmd-form-group">
                  <button type="submit">Send Invation</button>
              </span>
            </form>
        </div>
    </div>
    <form id="publish">
        <input type="submit" name="publish" value="Publish" />
    </form>

</div>
</body>


</html>