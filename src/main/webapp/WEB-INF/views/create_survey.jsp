<html>
<head>
    <meta charset="utf-8"/>

    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script defer src="https://code.getmdl.io/1.2.1/material.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.17.1/moment-with-locales.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.43/js/bootstrap-datetimepicker.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>


    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
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

        // add short answer question
        $("#sa").submit(function(e) {
            e.preventDefault();
            if(document.getElementById('questionContent').value == '') {
                alert("Title cannot be empty");
            }
            else {
                submitQuestion();
            }
        });

        function submitQuestion() {
            $.ajax({
                type: "POST",
                url: "/survey/question",
                data: $("#sa").serialize(),
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
            })

        }

    });

    // add yes or no question
    $("#yn").submit(function(e) {
        e.preventDefault();
        if(document.getElementById('questionContent').value == '') {
            alert("Title cannot be empty");
        }
        else {
            submitQuestion();
        }
    });

    // add multiple choice question
    $("#mc").submit(function(e) {
        e.preventDefault();
        if(document.getElementById('questionContent').value == '') {
            alert("Title cannot be empty");
        }
        else {
            submitQuestion();
        }
    });


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
    <div class="row justify-content-center">
        <div class="col-8">
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
        <div class="col-8">
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


    <div class="row justify-content-center">
        <div class="col-8">
            <form id="mc">
                <fieldset>Multiple Choice Question</fieldset>
                <div class="form-group">
                    <label for="mcTitle" class="bmd-label-floating">Title</label>
                    <input type="text" class="form-control" id="mcTitle" />

                    <label for="mcA" class="bmd-label-floating">Choice A</label>
                    <input type="text" class="form-control" id="mcA" />

                    <label for="mcB" class="bmd-label-floating">Choice B</label>
                    <input type="text" class="form-control" id="mcB" />

                    <label for="mcC" class="bmd-label-floating">Choice C</label>
                    <input type="text" class="form-control" id="mcC" />

                    <label for="mcD" class="bmd-label-floating">Choice D</label>
                    <input type="text" class="form-control" id="mcD" />

                    <button type="submit">Add</button>
                </div>
            </form>
        </div>
    </div>

</div>
</body>


</html>