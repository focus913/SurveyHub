<html>
<head>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="https://unpkg.com/bootstrap-material-design@4.1.1/dist/css/bootstrap-material-design.min.css"
          integrity="sha384-wXznGJNEXNG1NFsbm0ugrLFMQPWswR3lds2VeinahP8N0zJw9VWSopbjv2x7WCvX" crossorigin="anonymous">

    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
            integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/popper.js@1.12.6/dist/umd/popper.js"
            integrity="sha384-fA23ZRQ3G/J53mElWqVJEGJzU0sTs+SvzG8fXVWP+kJQ1lwFAOkcUOysnlKJC33U" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/bootstrap-material-design@4.1.1/dist/js/bootstrap-material-design.js"
            integrity="sha384-CauSuKpEqAFajSpkdjv3z9t8E7RlpJ1UP0lKM/+NdtSarroVKu069AlsRPKkFBz9" crossorigin="anonymous"></script>
    <script>$(document).ready(function() { $('body').bootstrapMaterialDesign(); });</script>

</head>

<script>

    function submitQuestion() {
        console.log("call submit question function");
        $
            .ajax({


            })
    }

    $(document).ready(function () {

        $("sa").submit(function (e) {
            e.preventDefault();
            var saTitle = document.getElementById("saTitle").value;
            console.log("click submit short answer");
            console.log(saTitle);
            if(saTitle == ""){
                alert("Title cannot be empty");
            }
            else {
                submitQuestion();
            }

        })

    })

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
    <div class="row justify-content-between">
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
                <div class="form-group">
                    <fieldset>Short Answer Question</fieldset>
                    <label for="saTitle" class="bmd-label-floating">Title</label>
                    <input type="text" class="form-control" id="saTitle" />
                </div>
            </form>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-8">
            <form id="yn">
                <div class="form-group">
                    <fieldset>Yes or No Question</fieldset>
                    <label for="ynTitle" class="bmd-label-floating">Title</label>
                    <input type="text" class="form-control" id="ynTitle" />
                </div>
            </form>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-8">
            <form id="mc">
                <div class="form-group">
                    <fieldset>Multiple Choice Question</fieldset>
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
                </div>
            </form>
        </div>
    </div>
</div>
</body>


</html>