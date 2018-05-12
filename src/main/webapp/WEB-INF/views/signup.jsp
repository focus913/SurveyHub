<script
        src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<html>
<head>
    <!-- Material Design fonts -->

    <link rel="stylesheet" href="https://unpkg.com/bootstrap-material-design@4.1.1/dist/css/bootstrap-material-design.min.css"
          integrity="sha384-wXznGJNEXNG1NFsbm0ugrLFMQPWswR3lds2VeinahP8N0zJw9VWSopbjv2x7WCvX" crossorigin="anonymous">
    <!--
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet"
          href="https://code.getmdl.io/1.2.1/material.indigo-pink.min.css">-->
    <script defer src="https://code.getmdl.io/1.2.1/material.min.js"></script>

    <!--
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
            integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>


    <script src="https://unpkg.com/popper.js@1.12.6/dist/umd/popper.js"
            integrity="sha384-fA23ZRQ3G/J53mElWqVJEGJzU0sTs+SvzG8fXVWP+kJQ1lwFAOkcUOysnlKJC33U" crossorigin="anonymous"></script>

    <script src="https://unpkg.com/bootstrap-material-design@4.1.1/dist/js/bootstrap-material-design.js"
            integrity="sha384-CauSuKpEqAFajSpkdjv3z9t8E7RlpJ1UP0lKM/+NdtSarroVKu069AlsRPKkFBz9" crossorigin="anonymous"></script>

    <script>$(document).ready(function() { $('body').bootstrapMaterialDesign(); });</script>-->
</head>

<script>
    function showSnackBar() {
        // Get the snackbar DIV
        var x = document.getElementById("snackbar");

        // Add the "show" class to DIV
        x.className = "show";

        // After 3 seconds, remove the show class from DIV
        setTimeout(function() {
            x.className = x.className.replace("show", "");
        }, 3000);
    }


    function signUp(url, next) {
        console.log("This is the URL"+url);
        $.ajax({
                type : "POST",
                url : url,
                data : $("#createUserForm").serialize(),
                success : function(data) {
                },
                error : function(error) {
                    console.log(error);
                    alert("go to " + error.responseText);
                    errorMsg = JSON.parse(error.responseText);
                },
                statusCode : {
                    201 : function() {
                        window.location = next;
                    },
                    400 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    },
                    500 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    },
                    404 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    },
                    409 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    }
                },
                complete : function(e) {
                    if (e.status == 200) {

                    } else {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    }
                }
            });
    }

    function login(url, next) {
        console.log("next: " + next)
        $
            .ajax({
                type : "POST",
                url : url,
                data : $("#accountLoginForm").serialize(),
                success : function(data) {
                },
                error : function(error) {
                    console.log(error);
                    errorMsg = JSON.parse(error.responseText);
                },
                statusCode : {
                    200 : function() {
                        window.location = next;
                    },
                    400 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    },
                    500 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    },
                    404 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    },
                    403 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                    },
                    401 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    },
                    409 : function() {
                        document.getElementById('snackbar').innerHTML = errorMsg.errorMessage;
                        showSnackBar();
                    }
                },
                complete : function(e) {
                    if (e.status == 200) {

                    }
                }
            });
    }

    function validateMyFields(){

        var firstName = document.getElementById("firstName").value;
        var lastName = document.getElementById("lastName").value;
        var email = document.getElementById("signupEmail").value;
        var password = document.getElementById("password").value;

        if(firstName == "" || lastName == "" || email == "" || password == ""){
            alert("Missing required fields");
            return 0;
        }
        return 1;
    }

    $(document).ready(function() {
        var sjsuEmailValue ="SJSU.EDU";
        var errorMsg;

        $("#createUserForm").submit(function(e) {
            e.preventDefault();

            var result =  parseInt(validateMyFields());
            if(result == 1){

                var url = "/account/signup";
                var next = "/account/verify";
                signUp(url, next);
            }
        });

        $("#accountLoginForm").submit(function(e) {
            e.preventDefault();

            var url = "/account/login";
            var next;
            console.log(document.getElementById("loginType").value);
            if (document.getElementById("loginType").value == 0) {
                next = "/account/surveyor";
            } else {
                next = "/account/surveyee";
            }
            login(url, next);
        });

        $("#buttonClick").click(function(e) {
            searchGroups();
        });
    });
