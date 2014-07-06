var CBApiBase;
var CBMerchantID;

function CBSale(amount,transaction_id) {

//    CBjQ = window.jQuery;
    CBjQ = window.jq1111;
    CBjQ(document).ready(function($CB) {

        var path = GetCookie("cbwpath");

        var method = "sale";

        var ajxDataObj = new Object();

        if (CBMerchantID) {
            ajxDataObj.merchant_id = CBMerchantID;
        }

        if (path) {
            ajxDataObj.path = path;
        }

        if (amount) {
            ajxDataObj.amount = amount;
        }

        if (transaction_id) {
            ajxDataObj.transaction_id = transaction_id;
        }

        //  Make sure the path, amount, and merchant are present and not blank.
        //  These are mandatory inputs.  Invalid values will be sorted out by
        //  the server.
        if (path && path != "" && amount && amount != "" && CBMerchantID && CBMerchantID != "") {

            var data_url = CBApiBase + method;

            var reqObj = $CB.ajax({
                type: 'POST',
                url: data_url,
                data: ajxDataObj,
                timeout: 30000,
                dataType: "jsonp",
                success: function(data) {
                },
                error: function(data, status, xhr) {
                },
                complete: function(jqXHR, textStatus) {
                }

            })

        }

    })

    function GetCookie(check_name) {
      
        // first we'll split this cookie up into name/value pairs
        // note: document.cookie only returns name=value, not the other components
        var a_all_cookies = document.cookie.split( ';' );
        var a_temp_cookie = '';
        var cookie_name = '';
        var cookie_value = '';
        var b_cookie_found = false; // set boolean t/f default f

        for ( i = 0; i < a_all_cookies.length; i++ ) {

            // now we'll split apart each name=value pair
            a_temp_cookie = a_all_cookies[i].split( '=' );

            // and trim left/right whitespace while we're at it
            cookie_name = a_temp_cookie[0].replace(/^\s+|\s+$/g, '');

            // if the extracted name matches passed check_name
            if ( cookie_name == check_name ) {

                b_cookie_found = true;
                // we need to handle case where cookie has no value but exists (no = sign, that is):
                if ( a_temp_cookie.length > 1 ) {

                    cookie_value = unescape( a_temp_cookie[1].replace(/^\s+|\s+$/g, '') );

                }
                // note that in cases where cookie is initialized but no value, null is returned
                return cookie_value;
                break;
            }

            a_temp_cookie = null;
            cookie_name = '';

        }

        if ( !b_cookie_found ) {

            return null;

        }

    }

}

/*
 * Cause Button Widget Scripts
 * ---------------------------
 * Scripts here are responsible for loading and controlling the cause button and the cause button widget body
 * everything needs to be defined within this function to avoid potential conflicts with the host page.
 * It will be called automatically via the () at the end of the function.
 **/