</script>
<style>

</style>
<body>
<div class="container">
    <div class="row justify-content-md-center h-20">
        <h1 style="text-align:center;">Survey Hub</h1>
    </div>
    <hr>
    <div class="row">
        <!-- sign up form -->
        <div class="col-5 justify-content-md-center">
            <form id="createUserForm">
                <div class="form-group">

                    <div id="firstform">

                        <div class="form-group">
                            <h2 class="mdl-card__title-text" >Sign Up</h2>
                        </div>

                        <div class="form-group">
                            <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
                                <label class="bmd-label-floating" for="firstname" requird>First Name</label>
                                <input class="form-control" type="text" id="firstName" name="firstName">
                            </div>
                            <div class="form-group">
                                <label class="bmd-label-floating" for="lastname">Last Name</label>
                                <input class="form-control" type="text" id="lastName" name="lastName">
                            </div>
                            <div class="form-group">
                                <label class="bmd-label-floating" for="signupEmail">Username</label>
                                <input class="form-control" type="email" id="signupEmail" name="email">
                                <span class="bmd-help">Not a Valid Email</span>
                            </div>

                            <div class="form-group">
                                <label class="bmd-label-floating" for="password">Password</label>
                                <input class="form-control" type="password" id="password" name="password" pattern="((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%]).{6,20})">
                                <span class="bmd-help">Password must contain Uppercase,lowercase,special character & a Number. Length between
                        6 and 20</span>
                            </div>
                            <div class="form-group">
                                <label for="loginType" class="bmd-label-floating">Account Type</label>
                                <select class="form-control" id="type" name="type">
                                    <option value="0">Surveyor</option>
                                    <option value="1">Surveyee</option>
                                </select>
                            </div>

                            <button class="btn btn-primary btn-raised" type="submit">
                                Create
                            </button>
                        </div>


                    </div>
                </div>
            </form>

        </div>

        <div class="col-2"></div>

        <!-- login form -->
        <div class="col-5 justify-content-md-center">
            <div id="secondform">
                    <div class="mdl-card mdl-shadow--6dp">
                        <div class="mdl-card__title mdl-color--primary mdl-color-text--white">
                            <h2 class="mdl-card__title-text">Sign In</h2>
                        </div>
                        <form id="accountLoginForm">
                            <div class="form-group">
                                <div class="form-group">
                                    <label for="loginType" class="bmd-label-floating">Account Type</label>
                                    <select class="form-control" id="loginType" name="loginType">
                                        <option value="0">Surveyor</option>
                                        <option value="1">Surveyee</option>
                                    </select>
                                </div>
                            </div>
                            <!--
                            <div class="form-group">
                                <label class="bmd-label-floating" for="loginType">Account Type</label>
                                <input class="form-control" type="number" id="loginType" name="loginType">
                                <span class="bmd-help">Enter 0 or 1</span>
                            </div>
                            -->
                            <div class="form-group">
                                <label class="bmd-label-floating" for="loginEmail">Username</label>
                                <input class="form-control" type="email" id="loginEmail" name="email">
                                <span class="bmd-help">Not a Valid SJSU Email</span>
                            </div>

                            <div class="form-group">
                                <label class="bmd-label-floating" for="password">Password</label>
                                <input class="form-control" type="password" id="password" name="password" pattern="((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%]).{6,20})" >
                                <span class="bmd-help">Password must contain Uppercase,lowercase,special character & a Number. Length between
                            6 and 20</span>
                            </div>

                            <button class="btn btn-primary btn-raised" type="submit">
                                Log In</button>

                        </form>

                    </div>
                </main>

            </div>

        </div>
    </div>


</div>





<!--
<div id="verticle-line"></div>
<div id="or">
    <h3>Or</h3>
</div>
<div id="snackbar">Some text some message..</div>
</div>
-->
</body>
</html>