(function() {
    var all_scripts = document.getElementsByTagName('script');
    var script_url;
    var ScriptsCounter;
    var CBAssetsBase;
    var CBBase;
    var CBHome = "http://causebutton.com";  // link to causebutton home page
    var ReferringPath;
    var FilteredParamString;  // original param string minus all referring path param(s)
    var ServeData;
    var EventData;
    var UpdateData;
    var WidgetData;
    var PageTarget; // this is the url target passed in as a param with the script src url
    var URLTarget; // this is the calculated url target value
    var Loaded = false;
    var PagePosition; // this is the widget position passed in as a param with the script src url
    var WidgetPosition; // Holds the calculated widget position value
    var SelectedChannel;
    var CBCauseID = ""; // this is the cause ID passed in as a param with the page url
    var CurrentCauseRadioButtonVal;
    var SessionChanged = false; // used when deciding whether to serve a modal or not
    var AutoButton = ""; // this is the url auto button value passed in as a param with the script src url
 
    // iterate through the loaded scripts looking for the current one (must specify id on the tag for this to work)
    // an alternative implementation would be to look for 'cbwidget.js' in the title which would fail if we were to
    // change the name of the script (not sure which method is better)
    for (var i=0; i < all_scripts.length; i++) {
        if (all_scripts[i].id == "cbw-script") {
            script_url = all_scripts[i].src;
        }
    }

    // following gets the widget host plus assets/widget/ 
    // This is the prefix used for retrieving all widget assets
    CBAssetsBase  = script_url.substring(0,script_url.lastIndexOf("/") + 1);

    // Following gets the base url to the Host
    CBBase = script_url.substring(0,script_url.lastIndexOf("assets"));

    // Following adds the api suffix to the base Host url
    // This is the prefix used for all api calls
    CBApiBase = CBBase + "api/v1/";

    // Following parses the param string of script_url and assigns values to
    // CBMerchantID, PageTarget (optional), and PagePosition (optional).
    var hashes = script_url.slice(script_url.indexOf('?') + 1).split('&');
    for (var i=0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        //vars.push(hash[0]);
        //vars[hash[0]] = hash[1];
        switch (hash[0]) {
            case 'cbw-merchant-id':
                CBMerchantID = hash[1];
                break;
            case 'cbw-url-target':
                PageTarget = hash[1];
                break;
            case 'cbw-position':
                PagePosition = hash[1];
                break;
            case 'cbw-auto-button':
                AutoButton = hash[1];
                break;
        }
    }

    // following validates the input position.  Returns the input if valid or an empty string if not.
    PagePosition = ValidatePosition(PagePosition);

    // following validates the input target.  Returns the input if valid or an empty string if not.
    PageTarget = ValidateTarget(PageTarget);

    // following validates the input auto button setting.  Returns the input if valid or an empty string if not.
    AutoButton = ValidateAutoButton(AutoButton);

    // Chain load the scripts here in the order listed below...
    // when the last script in the chain is loaded, main() will be called
    // IMPORTANT: jQuery must be the first script in the list!!!!  If it is not
    // and there is a copy of jQuery 1.11.1 already loaded, the first
    // script in the list will be skipped.

    var scripts = [
        {"name": "jQuery", "src": "http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js", "custom_load": JQueryCustomLoad },
        // IMPORTANT: the Select2 js files (select2.js and select2.min.js) have been modified
        // from thier original versions.  Instead of looking for the alias "jQuery", they
        // look for an instance of jQuery loaded under the alias "jq1111", which is how
        // we load jQuery in the CustomLoad function below and how we access it in the
        // document.ready call in main().
        {"name": "Select2", "src": CBAssetsBase + "select2.min.js"},
        // {"name": "Select2", "src": CBAssetsBase + "select2.js"},
    ];

    // Set the ScriptsCounter to 0.  This is incremented as the scripts are loaded
    // and used to keep track of progress through the script list.

    ScriptsCounter = 0;

    //Start Loading Scripts

    //if (window.jQuery === undefined || window.jQuery.fn.jquery != '1.10.1') {
    if (window.jQuery === undefined || window.jQuery.fn.jquery != '1.11.1') {

        // Load our version of jQuery and start chain here...
        CreateScriptTag(scripts[0].name, scripts[0].src);   

    } else {

        // Version of jQuery already loaded is fine
        // jQuery = window.jQuery;
        // Change alias to jq1111 as that is what main() and select2 now need.
        // Should noConflict(true) be added to this?  Phil says yes.  Probably
        // need to do some testing to make sure this works.
        jq1111 = window.jQuery.noConflict();

        // Load starting with the second script (skip jQuery)
        CreateScriptTag(scripts[1].name, scripts[1].src);
    }


    /* ----------------------------------------------------------------------- 
     * CreateScriptTag
     * ----------------------------------------------------------------------- 
     * Creates a new script tag for insertion into the existing document
     * given the name (used for internal purposes) and the src for the script
     *************************************************************************/
    function CreateScriptTag(name, src) {

        var script_tag = document.createElement('script');

        script_tag.setAttribute("type", "text/javascript");
        script_tag.setAttribute("src", src);
        script_tag.setAttribute("cb-id", name);

        //script_tag.onload = ScriptLoadHandler;

        if (script_tag.readyState) {

            // Deal with IE 8 and lower browsers here (about 5% of browser mkt, when gets too low may want to remove to simplify)

            script_tag.onreadystatechange = function() {

                if (this.readyState == 'complete' || this.readyState == 'loaded') {
                    ScriptLoadHandler();
                }
            }

        } else {

            script_tag.onload = ScriptLoadHandler;
        }

        (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(script_tag);
    }

    /* ----------------------------------------------------------------------- 
     * ScriptLoadHandler
     * ----------------------------------------------------------------------- 
     * This is a generic script tag onload handler that will load the 
     * next script in the chain if there are more scripts to load or
     * (if not) call the main function for execution of the main part of this
     * script. This relies on the "cb-id" attribute of the script tag added 
     * as part of the CreateScriptTag method. If this is not used for a 
     * particular script, chain loading will be bypassed for that script
     *************************************************************************/
    function ScriptLoadHandler(params) {

        var scr = scripts[ScriptsCounter];

        // Check to see if the custom_load attribute was set on the last script
        // to be loaded, and if it was, call the function that is passed in.
        // At the moment, this is only used to set the no-conflict property
        // for jQuery.

        if (scr.custom_load) {
            
            scr.custom_load.call(params);
        }

        // Now advance the ScriptsCounter

        ScriptsCounter++;

        // Load the next script in the chain

        scr = scripts[ScriptsCounter];

        // If there is a next script to load, create the script tag, otherwise
        // call the PreMain() function.

        if (scr) {

            CreateScriptTag(scr.name, scr.src)
        
        } else {

            // This is the last script in the page, call PreMain()
            PreMain();
        }
    }

    /* ----------------------------------------------------------------------- 
     * PreMain()
     * ----------------------------------------------------------------------- 
     * This function contains all the remaining script that can be executed
     * without jQuery.  Once we get into script that requires jQuery we
     * have to enter main(), which is called at the end of this script.
     *************************************************************************/
    function PreMain() {
        // Dynamically load the pre-requisite and local stylesheets

        //AddStylesheet('cbw-reset', CBAssetsBase + "cbwreset.css");
        // added reset styles to cbwidget.css
        AddStylesheet('cbw-css-sel2', CBAssetsBase + "select2.css");
        AddStylesheet('cbw-css', CBAssetsBase + "cbwidget.css");
        AddStylesheet('cbw-googlefonts', "https://fonts.googleapis.com/css?family=Montserrat:400,700");
        AddStylesheet('font-awesome', "//netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css");

        // get the parameters passed into the page so that we can carry these forward if necessary
        // for example, as part of the process of determining the landing page or promotion id
        var params = getUrlVars();

        // set the ReferringPath variable equal to blank.  This will be updated with a real param in
        // GetReferringPathAndCause if one exists, otherwise it ensures the param will be passed
        // with the api call.
        ReferringPath = "";

        // set the CBCauseID variable equal to blank.  Ensures the param will be passed with the api call.
        // This will be updated with a real param in GetReferringPathAndCause if one exists.
        CBCauseID = "";

        // set the FilteredParamString variable equal to blank.  This will only change if the params.length
        // is > 0, which will result in a call to GetReferringPathAndCause(params).
        FilteredParamString = "";

        // now check to see if the page url params contains a referral path or a cause ID.  If it does,
        // the FilteredParamString variable will be populated with all the params except the referral 
        // path params and/or the cause ID, and the ReferringPath and CBCauseID variables will be set 
        // to the correct values.
        if (params.length > 0) {
            GetReferringPathAndCause(params);
        }

        main();  
    }

    /* ----------------------------------------------------------------------- 
     * JQueryCustomLoad
     * ----------------------------------------------------------------------- 
     * JQuery custom load handler action, right now this just sets the 
     * noConflict option of jQuery to true. This is called from the generic
     * ScriptLoadHandler due to the custom_load action on the script object
     * in the scripts array.
     *************************************************************************/
    function JQueryCustomLoad(params) {
        // IMPORTANT: the Select2 js files (select2.js and select2.min.js) have been modified
        // from thier original versions.  Instead of looking for the alias "jQuery", they
        // look for an instance of jQuery loaded under the alias "jq1111", which is how
        // we load jQuery in the CustomLoad function below and how we access it in the
        // document.ready call in main().
        // jQuery = window.jQuery.noConflict(true);
        jq1111 = window.jQuery.noConflict(true);
    }
    
    /* ---------------------------------------------------------------------------------
     * ValidatePosition(position)
     * ---------------------------------------------------------------------------------
     * This function is called to validate a widget position input.  If the position
     * input is valid, it is returned, otherwise null is returned.
     * --------------------------------------------------------------------------------- */
    function ValidatePosition(position) {

        var widget_position_valid = false;
        var arr = [ "top-left","top-center","top-right","left-center","center","right-center","bottom-left","bottom-center","bottom-right"];

        for (var i = 0; i < arr.length; i++) {
            if (arr[i] == position) {
                widget_position_valid = true;
            }
        }

        if (!widget_position_valid) {
            position = "";
        }
        return position;
    }

    /* ---------------------------------------------------------------------------------
     * ValidateTarget(target)
     * ---------------------------------------------------------------------------------
     * This function is called to validate a widget url target input.  If the target
     * input is valid, it is returned, otherwise null is returned.  At the moment, the
     * only valid inputs are "local" and "default", but at some point we may allow 
     * specific urls to be passed in, in which case we'll have to test for a valid url
     * pattern here.
     * --------------------------------------------------------------------------------- */
    function ValidateTarget(target) {

        var widget_target_valid = false;
        var arr = [ "local", "default" ];

        for (var i = 0; i < arr.length; i++) {
            if (arr[i] == target) {
                widget_target_valid = true;
            }
        }

        if (!widget_target_valid) {
            target = "";
        }
        return target;
    }

    /* ---------------------------------------------------------------------------------
     * ValidateAutoButton(autobutton)
     * ---------------------------------------------------------------------------------
     * This function is called to validate a widget url auto button input.  If the autobutton
     * input is valid, it is returned, otherwise null is returned.  At the moment, the
     * only valid inputs are "left", "right", "none", and "test", but at some point we may allow 
     * additional values.  Note that the values "none" and "test", when passed in via
     * the load script url, will supercede values from the api response.
     * --------------------------------------------------------------------------------- */
    function ValidateAutoButton(autobutton) {

        var autobutton_valid = false;
        var arr = [ "left", "right", "none", "test" ];

        for (var i = 0; i < arr.length; i++) {
            if (arr[i] == autobutton) {
                autobutton_valid = true;
            }
        }

        if (!autobutton_valid) {
            autobutton = "";
        }
        return autobutton;
    }

    /* --------------------------------------------------------------------------------------------------------
     * main()
     * --------------------------------------------------------------------------------------------------------
     * This is the main function that will perform most of the functionality of the cause widget creation
     * It will *only* be called after the necessary scripts have been loaded in the prescribed order in the
     * main anonymous function. It is called by the PreMain script which is called by the load handler 
     * after the last script is loaded
     * -------------------------------------------------------------------------------------------------------- */
    function main() {

        /* --------------------------------------------------------------------------------------------------------
         * jQuery(document).ready(function($)
         * --------------------------------------------------------------------------------------------------------
         * This is the equivalent of the typical $(document).ready(function() {}) call that is called when 
         * jQuery indicates that the page is 'ready'. Put all code that requires jQuery in here!
         * -------------------------------------------------------------------------------------------------------- */
        // IMPORTANT: the Select2 js files (select2.js and select2.min.js) have been modified
        // from thier original versions.  Instead of looking for the alias "jQuery", they
        // look for an instance of jQuery loaded under the alias "jq1111", which is how
        // we load jQuery in the CustomLoad function above and how we access it in the
        // document.ready call in main() that follows.
        jq1111(document).ready(function($) {
        //jQuery(document).ready(function($) {

            // This is the id value of the div to which the entire widget will be appended.
            // This used to be #cb-widget-replace but now the widget is appended to the body tag.
            var div = $("body");

            // // Now check to see if there are any elements on the page that include
            // // either the .cbw-btn class or the .cbw-main-btn class.  (Remember that this
            // // script injects a .cbw-main-btn class when it adds the button html to elements
            // // containing the .cbw-btn class, but this happens later in the execution of the
            // // script so we have to look for .cbw-btn classes here.) If there are, then
            // // we need to build the widget and append it to the page body.  If there aren't,
            // // we only need to retrieve the serve data. 

            // if ($(".cbw-main-btn, .cbw-btn").length == 0) {

            //     // This is the case where the widget does not need to get built.
            //     // When the loading of the serve data is complete, just need to
            //     // write cookies and load the purchase path variable.
            //     $.when(LoadServeData(ReferringPath)).done(function(a) {

            //         $.when(WriteCookies(),PurchasePathUpdate(ServeData.paths["purchase"])).done(function(a,b) {
            //             ReportConversion();
            //         });

            //     });

            // } else {

            //     // Get the widget html template and load the serve data.  When both 
            //     // of these are complete, write cookies, load the purchase path variable, 
            //     // merge the serve data into the widget html, and merge the button html.
            //     $.when(GetWidgetHTML(), LoadServeData(ReferringPath)).done(function(a,b) {

            //         //WriteCookies();
            //         //PurchasePathUpdate(ServeData.paths["purchase"]);
            //         MergeServeData(div);
            //         MergeButtons();

            //         // When the event data is finished loading, merge the event data into the widget.
            //         $.when(LoadEventsData(ServeData.session_id, ServeData.serve_id)).done(function(a) {

            //             MergeEventsData();

            //         });

            //         // If the cause selector for this promotion is false, hide the currently selected 
            //         // cause display block in the widget.  Otherwise, load the cause data.
            //         if (!ServeData.promotion.cause_selector) {

            //             $(".cbw-currently-selected-cause").removeClass("cbw-widget-show");
            //             $(".cbw-currently-selected-cause").addClass("cbw-widget-hide");
                    
            //         } 

            //         // Write the session, serve, and path cookies.  Then check for and report conversions
            //         $.when(WriteCookies(),PurchasePathUpdate(ServeData.paths["purchase"])).done(function(a,b) {
            //             ReportConversion();
            //         });

            //         Loaded = true;

            //         ShowModal();

            //         ShowAutoButton();

            //     });

            // }


            // Get the widget html template and load the serve data.  When both 
            // of these are complete, write cookies, load the purchase path variable, 
            // and report a conversion if one occurred.  Then check to see if it is
            // necessary to finish building the widget (because a button will be
            // shown on this page.)
            //
            // Note that the widget html is possibly being loaded unnecessarily, but
            // it loads synchronously with the serve data and loads faster than the
            // serve data, so it's probably OK for the moment.
            $.when(GetWidgetHTML(), LoadServeData(ReferringPath)).done(function(a,b) {

                $.when(WriteCookies(),PurchasePathUpdate(ServeData.paths["purchase"])).done(function(a,b) {
                    ReportConversion();
                });

                // check to see if the AutoButton variable is blank.  This will be the case
                // when no valid value has been passed in with the widget load script url.  When
                // this is the case, get the auto_button value from the api serve response and use it.
                // Otherwise, use the page value from the load script url.
                // Note that the values "none" and "test", when passed in via the load script url,
                // will supercede values from the api response.
                if (!AutoButton || AutoButton == "") {
                    AutoButton = ServeData.merchant.auto_button;
                }

                // Validates the auto button setting that might have been received from the
                // API.serve response.  Returns the value if valid or an empty string if not.
                AutoButton = ValidateAutoButton(AutoButton);

                // Now check to see if there are any elements on the page that include
                // either the .cbw-btn class or the .cbw-main-btn class (remember that this
                // script injects a .cbw-main-btn class when it adds the button html to elements
                // containing the .cbw-btn class, but this happens later in the execution of the
                // script so we have to look for .cbw-btn classes here.) Also check to see if the
                // Auto Button value is "left" or "right", indicating that it should be displayed.
                // Finally, check to see if AutoButton == "test" and one of the autobutton test
                // classes is present on the page.  If any of these is true, then
                // we need to build the widget and append it to the page body. Otherwise, we're done.
                if ($(".cbw-main-btn, .cbw-btn").length > 0 || AutoButton == "left" || AutoButton == "right" || (AutoButton == "test" && $(".cbw-auto-button-test-left, .cbw-auto-button-test-right").length > 0)) {

                    MergeServeData(div);
                    MergeButtons();

                    // When the event data is finished loading, merge the event data into the widget.
                    $.when(LoadEventsData(ServeData.session_id, ServeData.serve_id)).done(function(a) {

                        MergeEventsData();

                    });

                    // If the cause selector for this promotion is false, hide the currently selected 
                    // cause display block in the widget.  Otherwise, load the cause data.
                    if (!ServeData.promotion.cause_selector) {

                        $(".cbw-currently-selected-cause").removeClass("cbw-widget-show");
                        $(".cbw-currently-selected-cause").addClass("cbw-widget-hide");
                    
                    } 

                    Loaded = true;

                    ShowModal();

                    ShowAutoButton();

                }

            });



            /*
             * HELPER FUNCTIONS 
             */

            /* ---------------------------------------------------------------------------------
             * ShowAutoButton()
             * ---------------------------------------------------------------------------------
             * Check at the page level and at the merchant level to see if the auto button should
             * be displayed, an if so whether it should be on the left or the right of the page.
             * --------------------------------------------------------------------------------- */
            function ShowAutoButton() {
                // console.log(AutoButton);
                // console.log(ServeData.merchant.auto_button);
                // if (!AutoButton || AutoButton == "") {
                //     AutoButton = ServeData.merchant.auto_button;
                // }

                // // following validates the auto button setting that might have been received from the
                // // API.serve response.  Returns the value if valid or an empty string if not.
                // AutoButton = ValidateAutoButton(AutoButton);
                // console.log(AutoButton);
                if (AutoButton == "test") {
                    if ($(".cbw-auto-button-test-right").length > 0) {
                        AutoButton = "right";
                    } else if ($(".cbw-auto-button-test-left").length > 0) {
                        AutoButton = "left";
                    }
                }

                // Now, check to see if the AutoButton value is either left or right.  If it is none
                // or blank we skip the AutoButton entirely.
                if (AutoButton == "left" || AutoButton == "right") {
                    $("<div id=\"cbw-button-div\">").html( "<div id='cbw-button-side' class='cbw-button-side cbw-main-btn'></div>" ).appendTo(div);
                    $("#cbw-button-side").append( "<img id='cbw-button-side-img1' class='cbw-button-side-img'>" );
                    $("#cbw-button-side-img1").attr('src', CBAssetsBase + 'cause-86x40.png');

                    switch (AutoButton) {
                        case "left":
                            $("#cbw-button-side").css({
                                position: 'fixed',
                                top: "50%",
                                left: "0%",
                                marginTop: - ($("#cbw-button-side-img1").outerHeight(true) / 2),
                                marginLeft: - ($("#cbw-button-side-img1").outerWidth(true)),
                                zIndex: 9998
                            });
                            $("#cbw-button-side").animate({ "marginLeft": "+=86px" }, "slow");
                        break;

                        case "right":
                            $("#cbw-button-side").css({
                                position: 'fixed',
                                top: "50%",
                                right: "0%",
                                marginTop: - ($("#cbw-button-side-img1").outerHeight(true) / 2),
                                marginRight: - ($("#cbw-button-side-img1").outerWidth(true)),
                                zIndex: 9998
                            });
                            $("#cbw-button-side").animate({ "marginRight": "+=86px" }, "slow");
                        break;

                    }
                }
            }

            /* ---------------------------------------------------------------------------------
             * ShowModal()
             * ---------------------------------------------------------------------------------
             * Check to see if this is one of the first three sessions of this serve, or if the
             * session has changed (which will happen if a serve becomes unservable or if a visitor
             * returns from a new CBCause link).  If so, then either serve up the modal with the
             * generic message, or if there is a CBCauseId, insert the cause into the message.
             * Finally, set the cbwmodal cookie to skip to skip showing the modal for 24 hours.
             * --------------------------------------------------------------------------------- */
            function ShowModal() {

                // first, check to see if we should serve the modal.  Modals get served any time 
                // the session_count is less than or equal to three, except when both the cbwmodal cookie
                // value is "skip" and the session hasn't changed.
                if (ServeData.session_count <= 3 && (GetCookie("cbwmodal") != "skip" || SessionChanged)) {

                    //var modal_message = "<span style='font-size:24px;font-weight:bold;'>Big News!</span><br/>We're donating up to 20% of our sales to the {{placeholder}}, and you don't need to buy a thing!  Click <img id='cbw-modal-message-img1' class='cbw-modal-message-img cbw-main-btn cbw-close-modal'> or <img id='cbw-modal-message-img2' class='cbw-modal-message-img cbw-main-btn cbw-close-modal'> on any page to learn more.";

                    var modal_message = "<span style='font-size:24px;font-weight:bold;'>Big News!</span><br/>We're donating up to 20% of our sales to the {{placeholder}}, and you don't need to buy a thing!  Click <img id='cbw-modal-message-img2' class='cbw-modal-message-img cbw-main-btn cbw-close-modal'> on any page to learn more.";

                    // now check to see if a cblink value was passed in and if so, use the default cause
                    // for this serve in the modal message
                    if (CBCauseID && CBCauseID != "") {
                        modal_message = modal_message.replace("{{placeholder}}", ServeData.default_cause_name);
                        // Fix duplicate "the"s, and the "the a"s
                        FixCauseNames(modal_message);
                    } else {
                        // otherwise, just use the standard messaging
                        modal_message = modal_message.replace("{{placeholder}}", "charitable cause of your choice");
                    }
                    
                    // add the div that contains the modal, then add the text, css, and close button to the modal div
                    $("<div id=\"cbw-modal-div\" class=\"cbw-reset cbw\">").html( "<div id='cbw-modal-1' class='cbw-modal'></div>" ).appendTo(div);
                    $("#cbw-modal-1").append( modal_message);
                    //$("#cbw-modal-1").text( modal_message );
                    $("#cbw-modal-1").css({
                        position: 'fixed',
                        top: ($(window).height() - $("#cbw-modal-1").height())/2,
                        left: ($(window).width() - $("#cbw-modal-1").width())/2,
                        zIndex: 10000
                    });
                    //$("#cbw-modal-1").append("<img id='cbw-modal-message-img1' class='cbw-modal-message-img'> or <img id='cbw-modal-message-img2' class='cbw-modal-message-img'> on any page to learn more.");
                    //$("#cbw-modal-1").append("<img id='cbw-modal-message-img2' class='cbw-modal-message-img'>");
                    //$("#cbw-modal-1").append("more text here");
                    closeButton = $('<a href="#close-modal" rel="cbw-modal:close" class="close-modal">' + 'close text' + '</a>');
                    $("#cbw-modal-1").append(closeButton);

                    // $("#cbw-modal-message-img").attr('src', CBAssetsBase + 'cb-white-ltblue-15x123.svg');
                    $("#cbw-modal-message-img1").attr('src', CBAssetsBase + 'causebutton-160x40.png');
                    $("#cbw-modal-message-img2").attr('src', CBAssetsBase + 'cause-86x40.png');
                    $(".cbw-modal-message-img").css("height","30");
                    
                    // now add the tranparant background div and give it the correct styles
                    $("<div id=\"cbw-modal-blocker-div\">").html('<div class="jquery-modal blocker"></div>').appendTo(div);
                    $("#cbw-modal-blocker-div").css({
                        top: 0, right: 0, bottom: 0, left: 0,
                        width: "100%", height: "100%",
                        position: "fixed",
                        zIndex: 9999,
                        background: "#000",
                        opacity: .75
                    });

                    // show the modal dialog
                    $('#cbw-modal-1').show();

                    // finally, set the cbwmodal cookie value to skip so this modal doesn't get shown 
                    // for this serve for at least another 24 hours
                    SetCookie("cbwmodal", "skip", 1440, "/");

                }

            }

            /* ---------------------------------------------------------------------------------
             * ReportConversion()
             * ---------------------------------------------------------------------------------
             * Check to see if there is a conversion to report on this page.  If so, collect
             * the conversion attributes and call the CBSale function.
             * --------------------------------------------------------------------------------- */
            function ReportConversion() {

                // Check to see if there are any elements on the page that include
                // the .cbw-conversion-success class. If there are, and if there is only
                // one such element, then we need to get the conversion amount and transaction
                // ID values from attributes of that element and call the CBSale method to
                // report the conversion to the database. 

                if ($(".cbw-conversion-success").length == 1) {

                    var cbw_conversion_amount = $(".cbw-conversion-success").attr('cbw-conversion-amount');
                    var cbw_transaction_id = $(".cbw-conversion-success").attr('cbw-transaction-id');
                    CBSale(cbw_conversion_amount,cbw_transaction_id);
                } else if ($(".cbw-conversion-success").length > 1) {
                    console.log("Too many elements with class .cbw-conversion-success on this page.  There can only be one.");
                }

            }

            /* ---------------------------------------------------------------------------------
             * GetWidgetHTML(div)
             * ---------------------------------------------------------------------------------
             * Uses an Ajax call to the server to pull down the html template used to build the 
             * Cause Button and the widget itself.
             * --------------------------------------------------------------------------------- */
            function GetWidgetHTML() {

                return $.ajax({
                    type: 'POST',
                    url: CBApiBase + "content",
                    timeout: 30000,
                    dataType: "jsonp",
                    success: function(json) {
                        WidgetData = json;

                    },
                    error: function(data, status, xhr) {

                    },
                    complete: function(jqXHR, textStatus) {

                    }
                });

            }

            /* ---------------------------------------------------------------------------------
             * LoadServeData(referring_path)
             * ---------------------------------------------------------------------------------
             * This function calls the serve method of the Causebutton API and retrieves the correct
             * pledge information.  Referring Path is optional and is used to identify the parent
             * serve if one exists.  Merchant ID  and CBCause ID are global variables, and the session and
             * serve information are read from cookies if they exists.  If no prior serve exists,
             * the server finds the current pledge and serves that.
             * --------------------------------------------------------------------------------- */
            function LoadServeData(referring_path) {

                var method = "serve";

                var data_url = CBApiBase + method + "/" + CBMerchantID;

                // Get the existing values for the cause button cookies so that 
                // we can properly initialize the widget

                // The CBW Session Cookie contains the session_id 
                var cbwSessionCookie = GetCookie("cbwsession");

                // The CBW Serve Cookie (cbwserve) contains the serve_id used for this user
                var cbwServeCookie = GetCookie("cbwserve");
                
                // pass these values back into the server on the AJAX call so that we can get proper values in return
                var ajxDataObj = new Object();

                if (cbwSessionCookie) {
                    ajxDataObj.session_id = cbwSessionCookie;
                }

                if (cbwServeCookie) {
                    ajxDataObj.serve_id = cbwServeCookie;
                }
                
                if (referring_path) {
                    ajxDataObj.path = referring_path;
                }

                if (CBCauseID) {
                    ajxDataObj.cbcause_id = CBCauseID;
                }

                //var reqObj = $.ajax({
                return $.ajax({
                    type: 'POST',
                    url: data_url,
                    data: ajxDataObj,
                    timeout: 30000,
                    dataType: "jsonp",
                    success: function(data) {
                        ServeData = data;

                        if (ServeData.error) {
        
                            alert("API error: " + ServeData.error);
                        }
                    },
                    error: function(data, status, xhr) {

                        alert('LoadServeData error');
                    },
                    complete: function(jqXHR, textStatus) {
                        
                    }
                    

                });

            }       

            /* ---------------------------------------------------------------------------------
             * WriteCookies()
             * ---------------------------------------------------------------------------------
             * Writes the cbsession and cbserve cookies after the Serve data is loaded.
             * --------------------------------------------------------------------------------- */
            function WriteCookies() {
                // Set and update cookies...
                // First, get the number of minutes until the expiration of the current serve
                var expire_mins = GetExpireMins();

                // Now, set the session cookie and the serve cookie. Note that currently, session
                // cookie set to expire in 24 hours (1440 mins).  Planning to move this to a
                // configurable parameter at some point.

                if (GetCookie("cbwsession") != ServeData.session_id) {
                    SessionChanged = true;
                } else {
                    SessionChanged = false;
                }
                SetCookie("cbwsession", ServeData.session_id, 1440, "/");
                SetCookie("cbwserve", ServeData.serve_id, expire_mins, "/"); 

            }

            /* ---------------------------------------------------------------------------------
             * MergeButtons()
             * ---------------------------------------------------------------------------------
             * Merges button html from the serve data into elements containing class .cbw-btn
             * --------------------------------------------------------------------------------- */
            function MergeButtons() {

                // add the button html to every element on the page that includes class cbw-btn.  
                $(".cbw-btn").append(ServeData.promotion.button_html);

                // Now add the class cbw-main-btn to every element on the page to which we
                // just added the button html.  This turns the element into a "button"
                // that can open the widget.
                $(".cbw-btn").addClass('cbw-main-btn')

            }

            /* ---------------------------------------------------------------------------------
             * MergeServeData(div)
             * ---------------------------------------------------------------------------------
             * Merges the serve data returned from LoadServeData into the appropriate places
             * in the widget.
             * --------------------------------------------------------------------------------- */
            function MergeServeData(div) {

                // append the widget html to the input div

                $("<div id=\"cbw-main-div\">").html( WidgetData.content ).appendTo(div);

                if (ServeData.email) {

                    $("#cbw-email-input").val(ServeData.email);
                    $("#cbw-email-checkbox").prop('checked',true);
                    $("#cbw-email-ctl-grp").removeClass("cbw-widget-hide");
                    $("#cbw-email-ctl-grp").addClass("cbw-widget-show");
                }

                // Add the logo image
                // $("#cbw-heading-logo-img").attr('src', CBAssetsBase + 'cb-white-ltblue-15x123.svg');

                // Add the logo link target
                $("#cbw-heading-logo-link").attr('href', CBHome);

                // Populate the pledge title text supplied by the server
                $("#cbw-pledge-title").text(ServeData.promotion.title);

                // Add the footer causebutton url link target
                $("#cbw-links-causebutton-url").attr('href', CBHome);

                // Add the footer causebutton url link target
                $("#cbw-links-causebutton-url").attr('target', "_blank");

                // Populate the footer causebutton url link text
                $("#cbw-links-causebutton-url").text("causebutton.com");

                // replace variables in the promotion text supplied by the server
                var banner = ServeData.promotion.banner
                banner = banner.replace("{{merchant_cause}}", ServeData.default_cause_name);
                // Fix duplicate "the"s, and the "the a"s
                FixCauseNames(banner);

                // Populate the promotion text supplied by the server
                $("#cbw-promo-text").text(banner);

                // Populate the default cause name supplied by the server
                $("#default-cause-control-text").text(ServeData.default_cause_name);

                // Populate the currently selected cause name supplied by the server
                $("#cbw-currently-selected-cause-text").text(ServeData.cause_name);

                // Populate the active channels for current merchant/promotion

                var channel_pattern = "<div class='cbw-channel-toggle' nidx='{1}' idx='{0}' id='cbw-{0}'><span class='fa-stack fa-lg cbw-channel-icon'><i class='fa fa-circle fa-stack-2x channel-icon channel-icon-off'></i><i class='fa fa-{2} fa-stack-1x fa-inverse'></i></span></div>";

                var channel_div = $("#cbw-channels");

                var channels = ServeData.display_order;

                //for (var i in channels) {
                for (var i = 0; i < channels.length; i++) {
                    // Note that this section depends on ServeData.display_order including a two element hash in the format 
                    // ["Channel name","Font Awesome Icon Name"] for each channel that is returned.
                    // This is not great design and should be changed to name-value pairs sometime.
                    var chname = channels[i][0].toLowerCase();
                    var font_awesome_icon_name = channels[i][1];

                    // purchase is a special channel - ignore this one from user perspective as no channel should be displayed
                    if (chname != "purchase") {
                        channel_div.append(channel_pattern.replace(/\{0\}/g, chname).replace(/\{1\}/g, i).replace(/\{2\}/g, font_awesome_icon_name));
                    }
                }            

                // assign variable name to the fgcause selector
                var fgcause_select = $("#cbw-fgcause-select");

                // check to see if the loaded cause from the serve api response for this serve is the same as the default cause for the associated promotion.  If it is, set the radio button value to default (so the default value is checked when the widget opens), then delete the seed values for the single and group cause selectors.
                if (ServeData.default_cause_uid == ServeData.cause_uid) {
                    $("[name=cause-type-radio]").val(["default"]);
                    // Update the CurrentCauseRadioButtonVal with radio button value associated with this selection
                    CurrentCauseRadioButtonVal = "default";
                    ServeData.fg_uuid = "";
                    ServeData.event_uid = "";
                } else {
                    // check to see if the selected cause is a single.  If it is, select that button:
                    if (ServeData.cause_type == "single") {
                        $("[name=cause-type-radio]").val(["single"]);
                        // Update the CurrentCauseRadioButtonVal with radio button value associated with this selection
                        CurrentCauseRadioButtonVal = "single";
                    } else {
                        // set the radio button to the default selection.  We'll check for matches
                        // with trending causes after we load them.
                        $("[name=cause-type-radio]").val(["default"]);
                        // Update the CurrentCauseRadioButtonVal with radio button value associated with this selection
                        CurrentCauseRadioButtonVal = "default";
                    }
                }

                // set the initial values of the fgcause selector
                fgcause_select.attr('value', ServeData.fg_uuid);

                // make the fgcause selector a Select2 selector
                fgcause_select.select2({
                    placeholder: 'Start typing here...',
                    minimumInputLength: 3,
                    multiple: false,
                    id: 'organization_uuid',
                    ajax: {
                        url: 'https://graphapi.firstgiving.com/v2/list/organization?jsonpfunc=?',
                        dataType: 'jsonp',
                        jsonp: 'jsonpfunc',
                        quietMillis: 200,
                        data: function (term, page) {
                            return {
                                q: 'organization_name:' + term + '*%20XXYYZZ%20country:US', // search term
                                page: page - 1,
                                page_size: 25,
                                sep: 'XXYYZZ',
                            };
                        },
                        results: function(data, page) {
                            var more =  false; 
                            if (data.payload[0] && data.payload[0].numFound !== "") {
                                more = (page * 25) < data.payload[0].numFound;
                            }
                            return { 
                                results: data.payload, more: more
                            };
                        }
                    },
                    initSelection: function(element, callback) {
                        // the input tag has a value attribute preloaded that points to a preselected cause's id
                        // this function resolves that id attribute to an object that select2 can render
                        // using its formatResult renderer - that way the cause name is shown preselected
                        var id=$(element).val();
                        if (id!=="") {
                            $.ajax({
                                dataType: 'jsonp',
                                contentType: 'application/json',
                                jsonp: 'jsonpfunc',
                                url: 'https://graphapi.firstgiving.com/v2/object/organization/'+id+'?jsonpfunc=?',
                            }).done(function(data) { console.log(data.payload.organization_name); callback(data.payload); });
                        }
                    },
                    dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
                    formatResult: causeFormatResult, // omitted for brevity, see the source of this page
                    formatSelection: causeFormatSelection,  // omitted for brevity, see the source of this page
                    nextSearchTerm: function (selectedObject, currentSearchTerm) {return currentSearchTerm;},
                    escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
                });

            }

            function causeFormatResult(cause) {
                var markup = "<div class='cause-result'><div id='" + cause.organization_uuid + "' class='cause-title'>" + cause.organization_name + "</div>";
                var state = false;

                if (cause.region) {
                    state = cause.region;
                } else if (cause.county) {
                    state = cause.county;
                } 
                if (cause.city && state) {
                    markup += "<div class='cause-location'>" + cause.city + ", " + state + "</div>";
                }
                if (cause.category_title) {
                    markup += "<div class='cause-category'>" + cause.category_title + "</div>";
                }
                markup += "</div>"
                return markup;
            }  
        
            function causeFormatSelection(cause) {
                var markup = "<div id='" + cause.organization_uuid + "' >" + cause.organization_name + "</div>";
                return markup;
            } 

            /* ---------------------------------------------------------------------------------
             * LoadEventsData(session_id, serve_id)
             * ---------------------------------------------------------------------------------
             * Loads the list of events to be displayed in the events selector.  Note that this
             * only happens when the value of cause_selector is true (meaning that the user has
             * the ability to direct a portion of the donation).
             *
             * @data_url    = URL to use to obtain JSON data (AJAX call)
             * @merchant_id = ID of the merchant to pass into the AJAX call
             * @callback    = Callback function to call when the AJAX call is completed
             * --------------------------------------------------------------------------------- */
            function LoadEventsData(session_id, serve_id) {

                var method = "events";

                var data_url = CBApiBase + method + "/" + CBMerchantID;

                // pass these values back into the server on the AJAX call so that we can get proper values in return
                var ajxDataObj = new Object();

                if (session_id) {
                    ajxDataObj.session_id = session_id;
                }

                if (serve_id) {
                    ajxDataObj.serve_id = serve_id;
                }

                return $.ajax({
                    type: 'POST',
                    url: data_url,
                    data: ajxDataObj,
                    timeout: 30000,
                    dataType: "jsonp",
                    success: function(data) {
                         EventData = data;

                        if (EventData.error) {
        
                            alert("API error: " + EventData.error);

                        }

                    },
                    error: function(data, status, xhr) {

                            alert("LoadEventData error");

                    },
                    complete: function(jqXHR, textStatus) {

                    }
                });
                
            }

            /* ---------------------------------------------------------------------------------
             * MergeEventsData()
             * ---------------------------------------------------------------------------------
             * Callback function that is called when the results of the AJAX call to pull the 
             * event data necessary to populate the select2 event selector.
             *
             * @data   = JSON data returned by the AJAX call (passed through as part of callback)
             * @status = Status of the AJAX call (passed through as part of callback)
             * @xhr    = jqXHR object that contains information about AJAX call 
             * --------------------------------------------------------------------------------- */
            function MergeEventsData() {

                var trending_cause_pattern = "#cbw-trending-cause-{0}";
                var trending_cause_text_pattern = "#trending-cause-{0}-text";
                
                // Set the show_trending_causes variable to false.  If there are any trending 
                // causes in the Events array, this will get set to true and will be used to
                // toggle the section visible after loading the trending causes.
                var show_trending_causes = false;

                var events_div = $("#cbw-events");

                for (var i in EventData) {

                    // first, replace the instance index in the patterns with the current index value:
                    var trending_cause = trending_cause_pattern.replace(/\{0\}/g, i);
                    var trending_cause_text = trending_cause_text_pattern.replace(/\{0\}/g, i);

                    // next, insert the trending cause name in the appropriate element
                    $(trending_cause_text).text(EventData[i].name);

                    //now, un-hide this radio button selection
                    $(trending_cause).removeClass("cbw-widget-hide");
                    $(trending_cause).addClass("cbw-widget-show");
                    show_trending_causes = true;

                    // check to see if the selected cause matches this trending cause.  If it does,
                    // select this radio button.  Note that if the selected cause is not a "single", the 
                    // "default" selection is checked when entering this for loop.  If no match is made 
                    // while looping, the default selection will be checked when done.

                    if (EventData[i].uid == ServeData.cause_uid && ServeData.default_cause_uid != ServeData.cause_uid) {
                        $("[name=cause-type-radio]").val([i]);
                        // Update the CurrentCauseRadioButtonVal with radio button value associated with this selection
                        CurrentCauseRadioButtonVal = i;
                    }

                    // This is a crude way of ensuring that we don't attempt to load more than three
                    // trending causes, because the html content template only has three placeholders.
                    if (i==2) {
                        break;
                    }

                }

                // finally, if there are any events in the EventData set, remove the hide class and
                // replace it with the show class for the div that contains all the trending causes
                if (show_trending_causes) {

                    $("#cbw-cause-select-ctrl-grp").removeClass("cbw-widget-hide");
                    $("#cbw-cause-select-ctrl-grp").addClass("cbw-widget-show");
                    $("#cbw-trending-causes-horiz-line").removeClass("cbw-widget-hide");
                    $("#cbw-trending-causes-horiz-line").addClass("cbw-widget-show");

                }            


            }

            function eventFormatResult(event) {
                var markup = "<div class='event-result'><div id='" + event.uid + "' class='event-title'>" + event.name + "</div>";
                markup += "<div class='event-description'>" + event.description + "</div>";
                markup += "</div>"
                return markup;
            }  
        
            function eventFormatSelection(event) {
                var markup = "<div class='event-selection' id='" + event.uid + "' >" + event.name + "</div>";
                return markup;
            } 

            // function eventFormat(item) { return item.name; };

            /* RegisterWidgetView - registers with server that the user clicked the cause button
             */
            function RegisterWidgetView() {

                var method = "view";

                var data_url = CBApiBase + method + "/" + CBMerchantID;

                // The CBW Session Cookie contains the session_id 
                var cbwSessionCookie = GetCookie("cbwsession");

                // pass these values back into the server on the AJAX call so that we can get proper values in return
                var ajxDataObj = new Object();

                if (cbwSessionCookie) {
                    ajxDataObj.session_id = cbwSessionCookie;
                }

                var reqObj = $.ajax({
                    type: 'POST',
                    url: data_url,
                    data: ajxDataObj,
                    timeout: 30000,
                    dataType: "jsonp",
                    success: function(data) {
                        // alert(data.status);
                        // alert('view registered ok - status: ' + data.status);
                    },
                    error: function(data, status, xhr) {

                        // should probably be silent to user...
                        //alert('error registering view: ' + data.status);
                    },
                    complete: function(jqXHR, textStatus) {
                    }
                });

                // Set the current Serve to viewed.  Not sure if this is necessary or not.

                ServeData.viewed = true;

                // Check to see if the purchase channel is active and if it is, get the path and use it to update
                // the AWESM cookies and the AWESM.parentAwesm global variable

                if (ServeData.paths['purchase']) {

                    PurchasePathUpdate(ServeData.paths["purchase"]);

                }

            }       

            /* UpdateServe - Updates the Serve record with current email, current cause or event, current cause type.  Also, when a path is passed in, registers a post to a social media channel (or attempt to do so), and returns the approptiate new paths.  Note that this function will not be called if any errors exist on the email, cause, or event, so we do not need to check for errors here.
             */
            function UpdateServe(path, callback) {

                // Check to see if the email checkbox is checked.  If it is,
                // then check to see if there is an error on the email.  If there is an error,
                // use the existing email value, otherwise use the new value.
                // If the email checkbox is not checked, use null for the email value.
                if ($("#cbw-email-checkbox").prop('checked')) {
                    if ($("#cbw-email-ctl-grp").hasClass('error')) {
                        var email = ServeData.email;
                    } else {
                        var email = $("#cbw-email-input").val();
                    }
                } else {
                    var email = "";
                }

                //var event_uid = $("#cbw-cause-select").select2("val");
                var fg_uuid = "";
                var event_uid = "";
                var cause_type = "";
                var selector_value = $("input[name='cause-type-radio']:checked").val();

                // Check to see which cause radio button is checked, then get
                // the appropriate cause values:
                switch (selector_value) {
                    case 'default':
                        cause_type = ServeData.default_cause_type;
                        switch (cause_type) {
                            case 'single':
                                fg_uuid = ServeData.default_fg_uuid;
                                break;
                            case 'event':
                                event_uid = ServeData.default_event_uid;
                                break;
                        }
                        break;
                    case 'single':
                        fg_uuid = $("#cbw-fgcause-select").select2("val");
                        cause_type = "single";
                        break;
                    case '0':
                        event_uid = EventData[selector_value].uid;
                        cause_type = "event";
                        break;
                    case '1':
                        event_uid = EventData[selector_value].uid;
                        cause_type = "event";
                        break;
                    case '2':
                        event_uid = EventData[selector_value].uid;
                        cause_type = "event";
                        break;
                }                

                var method = "update";

                var data_url = CBApiBase + method + "/" + CBMerchantID;

                // The CBW Session Cookie contains the session_id 
                var cbwSessionCookie = GetCookie("cbwsession");

                // pass these values back into the server on the AJAX call so that we can get proper values in return
                var ajxDataObj = new Object();

                if (cbwSessionCookie) {
                    ajxDataObj.session_id = cbwSessionCookie;
                }

                // always return an email value, even if it's null.  Otherwise api will
                // replace an existing email in database with null.
                ajxDataObj.email = email;

                // if ($("input[name='cause-type-radio']:checked").val()) {
                //     ajxDataObj.cause_type = $("input[name='cause-type-radio']:checked").val();
                // }

                // check to see if there is an error on the fgcause selector.  If there is
                // do not send any cause selection parameters back with this update request

                if (!$("#cbw-fgcause-select-ctrl-grp").hasClass('error')) {

                    if (event_uid) {
                        ajxDataObj.event_uid = event_uid;
                    }

                    if (fg_uuid) {
                        ajxDataObj.fg_uuid = fg_uuid;
                    }

                    if (selector_value && cause_type && cause_type != "") {
                        ajxDataObj.cause_type = cause_type;
                    }
                }

                if (path) {
                    ajxDataObj.path = path;
                }

                var reqObj = $.ajax({
                    type: 'POST',
                    url: data_url,
                    data: ajxDataObj,
                    timeout: 30000,
                    dataType: "jsonp",
                    success: function(data) {
                        UpdateData = data;

                        if (UpdateData.error) {
        
                            alert("Oops! Please refresh this page, then try again.");
                            $("#cbw-widget").removeClass("cbw-widget-show");
                            $("#cbw-widget").addClass("cbw-widget-hide");
                            $("#cbw-cause-select").select2("close");
                            $("#cbw-fgcause-select").select2("close");

                        }
                                            },
                    error: function(data, status, xhr) {

                        // should probably be silent to user...
                        alert('error registering share: ' + status);
                    },
                    complete: function(jqXHR, textStatus) {
                    }
                });

                reqObj.done(callback);

            }

            function MergeServeUpdateData(data, status, xhr) {

                // replace the ServeData values with new values returned from the UpdateServe
                // api dataset:
                ServeData.email = UpdateData.email;
                ServeData.cause_type = UpdateData.cause_type;
                ServeData.fg_uuid = UpdateData.fg_uuid;
                ServeData.event_uid = UpdateData.event_uid;
                ServeData.cause_name = UpdateData.cause_name;
                ServeData.cause_uid = UpdateData.cause_uid;

                // Update the CurrentCauseRadioButtonVal with radio button value associated with the
                // current, newly changed selected cause
                CurrentCauseRadioButtonVal = $("[name=cause-type-radio]:checked").val();

                // Replace the links with new ones from server
                for (var i in ServeData.paths) {
                    // alert(i + " :: " + ServeData.paths[i] + " :: " + data.paths[i] );
                    ServeData.paths[i] = UpdateData.paths[i];
                };

                // Populate the currently selected cause name supplied by the server
                $("#cbw-currently-selected-cause-text").text(ServeData.cause_name);

                PositionSearchIcon();

                // Now Check to see if the purchase channel is active and if it is, get the path and use it to update
                // the AWESM cookies and the AWESM.parentAwesm global variable

                if (ServeData.paths['purchase']) {

                    PurchasePathUpdate(ServeData.paths["purchase"]);

                }

            }               

            /* ---------------------------------------------------------------------------------
             * GetExpireMins()
             * ---------------------------------------------------------------------------------
             * This function is called to get the number of minutes from now until the desired
             * expiration time of a serve, which is passed in the json from the serve api.
             * --------------------------------------------------------------------------------- */
            function GetExpireMins() {

                // create a new date object and set it equal to the serve created_at date plus the
                // cookie life for that serve (both received in the json from the serve api.)  This
                // is the desired serve expiration date

                var expireDate = new Date(Date.parse(ServeData.created_at) + (parseInt(ServeData.cookie_life)*1000*60*60*24)).toGMTString();

                // convert the desired expire date from into milliseconds
                var expireDateInMs = Date.parse(expireDate);

                // now get the current time in ms
                var currentDateInMs = Date.now();

                // now calculate the number of minutes from now until the desired expiration date
                var expire_mins = (expireDateInMs - currentDateInMs)/(1000*60);

                return expire_mins;

            }

            /* ---------------------------------------------------------------------------------
             * PurchasePathUpdate(path)
             * ---------------------------------------------------------------------------------
             * This function is called whenever purchase path values are loaded or reloaded. 
             *
             * @path   = path value of the current purchase channel link
             * --------------------------------------------------------------------------------- */
            function PurchasePathUpdate(path) {
     
                // Set or update the path cookie with the current purchase path
                if (path) {
                    // First, get the number of minutes until the expiration of the current serve
                    var expire_mins = GetExpireMins();
                    // Now set the path cookie ...
                    SetCookie("cbwpath", path, expire_mins, "/");
                }  
            }

            /* ---------------------------------------------------------------------------------
             * PositionWidget(type)
             * ---------------------------------------------------------------------------------
             * Add content
             * --------------------------------------------------------------------------------- */
            function PositionWidget(type) {
                // type should be 'initial' for the first time the widget is opened or for
                // repositioning of the widget due to window resizing, otherwise it should be
                // 'reposition' for all subsequent widget positioning.

                var widget_width = $("#cbw-widget").width();
                var widget_hgt = $("#cbw-widget").height();

                var win_hgt = $(window).height();
                var win_width = $(window).width();

                var widget_left = $("#cbw-widget").position().left;
                var widget_top = $("#cbw-widget").position().top;
                var widget_bottom = widget_top + widget_hgt;
                var widget_right = widget_left + widget_width;

                var space = '5px';

                switch (WidgetPosition) {

                    case 'top-left':

                        $("#cbw-widget").css('top', space);
                        $("#cbw-widget").css('left', space);
                        $("#cbw-widget").css('bottom', '');
                        $("#cbw-widget").css('right', '');
                        break;

                    case 'top-center':

                        $("#cbw-widget").css('top', space);
                        $("#cbw-widget").css('left', ((win_width-widget_width)/2));
                        $("#cbw-widget").css('bottom', '');
                        $("#cbw-widget").css('right', '');
                        break;

                    case 'top-right':

                        $("#cbw-widget").css('top', space);
                        $("#cbw-widget").css('right', space);
                        $("#cbw-widget").css('bottom', '');
                        $("#cbw-widget").css('left', '');
                        break;

                    case 'left-center':

                        if (type == "initial") {
                            $("#cbw-widget").css('top', ((win_hgt-widget_hgt)/2));
                            $("#cbw-widget").css('left', space);
                            $("#cbw-widget").css('bottom', '');
                            $("#cbw-widget").css('right', '');
                        }
                        break;

                    case 'center':

                        if (type == "initial") {
                            $("#cbw-widget").css('top', ((win_hgt-widget_hgt)/2));
                            $("#cbw-widget").css('left', ((win_width-widget_width)/2));
                            $("#cbw-widget").css('bottom', '');
                            $("#cbw-widget").css('right', '');
                        }
                        break;

                    case 'right-center':

                        if (type == "initial") {
                            $("#cbw-widget").css('top', ((win_hgt-widget_hgt)/2));
                            $("#cbw-widget").css('right', space);
                            $("#cbw-widget").css('bottom', '');
                            $("#cbw-widget").css('left', '');
                        }
                        break;

                    case 'bottom-left':

                        $("#cbw-widget").css('bottom', space);
                        $("#cbw-widget").css('left', space);
                        $("#cbw-widget").css('top', '');
                        $("#cbw-widget").css('right', '');
                        break;

                    case 'bottom-center':

                        $("#cbw-widget").css('bottom', space);
                        $("#cbw-widget").css('left', ((win_width-widget_width)/2));
                        $("#cbw-widget").css('top', '');
                        $("#cbw-widget").css('right', '');
                        break;

                    case 'bottom-right':

                        $("#cbw-widget").css('bottom', space);
                        $("#cbw-widget").css('right', space);
                        $("#cbw-widget").css('top', '');
                        $("#cbw-widget").css('left', '');
                        break;

                    default:
                        // set to right-center position.  This should never happen as it requires
                        // both an invalid widget-position value from the merchant web page and
                        // an invalid widget position value from the serve data.

                        if (type == "initial") {
                            $("#cbw-widget").css('top', ((win_hgt-widget_hgt)/2));
                            $("#cbw-widget").css('right', space);   
                            $("#cbw-widget").css('bottom', '');
                            $("#cbw-widget").css('left', '');
                        }
                }

                // following ensures that the top right corner of the widget is always visible,
                // even when the window shrinks or the widget expands in such a way that it
                // would become hidden. This way the widget can be closed by the user.
                if (win_width < widget_width) {
                    $("#cbw-widget").css('right', space);
                    $("#cbw-widget").css('left', '');
                }

                if (win_hgt < widget_hgt) {
                    $("#cbw-widget").css('top', '1px');
                    $("#cbw-widget").css('bottom', '');
                }
            }

            /* ---------------------------------------------------------------------------------
             * PositionCauseSelector()
             * ---------------------------------------------------------------------------------
             * Add content
             * --------------------------------------------------------------------------------- */
            function PositionCauseSelector() {
                // determines whether to offset the position of the cause selector dialog to the left
                // when the widget is positioned on the right side of the window, or offset to the
                // right for all other widtet positions.

                switch (WidgetPosition) {

                    case 'top-right':
                    case 'right-center':
                    case 'bottom-right':

                        $("#cbw-cause-selector").css('top', '-30px');
                        $("#cbw-cause-selector").css('left', '-20px');
                        $("#cbw-cause-selector").css('bottom', '');
                        $("#cbw-cause-selector").css('right', '');
                        break;

                    default:
                        // set to be offset to the right and down for all other widget positions.

                        $("#cbw-cause-selector").css('top', '-30px');
                        $("#cbw-cause-selector").css('left', '20px');
                        $("#cbw-cause-selector").css('bottom', '');
                        $("#cbw-cause-selector").css('right', '');
                        break;
                }

            }

            /* ---------------------------------------------------------------------------------
             * CloseChannel()
             * ---------------------------------------------------------------------------------
             * Add content
             * --------------------------------------------------------------------------------- */
            function CloseChannel() {

                // Remove the on and hover classes for this channel, then
                // add the off class
                SelectedChannel.find(".channel-icon").removeClass("channel-icon-on");
                SelectedChannel.find(".channel-icon").removeClass("channel-icon-hover");
                SelectedChannel.find(".channel-icon").addClass("channel-icon-off");
                
                // Remove the channel-selected class for this channel
                SelectedChannel.removeClass("channel-selected");

                // Hide the share message editor for this channel
                $("#cbw-share-msg-ctrl-grp").removeClass("cbw-widget-show");
                $("#cbw-share-msg-ctrl-grp").addClass("cbw-widget-hide");

                // Reposition the widget to account for its new size
                PositionWidget('reposition');

            }

            /* ---------------------------------------------------------------------------------
             * OpenChannel()
             * ---------------------------------------------------------------------------------
             * Add content
             * --------------------------------------------------------------------------------- */
            function OpenChannel() {

                // Remove the off and hover classes for this channel, then
                // add the on class
                SelectedChannel.find(".channel-icon").removeClass("channel-icon-off");
                SelectedChannel.find(".channel-icon").removeClass("channel-icon-hover");
                SelectedChannel.find(".channel-icon").addClass("channel-icon-on");

                // Add the channel-selected class for this channel
                SelectedChannel.addClass("channel-selected");

                // following rem'd out to disable user field editing:

                // if (!ServeData.channels[chidx].user_fields) {

                    PostToChannel();

                // } else {

                //     $("#cbw-share-msg-ctrl-grp").show();

                //     PositionWidget('reposition');
                    
                // }
            }

            /* ---------------------------------------------------------------------------------
             * SelectChannel()
             * ---------------------------------------------------------------------------------
             * Add content
             * --------------------------------------------------------------------------------- */
            function SelectChannel() {

                var chidx = SelectedChannel.attr('idx');

                // following rem'd out to disable user field editing:

                // $("#cbw-share-msg").val("");

                // if (ServeData.channels[chidx].user_fields) {

                //     var user_fields = ServeData.channels[chidx].user_fields;

                //     var elem = $("#" + user_fields.elem_id);
                //     var defval = user_fields.default; // default is either the default value or a reference to another field in JSON to take it from
                //     var deftype = user_fields.def_type; // reference = take defval from another field, o/w take whatever is present in user_fields.defaults

                //     if (deftype == "reference") {

                //         defval = ServeData.channels[chidx].details[defval];

                //     }

                //     defval = defval.replace("{{merchant}}", ServeData.merchant.name);

                //     elem.val(defval);

                // }

            }

            /* ---------------------------------------------------------------------------------
             * GetChannelPath(link)
             * ---------------------------------------------------------------------------------
             * This function is called when posting to a channel to get the proper path value for
             * the channel for this sharing event. 
             *
             * @link   = link value for this channel for this share event.
             * --------------------------------------------------------------------------------- */
            function GetChannelPath(link) {
                var path = ""; 
                // See if the URLTarget is set to local.  If it is, use the url to this specific page,
                // otherwise, use the default url associated with this promotion. 
                if (URLTarget == "local") {
                    // get the local page URL minus the params
                    var path = window.location.href;
                    var n = path.indexOf('?');
                    // following takes the substring of the path up to n if it exists (meaning there
                    // is a '?' in the path), or the entire string if there is no '?'
                    path = path.substring(0, n != -1 ? n : path.length);

                    // now add the FilteredParamString if it contains additional parameters that need
                    // to be added back to the URLTarget, otherwise just add the '?' which will
                    // preceed the new link param.  The FilteredParamString is the
                    // original param string from this page's URL minus the referring path param 
                    // and the CBCause param. Note that if the FilteredParamString is not null, it
                    // will start with a ?.
                    if (FilteredParamString != "") {
                        path += FilteredParamString + "&";
                    } else {
                        path += "?";
                    }
                }  else {
                    // in all other cases, use the landing page url associated with this promotion
                    path = ServeData.promotion.landing_page;
                    // now check to see if a param string exists in this url.  If it does, add an "&".
                    // If it doesn't, add a "?"
                    if (path.indexOf('?') >= 0) {
                        path += "&";
                    } else {
                        path += "?";
                    }

                }
                // now add the link param
                path += "cblink=" + link;

                return path;
            }


            /* --------------------------------------------------------
             * PostToChannel function 
             * --------------------------------------------------------
             * Posts the message to the selected channel with the selected
             * message, link, image, etc. appropriate for that channel.
             * -------------------------------------------------------- */
            function PostToChannel() {  
                var chname = SelectedChannel.attr('idx');
                var sel_channel = ServeData.channels[chname].details;
                //var awesm_link = "http://awe.sm/" + ServeData.paths[chname];
                // !!!! Must set channel_path before running UpdateServe, because
                // UpdateServe will get a new path for this channel, which is the path
                // that should be used for the next share, not this one.
                var channel_path = GetChannelPath(ServeData.paths[chname]);
                var cause_name;
                var selector_value = $("input[name='cause-type-radio']:checked").val()
                switch (selector_value) {
                    case 'default':
                        cause_name = ServeData.default_cause_name;
                        break;
                    case 'single':
                        cause_name = $("#cbw-fgcause-select").select2('data').organization_name;
                        break;
                    case '0':
                        cause_name = EventData[selector_value].name;
                        break;
                    case '1':
                        cause_name = EventData[selector_value].name;
                        break;
                    case '2':
                        cause_name = EventData[selector_value].name;
                        break;
                };

                // following rem'd to disable user field editing:
                // var share_msg = $("#cbw-share-msg").val() ? $("#cbw-share-msg").val() : sel_channel.msg;
                var share_msg = sel_channel.msg;
                // now replace the supporter_cause placeholder with the currently 
                // selected event or cause name.
                share_msg = share_msg.replace("{{supporter_cause}}", cause_name);
                // now replace the merchant_cause placeholder with the merchant's default cause 
                share_msg = share_msg.replace("{{merchant_cause}}", ServeData.default_cause_name);
                // Fix duplicate "the"s, and the "the a"s
                FixCauseNames(share_msg);

                // Now update the serve, which will record the cause or event associated
                // with this share.  This is done asynchronously so the channel will
                // open right away.
                UpdateServe(ServeData.paths[chname], MergeServeUpdateData);

                switch (chname) {

                    case 'twitter':
                        PostToTwitter(sel_channel.url_prefix, share_msg, channel_path);
                        break;
                    
                    case 'facebook':
                        var redirect_uri = sel_channel.redirect_url;
                        var link_label = sel_channel.link_label;
                        var caption = sel_channel.caption;
                        var url_prefix = sel_channel.url_prefix;

                        // *** REDIRECT_URL MUST BE FOR THE SAME DOMAIN THAT FB APP IS REGISTERED TO ***
                        // *** HARDCODING HERE FOR NOW *** //s
                        // redirect_uri = "http://causebutton.com/index.html?xyz=123";
                        // redirect_uri = "https://www.causebutton.com/facebook-success?a=12345";

                        // This is the app_id for the Facebook Causebutton app: 
                        var app_id = "1412032855697890";

                        if (sel_channel.thumb_url) {

                            var image_url = sel_channel.thumb_url;

                            PostToFacebook(url_prefix, channel_path, share_msg, redirect_uri, link_label, caption, app_id, image_url);
                        
                        } else {
                            
                            PostToFacebook(url_prefix, channel_path, share_msg, redirect_uri, link_label, caption, app_id);
                        }

                        break;

                    case 'pinterest':

                        PostToPinterest(sel_channel.url_prefix, channel_path, share_msg, sel_channel.image_url);

                        break;

                    case 'email':

                        var subject = "test email subject";

                        var body = "this is the body content of the test email";

                        PostToEmail(subject, body);
                        break;

                    default:
                        alert('inactive channel selection');
                }

            };

            /* --------------------------------------------------------
             * EmailValid (email)
             * --------------------------------------------------------
             * Checks the format of the email.  Allows letters, numbers,
             * dots and dashes before the @, same after the the @ and 
             * before the ".", then 2-4 letters or numbers.  Returns true
             * if valid, false if not.
             * -------------------------------------------------------- */
            function EmailValid (email) {

                var emlre = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

                if (email != "" && !emlre.test(email)) {
                    return false
                } else {
                    return true
                }
            };

            /* --------------------------------------------------------
             * FixCauseNames (cause_text)
             * --------------------------------------------------------
             * Checks the format of the email.  Allows letters, numbers,
             * dots and dashes before the @, same after the the @ and 
             * before the ".", then 2-4 letters or numbers.  Returns true
             * if valid, false if not.
             * -------------------------------------------------------- */
            function FixCauseNames (cause_text) {

                cause_text = cause_text.replace(/\sthe\sTHE\s/g, " THE ");
                cause_text = cause_text.replace(/\sthe\sthe\s/g, " the ");
                cause_text = cause_text.replace(/\sthe\sA\s/g, " A ");
                cause_text = cause_text.replace(/\sthe\sa\s/g, " A ");
                return cause_text
            };

            /* --------------------------------------------------------
             * BlinkErrorMessage (selector)
             * --------------------------------------------------------
             * Takes the target selector as input, blinks the selector
             * off and on twice.
             * -------------------------------------------------------- */
            function BlinkErrorMessage (selector) {

                $(selector)
                        .fadeOut(200)
                        .fadeIn(200)
                        .fadeOut(200)
                        .fadeIn(200);
            };

            /* --------------------------------------------------------
             * CheckEmailValid ()
             * --------------------------------------------------------
             * When the user exits the email input field, validate the
             * format of the input. If it is not valid, turn red and
             * disable the Post button, re-enable and turn normal
             * if valid.
             * -------------------------------------------------------- */
            function CheckEmailValid () {

                if (!EmailValid($('#cbw-email-input').val())) {
                    $("#cbw-email-ctl-grp").addClass('error');
                    // $("#cbw-email-input-error-message").show();
                    $("#cbw-email-input-error-message").removeClass("cbw-widget-hide");
                    $("#cbw-email-input-error-message").addClass("cbw-widget-show");
                    //BlinkErrorMessage("#cbw-email-input-error-message");
                } else {
                    $("#cbw-email-ctl-grp").removeClass('error');
                    // $("#cbw-email-input-error-message").hide();
                    $("#cbw-email-input-error-message").removeClass("cbw-widget-show");
                    $("#cbw-email-input-error-message").addClass("cbw-widget-hide");
                    //$("#cbw-user-name").replaceWith(email);
                }

                PositionWidget('reposition');

            };

            /* --------------------------------------------------------
             * function CloseCauseSelector()
             * --------------------------------------------------------
             * This function is called whenever the cause selector dialog
             * is closed.  It checks to see if the email is valid (to make
             * sure the email error condition is set or cleared prior to
             * calling the UpdateServe method).  Then it checks to see if 
             * there is an error on the fg cause selector (radio button 
             * checked but value is blank) and if there is an error it 
             * resets the radio button value to its previous value.  If
             * there is no error, Update Serve is called to update the
             * serve with the new cause (if one exists).
             * -------------------------------------------------------- */
            function CloseCauseSelector () {
                $("#cbw-fgcause-select").select2("close");
                $("#cbw-cause-selector").fadeOut();
                // Check to see if the email is valid.  If it is not, this will
                // set the error condition, which is important to prevent
                // the email from trying to update when the cause updates.
                CheckEmailValid();

                // If there is an error on the fg cause selector, this means
                // that the user has selected this radio button but has not
                // selected a cause from the combo box.  In this case, we
                // need to reset the radio button value to one associated
                // with the currently selected cause, which is stored in the
                // global variable CurrentCauseRadioButtonVal
                if (!$("#cbw-fgcause-select").select2("val") && $("input[name='cause-type-radio']:checked").val() == "single") {
                    $("[name=cause-type-radio]").val([CurrentCauseRadioButtonVal]);
                }

                // finally, update the serve.  If there is an error on the email
                // it will be filtered out by the UpdateServe method (note that
                // if there is an error on the fgcause selector we won't make
                // it to here.
                UpdateServe("", MergeServeUpdateData);
            };

            /* --------------------------------------------------------
             * function PositionSearchIcon()
             * --------------------------------------------------------
            * Position the currently-selected-cause-search-icon vertically
            * in the middle of the currently selected cause box.  Note that
            * the lineHeight property is expressed in multiples of line-heights,
            * so this calculation finds the overall height of the text inside
            * the box and divides it by the line-height of the text, then
            * subtracts a small amount to adjust the icon upward a bit.
             * -------------------------------------------------------- */
            function PositionSearchIcon() {
                $("#cbw-currently-selected-cause-search-icon").css({
                    lineHeight: ($("#cbw-currently-selected-cause-text").outerHeight(true)/$("#cbw-currently-selected-cause-text").css('line-height').replace('px',''))-.1
                });
            };

            /*
             * EVENT HANDLER FUNCTIONS
             * -----------------------
             * - note, this must be inside the jQuery.ready function($) or else they will be using the incorrect
             * - version of jQuery (from host page) or possibly not have access to jQuery at all...
             */

            /* --------------------------------------------------------
             * Main Cause Button Handler
             * --------------------------------------------------------
             * Activates the cause button widget and displays it in its
             * proper location based on the button, page, or promotion
             * position values as appropriate.  Any element on a page
             * that is used to open the cause button widget must include the
             * class "cbw-main-btn".  Note that the widget won't open until
             * Loaded = true, which happens when the event, serve, and content
             * data is done loading.
             * -------------------------------------------------------- */
            $(document).on('click', '.cbw-main-btn', function(event) {

                if (!Loaded) {
                    return;
                }

                var button_position = ValidatePosition($(this).attr('cbw-position'));

                if (button_position != '') {
                    WidgetPosition = button_position;
                } else if (PagePosition != '') {
                    WidgetPosition = PagePosition;
                } else {
                    WidgetPosition = ServeData.promotion.widget_position;
                }

                var button_target = ValidateTarget($(this).attr('cbw-url-target'));

                if (button_target != '') {
                    URLTarget = button_target;
                } else if (PageTarget != '') {
                    URLTarget = PageTarget;
                } else {
                    URLTarget = '';
                }

                if ($("#cbw-widget").css('display') == "none") {
                    RegisterWidgetView();
                    //$("#cbw-widget").toggle();
                    $("#cbw-widget").removeClass("cbw-widget-hide");
                    $("#cbw-widget").addClass("cbw-widget-show");

                    PositionSearchIcon();

                }

                PositionWidget('initial');

            });


            /* --------------------------------------------------------
             * Channel Icon mouseover handlers
             * --------------------------------------------------------
             * description here
             * -------------------------------------------------------- */
            $(document).on('mouseenter', '.cbw-channel-toggle', function() {

                if (!$(this).hasClass("channel-selected")) {
                    $(this).find(".channel-icon").removeClass("channel-icon-off");
                    $(this).find(".channel-icon").addClass("channel-icon-hover");
                }

            });

            $(document).on('mouseleave', '.cbw-channel-toggle', function() {

                if (!$(this).hasClass("channel-selected")) {
                    $(this).find(".channel-icon").removeClass("channel-icon-hover");
                    $(this).find(".channel-icon").addClass("channel-icon-off");
                }
            });

            /* --------------------------------------------------------
             * Email checkbox toggle hanlders
             * --------------------------------------------------------
             * This event handler toggles visibility of the email
             * input control when the checkbox value is changed.  It
             * also deletes invalid email addresses, which prevents
             * bad addresses from being sent to the api in ServeUpdates.
             * At the moment, an email value will be use in ServeUpdate
             * whether or not the email field is visible.
             * -------------------------------------------------------- */
            $(document).on('change', '#cbw-email-checkbox', function() {

                if ($("#cbw-email-ctl-grp").hasClass('error')) {

                    $("#cbw-email-input").val('');

                    $("#cbw-email-ctl-grp").removeClass('error');

                }

                if ($("#cbw-email-ctl-grp").css('display') == "none") {
                    $("#cbw-email-ctl-grp").removeClass("cbw-widget-hide");
                    $("#cbw-email-ctl-grp").addClass("cbw-widget-show");
                } else {
                    $("#cbw-email-ctl-grp").removeClass("cbw-widget-show");
                    $("#cbw-email-ctl-grp").addClass("cbw-widget-hide");
                }
            });        

            /* --------------------------------------------------------
             * This event toggles the email checkbox when the
             * text associated with the checkbox is clicked.  Both the checkbox
             * and the text need to be in the same parent class.  Then it
             * fires the checkbox change method to trigger the event above.
             * -------------------------------------------------------- */
            $(document).on("click", "#cbw-email-checkbox-label", function() {
                var checked = $('#cbw-email-checkbox').prop("checked");
                if (checked) {
                    $('#cbw-email-checkbox').prop("checked", false);
                } else {
                    $('#cbw-email-checkbox').prop("checked", true);
                }
                $('#cbw-email-checkbox').change();
            });
 

            $(window).resize(function() {

                var shown = $("#cbw-widget").css('display');

                if (shown != "none") {

                    PositionWidget('initial');
                }
            });

            $(document).on('click', '.cbw-exit-link', function() {

                CloseChannel();

            });

            $(document).on('click', '.cbw-post-link', function() {

                PostToChannel();

            });

            $(document).on('click', '#cbw-links-info-toggle', function() {

                var display = $("#cbw-links-info").css('display');


                //$("#cbw-links-info").toggle();

                if (display == "none") {

                    $("#cbw-links-info").removeClass("cbw-widget-hide");
                    $("#cbw-links-info").addClass("cbw-widget-show");
                    $("#cbw-links-info-toggle").html("less info"); 

                } else {

                    $("#cbw-links-info").removeClass("cbw-widget-show");
                    $("#cbw-links-info").addClass("cbw-widget-hide");
                    $("#cbw-links-info-toggle").html("more info");

                }

                PositionWidget('reposition');

            });

            /* --------------------------------------------------------
             * Channel Selection Icon Click Handler
             * --------------------------------------------------------
             * Hides channel icons, shows share again buttons, shows email
             * input box.  Checks to see if the email is invalid and if it does it
             * blinks the email error message.  We no longer need to check
             * the event selector because it is no longer a Select2
             * combo box, and we shouldn't need to check the fgcause 
             * selector as it should be impossible to get to the 
             * main view with an fgcause error.
             * -------------------------------------------------------- */
            $(document).on('click', '.cbw-channel-toggle', function() {

                $(".cbw #cbw-widget #cbw-channels-grp").removeClass("cbw-widget-show");
                $(".cbw #cbw-widget #cbw-channels-grp").addClass("cbw-widget-hide");
                $(".cbw #cbw-widget #cbw-share-again").removeClass("cbw-widget-hide");
                $(".cbw #cbw-widget #cbw-share-again").addClass("cbw-widget-show");
                $(".cbw #cbw-widget .email").removeClass("cbw-widget-hide");
                $(".cbw #cbw-widget .email").addClass("cbw-widget-show");


                // var was_an_error1 = false;
                // var was_an_error2 = false;
                var was_an_error3 = false;

                // if ($("#cbw-cause-select-ctrl-grp").hasClass('error')) {
                //     was_an_error1 = true;
                // }
                // if ($("#cbw-fgcause-select-ctrl-grp").hasClass('error')) {
                //     was_an_error2 = true;
                // }
                if ($("#cbw-email-ctl-grp").hasClass('error')) {
                    was_an_error3 = true;
                }

                CheckEmailValid();

                // if ($("#cbw-cause-select-ctrl-grp").hasClass('error')) {
                //     if (was_an_error1) {
                //         BlinkErrorMessage("#cbw-cause-select-ctrl-grp");
                //     }
                //     return
                // }
                // if ($("#cbw-fgcause-select-ctrl-grp").hasClass('error')) {
                //     if (was_an_error2) {
                //         BlinkErrorMessage("#cbw-fgcause-select-ctrl-grp");
                //     }
                //     return
                // }
                if ($("#cbw-email-ctl-grp").hasClass('error')) {
                    if (was_an_error3) {
                        BlinkErrorMessage("#cbw-email-ctl-grp");
                    }
                    return
                }

                if (SelectedChannel) {

                    if ($(this).hasClass("channel-selected")) {

                        // following rem'd as part of disabling user field editing
                        // the share_msg box never opens, there's no real reason
                        // to "close" an open channel when a user clicks on the
                        // open channel's icon.  Instead, this action should
                        // open the channel again, which is added below.

                        // if (SelectedChannel.attr('src').indexOf('-on.png') >= 0) {

                        //     CloseChannel();

                        // } else {

                        //     OpenChannel();
                        // }

                        OpenChannel();

                    } else {

                        CloseChannel();

                        SelectedChannel = $(this);

                        // this doesn't do anything anymore
                        // SelectChannel();

                        OpenChannel();

                    }

                } else {

                    SelectedChannel = $(this);

                    // this doesn't do anything anymore
                    // SelectChannel();

                    OpenChannel();
                }

            });


            /* --------------------------------------------------------
             * FG Cause (single cause) Change Handler 
             * --------------------------------------------------------
             * Handles events triggered on a change in cbw-fgcause-select,
             * which is the cause selector.  This updates the text in 
             * the share message (facebook only right now) so that it
             * dynamically upates with the currently selected event.  It
             * also checks consistency between cause_type and cause if
             * an error condition exists and will clear the error if
             * appropriate.
             * -------------------------------------------------------- */
             $(document).on('change', '#cbw-fgcause-select', function(e) {

                 $("#cbw-cause-type-single").prop('checked', true);

            //     // following rem'd to disable user field editing:
            //     // var share_msg = $("#cbw-share-msg").val();
            //     // var added = e.added.text;
            //     // var removed = e.removed.text;
            //     // if (share_msg) {
            //     //     share_msg = share_msg.replace(removed, added);
            //     //     $("#cbw-share-msg").val(share_msg);
            //     // } 
            });

            /* --------------------------------------------------------
             * Post Button Handler 
             * --------------------------------------------------------
             * For channels that have channel-specified fields and display a
             * post button in the display area for those fields, 
             * this handler simply calls the PostToChannel function.
             * -------------------------------------------------------- */
            $(document).on('click', '#cbw-post-button', function() {
                PostToChannel();
            });

            /* --------------------------------------------------------
             * Close Widget Handler 
             * --------------------------------------------------------
             * This handler executes when the close icon at the top left of
             * the widget is clicked, or when the share again done butgon
             * is clicked.  This simply closes the widget and attempts to update the
             * serve.  If there are email or cause errors present when the widget
             * is closed, they will be caught and dealt with in the serve 
             * update method serve.  If the cause selector dialog is open
             * it will be hidden, and if the fgcause combo box is open,
             * it will be closed.
             * -------------------------------------------------------- */
            $(document).on('click', '.cbw #cbw-widget #cbw-heading-close, .cbw #cbw-widget #cbw-share-again-done-button', function() {

                CheckEmailValid();
                // next, hide the widget and close any open select2 selectors
                // $("#cbw-widget").hide();
                $("#cbw-widget").removeClass("cbw-widget-show");
                $("#cbw-widget").addClass("cbw-widget-hide");
                $("#cbw-fgcause-select").select2("close");

                // Finally, call CloseCallSelector().  This will close the
                // Cause Selector dialog if it is open, fix any fg cause
                // errors if they exist, and then update the Serve.
                CloseCauseSelector();
            });

            /* --------------------------------------------------------
             * Share Again Button Handler 
             * --------------------------------------------------------
             * This simply hides the share again buttons, reveals the
             * channel icons, and hides the email input box.
             * -------------------------------------------------------- */
            $(document).on('click', '.cbw #cbw-widget #cbw-share-again-button', function() {

                $(".cbw #cbw-widget #cbw-channels-grp").removeClass("cbw-widget-hide");
                $(".cbw #cbw-widget #cbw-channels-grp").addClass("cbw-widget-show");
                $(".cbw #cbw-widget #cbw-share-again").removeClass("cbw-widget-show");
                $(".cbw #cbw-widget #cbw-share-again").addClass("cbw-widget-hide");
                $(".cbw #cbw-widget .email").removeClass("cbw-widget-show");
                $(".cbw #cbw-widget .email").addClass("cbw-widget-hide");
            });

            /* --------------------------------------------------------
             * Email checkbox and input handlers
             * --------------------------------------------------------
             * These handlers check for cause and email input errors. 
             * -------------------------------------------------------- */
            $(document).on('click', '#cbw-email-checkbox-ctl-grp', function() {
                CheckEmailValid();
            });
            $(document).on('click', '#cbw-email-ctl-grp', function() {
                CheckEmailValid();
            });

            /* --------------------------------------------------------
             * Cause radio button text selection handlers
             * --------------------------------------------------------
             * These handlers check the correct radio button when the
             * text associated with that button is checked.  Both the radio button
             * and the text need to be in the same parent class.
             * -------------------------------------------------------- */
            $(document).on("click", ".cbw-cause-radio-button-box", function() {
                $(this).find('.cause-select-radio').prop("checked", true);
            });

            /* --------------------------------------------------------
             * Cause Selector Handlers 
             * --------------------------------------------------------
             * This opens the cause selector dialog when the change cause link is clicked.
             * -------------------------------------------------------- */
            $(document).on('click', '.cbw #cbw-change-cause-label, .cbw #cbw-currently-selected-cause-radio-button-box', function(event) {

                // first, set the proper position for the cause selector dialog
                PositionCauseSelector();
                $("#cbw-cause-selector").fadeIn();

                // important to stop propogation of this event, otherwise it will
                // trigger the listener below that closes the cause selector.
                event.stopPropagation();

            });

            /* --------------------------------------------------------
             * This event is fired with the user clicks the close icon from
             * the change selector.  If first checks to see if there is an error
             * on the fgcause selector, and if there is it sets the error 
             * condition and returns.  If there is no error, it hides 
             * the cause selector, shows the main page, and calls the update
             * method of the api.  When the update method returns, the new
             * cause will be returned and written into the currently selected
             * cause value.
             * -------------------------------------------------------- */
            $(document).on('click', '.cbw #cbw-cause-selector-close', function(event) {
                CloseCauseSelector();
            });

            /* --------------------------------------------------------
             * This event is fired with the user clicks anywhere on the page other
             * than on the cause selector dialog.  It closes the dialog, then
             * attempts to update the cause and the serve, just like when
             * the user closes the dialog by clicking the close button.
             * If first checks to see if there is an error
             * on the fgcause selector, and if there is it sets the error 
             * condition and returns.  If there is no error, it hides 
             * the cause selector, shows the main page, and calls the update
             * method of the api.  When the update method returns, the new
             * cause will be returned and written into the currently selected
             * cause value.
             * -------------------------------------------------------- */
            $(document).click(function(event) { 
                if(!$(event.target).closest('#cbw-cause-selector').length) {
                    if($('#cbw-cause-selector').is(":visible")) {
                        CloseCauseSelector();
                    }
                }        
            });

            $(document).on('click.cbw-modal', 'a[rel="cbw-modal:close"], .cbw-close-modal', function(event) {
                $("#cbw-modal-blocker-div").remove();
                $("#cbw-modal-1").hide();

            });



       }); // end jquery.documentready

        /*** NOTE - ANY FUNCTIONS DEFINED OUT HERE WILL NOT HAVE ACCESS TO JQUERY PROPERLY DUE TO jQuery.noConflict(true) ***/

        /* --------------------------------------------------------
         * PostToTwitter(message)
         * --------------------------------------------------------
         * Posts the specified message to twitter feed of active user
         * -------------------------------------------------------- */
        function PostToTwitter(url_prefix, message, link) {

            // can add: in_reply_to, hashtags, related, 

            // var result = AWESM.share.twitter({
            //   'text': message,
            //   'url': channel_path
            // });

            var apiCall = url_prefix + encodeURIComponent(link) + "&text=" + encodeURIComponent(message);

            var windowName = "causebutton_twitter_share_window";

            var windowSpecs = "width=550,height=258,resizable=0,scrollbars=0,menubar=0,toolbar=0,status=0,location=0,titlebar=0";

            window.open(apiCall, windowName, windowSpecs);

        }

        /*
         * PostToFacebook
         * -------------------
         * Post the specified URL to facebook with the specified default message using the specified FB App ID
         * redirect URI, caption, label for the URL can also be specified 
         **/
        function PostToFacebook(url_prefix, link, message, redirect_uri, link_label, caption, app_id, image_url) {

            /* url          = the URL the user will be redirected to when they click (link shown as 'name'), this will be the awe.sm URL
             * app_id       = Facebook App ID to post using (will say via ...)
             * redirect_uri = content that will replace the FB Pop-Up when you click Share (or Cancel), user will be redirected here
             * name         = the text that will be displayed for the link at the top of the post (clickable)
             * caption      = sub-text right below the link that is shared
             * description  = the main body of the message to be posted (not editable by the user, user will have the ability to add their own comment)
             * image_url    = Optional URL of image to include with post
             */

            // var postObj = {
            //     'url': link,
            //     'app_id': app_id,
            //     'redirect_uri': redirect_uri,
            //     'name': link_label,
            //     'caption': caption,
            //     'description': message
            // };

            // if (image_url) {
            //     postObj.picture = image_url;
            // }

            // var result = AWESM.share.facebook_post(postObj);

            var apiCall = url_prefix + encodeURIComponent(link) + "&app_id=" + app_id + "&redirect_uri=" + encodeURIComponent(redirect_uri) + "&display=popup&picture=" + encodeURIComponent(image_url) + "&name=" + encodeURIComponent(link_label) + "&caption=" + encodeURIComponent(caption) + "&description=" + encodeURIComponent(message);

            var windowName = "causebutton_facebook_share_window";

            var windowSpecs = "width=640,height=370,resizable=0,scrollbars=0,menubar=0,toolbar=0,status=0,location=0,titlebar=0";
            
            window.open(apiCall, windowName, windowSpecs);

        }


        /*
         * PostToPinterest
         * --------------------
         * Post the specified URL to pinterest with the specified message and image
         **/
        function PostToPinterest(url_prefix, link, message, image_url) {

            /* url          = destination URL user will end up at after clicking on the image on pinterest (awe.sm URL)
             * image_url    = the URL to the image that will be posted to the user's pinterest stream
             * message      = the message that will be pre-populated in the intermediate dialog and ultimately posted to the user's pintrest feed (editable by user)
             */

            // var result = AWESM.share.pinterest({
            //     'url': target_url,
            //     'image': image_url,
            //     'description': message
            // });

            var apiCall = url_prefix + encodeURIComponent(link) + "&media=" + encodeURIComponent(image_url) + "&description=" + encodeURIComponent(message);

            var windowName = "causebutton_pinterest_share_window";

            var windowSpecs = "width=665,height=350,resizable=0,scrollbars=0,menubar=0,toolbar=0,status=0,location=0,titlebar=0";

            window.open(apiCall, windowName, windowSpecs);

        }

        /*
         * PostToEmail
         * --------------------
         * Post to email using the specified subject and email body
         **/
        function PostToEmail(subject, body) {

            /* url          = destination URL user will end up at after clicking on the image on pinterest (awe.sm URL)
             * image_url    = the URL to the image that will be posted to the user's pinterest stream
             * message      = the message that will be pre-populated in the intermediate dialog and ultimately posted to the user's pintrest feed (editable by user)
             */
            // var result = AWESM.share.email({
            //     'subject': subject,
            //     'body': body
            // });
        }

        /*
         * PostToLinkedin
         * --------------------
         * Post to linkedin
         **/
        function PostToLinkedin(target_url) {

            /* url          = destination URL user will end up at after clicking on the image on pinterest (awe.sm URL)
             * image_url    = the URL to the image that will be posted to the user's pinterest stream
             * message      = the message that will be pre-populated in the intermediate dialog and ultimately posted to the user's pintrest feed (editable by user)
             */
            // var result = AWESM.share.linkedin({
            //     'url': target_url
            // });
        }

        /*
         * PostToGoogleplus
         * --------------------
         * Post to googleplus
         **/
        function PostToGoogleplus(target_url) {

            /* url          = destination URL user will end up at after clicking on the image on pinterest (awe.sm URL)
             * image_url    = the URL to the image that will be posted to the user's pinterest stream
             * message      = the message that will be pre-populated in the intermediate dialog and ultimately posted to the user's pintrest feed (editable by user)
             */
            // var result = AWESM.share.googleplus({
            //     'url': target_url
            // });
        }

    } // end main()

    // Get the query string parameters passed into this page
    function getUrlVars() {

        var vars = [], hash;

        if (window.location.href.indexOf('?') >= 0) {

            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');

            for (var i=0; i < hashes.length; i++) {

                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = hash[1];
            }

        }
        return vars;
    }

    /* ---------------------------------------------------------------------------------
     * AddStylesheet(id, href)
     * ---------------------------------------------------------------------------------
     * Adds a stylesheet <link> element to the current page with the specified
     * id and href
     *
     * @id   = id attribute to use on the generated link tag
     * @href = href (source of css file) to use for generated link tag
     * --------------------------------------------------------------------------------- */
    function AddStylesheet(id, href) {

        var head = document.getElementsByTagName('head')[0];
        var link = document.createElement('link');

        link.id = id;
        link.rel = 'stylesheet';
        link.type = 'text/css';
        link.href = href;
        link.media = 'all';
        
        head.appendChild(link);
    }

    function GetCookie(check_name) {
      
      // first we'll split this cookie up into name/value pairs
      // note: document.cookie only returns name=value, not the other components
      var a_all_cookies = document.cookie.split( ';' );
      var a_temp_cookie = '';
      var cookie_name = '';
      var cookie_value = '';
      var b_cookie_found = false; // set boolean t/f default f

      for ( i = 0; i < a_all_cookies.length; i++ )
      {
        // now we'll split apart each name=value pair
        a_temp_cookie = a_all_cookies[i].split( '=' );

        // and trim left/right whitespace while we're at it
        cookie_name = a_temp_cookie[0].replace(/^\s+|\s+$/g, '');

        // if the extracted name matches passed check_name
        if ( cookie_name == check_name )
        {
          b_cookie_found = true;
          // we need to handle case where cookie has no value but exists (no = sign, that is):
          if ( a_temp_cookie.length > 1 )
          {
            cookie_value = unescape( a_temp_cookie[1].replace(/^\s+|\s+$/g, '') );
          }
          // note that in cases where cookie is initialized but no value, null is returned
          return cookie_value;
          break;
        }
        a_temp_cookie = null;
        cookie_name = '';
      }
      if ( !b_cookie_found )
      {
        return null;
      }
    }

    function SetCookie(name, value, expires, path, domain, secure )
    {
      // set time, it's in milliseconds
      var today = new Date();

      today.setTime(today.getTime());

      /* expires in 'expires' minutes */
      if (expires) {
        expires = expires * 1000 * 60;
      }
      
      var expires_date = new Date(today.getTime() + (expires));

      document.cookie = name + "=" + escape(value) +
      ((expires) ? ";expires=" + expires_date.toGMTString() : "") +
      ((path) ? ";path=" + path : "") +
      ((domain) ? ";domain=" + domain : "") +
      ((secure) ? ";secure" : "");
    }

    // this deletes the cookie when called
    function DeleteCookie( name, path, domain ) {
      if ( Get_Cookie( name ) ) document.cookie = name + "=" +
      ( ( path ) ? ";path=" + path : "") +
      ( ( domain ) ? ";domain=" + domain : "" ) +
      ";expires=Thu, 01-Jan-1970 00:00:01 GMT";
    }

    /* ---------------------------------------------------------------------------------
     * GetReferringPathAndCause(params)
     * ---------------------------------------------------------------------------------
     * Searches through the params array for referral path values with names that
     * match the sources of paths.  Currently supporting two variations of Awe.sm links
     * and 'cblink' links.
     * --------------------------------------------------------------------------------- */
    function GetReferringPathAndCause (params) {

        var h1, h2;
        FilteredParamString = '?';
        for (var i = 0, l = params.length; i < l; i++) {
            h1 = params[i];
            h2 = params[h1];
            if (h1 == 'awesm' && h2 && h2.indexOf('awe.sm_') == 0) {
                ReferringPath = h2.substring(7);
            } else if (h1 == 'fb_ref' && h2 && h2.indexOf('awesm') == 0) {
                ReferringPath = decodeURIComponent(h2).substring(13);
            } else if (h1 == 'cblink') {
                ReferringPath = h2;
            } else if (h1 == 'cbcause') {
                CBCauseID = h2;
            } else {
                if (FilteredParamString != '?') {
                    FilteredParamString += "&";
                }
                FilteredParamString += h1 + "=" + h2
            }
        }
        // If the Filtered Param String still just contains ?, reset it to a blank string
        if (FilteredParamString == '?') {
            FilteredParamString = "";
        }
    }

})(); // immediately call our anonymous function here...