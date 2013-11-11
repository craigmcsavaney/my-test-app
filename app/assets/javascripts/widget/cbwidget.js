    var CBServeUrlBase;
    var CBMerchantID;
    var CBPurchasePath;

function CBSale(amount,transaction_id) {

    CBjQ = window.jQuery;
    CBjQ(document).ready(function($CB) {

        var method = "sale";

        var ajxDataObj = new Object();

        if (CBMerchantID) {
            ajxDataObj.merchant_id = CBMerchantID;
        }

        if (CBPurchasePath) {
            ajxDataObj.path = CBPurchasePath;
        }

        if (amount) {
            ajxDataObj.amount = amount;
        }

        if (transaction_id) {
            ajxDataObj.transaction_id = transaction_id;
        }

        var data_url = CBServeUrlBase + method;

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

    })
}

/*
 * Cause Button Widget Scripts
 * ---------------------------
 * Scripts here are responsible for loading and controlling the cause button and the cause button widget body
 * everything needs to be defined within this function to avoid potential conflicts with the host page.
 * It will be called automatically via the () at the end of the function.
 **/

(function() {
    var WidgetPosition;
    var SelectedChannel;
    var all_scripts = document.getElementsByTagName('script');
    var script_url;
    var ServeData;
    var CauseData;
    var WidgetData;
    var ScriptsCounter;
    var ReferringPath;
    var URLTarget;
    var FilteredParamString;  // original param string minus all referring path param(s)
 
    // iterate through the loaded scripts looking for the current one (must specify id on the tag for this to work)
    // an alternative implementation would be to look for 'cbwidget.js' in the title which would fail if we were to
    // change the name of the script (not sure which method is better)
    for (var i=0; i < all_scripts.length; i++) {
        if (all_scripts[i].id == "cbw-script") {
            script_url = all_scripts[i].src;
        }
    }

    URLPrefix  = script_url.substring(0,script_url.lastIndexOf("/") + 1);

    CBMerchantID = document.getElementById("cb-widget-replace").getAttribute("cbw-merchant-id");

    CBServeUrlBase = "https://morning-savannah-7661.herokuapp.com/api/v1/";

    // Chain load the scripts here in the order listed below...
    // when the last script in the chain is loaded, main() will be called
    // IMPORTANT: jQuery must be the first script in the list!!!!  If it is not
    // and there is a copy of jQuery 1.10.1 already loaded, the first
    // script in the list will be skipped.

    var scripts = [
        {"name": "jQuery", "src": "http://ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js", "custom_load": JQueryCustomLoad },
        {"name": "Bootstrap", "src": URLPrefix + "../widget/bootstrap.min.js"},
        {"name": "Select2", "src": URLPrefix + "../widget/select2.js"},
    ];

    // Set the ScriptsCounter to 0.  This is incremented as the scripts are loaded
    // and used to keep track of progress through the script list.

    ScriptsCounter = 0;

    //Start Loading Scripts

    if (window.jQuery === undefined || window.jQuery.fn.jquery != '1.10.1') {

        // Load our version of jQuery and start chain here...
        CreateScriptTag(scripts[0].name, scripts[0].src);   

    } else {

        // Version of jQuery already loaded is fine
        jQuery = window.jQuery;

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
        // call the main() function.

        if (scr) {

            CreateScriptTag(scr.name, scr.src)
        
        } else {

            // This is the last script in the page, call main()
            main();
        }
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

        jQuery = window.jQuery.noConflict(true);
    }
    
    /* --------------------------------------------------------------------------------------------------------
     * main()
     * --------------------------------------------------------------------------------------------------------
     * This is the main function that will perform most of the functionality of the cause widget creation
     * It will *only* be called after the necessary scripts have been loaded in the prescribed order in the
     * main anonymous function. It will be called by the script load handler of the last script to load
     * -------------------------------------------------------------------------------------------------------- */
    function main() {

        /* --------------------------------------------------------------------------------------------------------
         * jQuery(document).ready(function($)
         * --------------------------------------------------------------------------------------------------------
         * This is the equivalent of the typical $(document).ready(function() {}) call that is called when 
         * jQuery indicates that the page is 'ready'. Put all code that requires jQuery in here!
         * -------------------------------------------------------------------------------------------------------- */
        jQuery(document).ready(function($) {

        // Dynamically load the pre-requisite and local stylesheets

        AddStylesheet('cbw-bs-css', URLPrefix + ".." + "/widget/cbw-bootstrap.css");
        AddStylesheet('cbw-css-sel2', URLPrefix + ".." + "/widget/select2.css");
        AddStylesheet('cbw-css', URLPrefix + "cbwidget.css");

        // get the parameters passed into the page so that we can carry these forward if necessary
        // for example, as part of the process of determining the landing page or promotion id
        var params = getUrlVars();

        // set the ReferingPath variable equal to blank.  Ensures the param will be passed with the api call.
        ReferringPath = "";

        // set the FilteredParamString variable equal to blank.  This will only change if the params.length
        // is > 0, which will call GetReferringPath(params).
        FilteredParamString = "";

        // now check to see if the page url params contains a referral path.  If it does, the FilteredParamString 
        // variable will be populated with all the params except the referral path params, and the ReferringPath
        // variable will be set to the correct param path.
        if (params.length > 0) {
            GetReferringPath(params);
            CBPurchasePath = ReferringPath;
        } 

        // This is the id value of the div to which the entire widget will be appended - must match the name used on the parent web page
        var div = $("#cb-widget-replace");

        // Get the widget position value from the div on the parent web page
        WidgetPosition = div.attr("cbw-position");

        if (!WidgetPosition || WidgetPosition != "center") 
            WidgetPosition = "drop-from-button";

        // Get the cbw-url-target value from the div on the parent web page.  If the value is "local" then target links will be constructed using the link to this page when sharing into channels.  If the value is blank or "global", then target links will be constructed using the target url for this promotion from the serve json.
        URLTarget = div.attr("cbw-url-target");

        if (!URLTarget || URLTarget != "local")
            URLTarget = "global";

        // Get the widget html template and load the serve date.  When both of these are complete, merge the serve data into the widget html.
        $.when(GetWidgetHTML(), LoadServeData(CBServeUrlBase, CBMerchantID, ReferringPath)).done(function(a,b) {

            MergeServeData(div);

            // If the cause selector for this promotion is false, hide the cause selector in the widget.  Otherwise, load the cause data.
            if (!ServeData.promotion.cause_selector) {

                $("#cbw-cause-select-ctrl-grp").hide();
            
            } else {

                // When the cause data is finished loading, merge the cause data into the widget.
                $.when(LoadCausesData(CBServeUrlBase, CBMerchantID, ServeData.session_id, ServeData.serve_id)).done(function(a) {

                    MergeCauseData();

                });

            }

        });
        
        /*
         * HELPER FUNCTIONS 
         */

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

        /* ---------------------------------------------------------------------------------
         * GetReferringPath(params)
         * ---------------------------------------------------------------------------------
         * Searches through the params array for referral path values with names that
         * match the sources of paths.  Currently supporting two variations of Awe.sm links
         * and 'cblink' links.
         * --------------------------------------------------------------------------------- */
        function GetReferringPath (params) {

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
                } else {
                    if (i != 0) {
                        FilteredParamString += "&";
                    }
                    FilteredParamString += h1 + "=" + h2
                }
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
                url: CBServeUrlBase + "content",
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

        /* LoadServeData - given merchant_id, load the initial server data for active promotion
         * This will eventually replace the LoadPromotionData call
         */
        function LoadServeData(url_base, merchant_id, referring_path) {

            var method = "serve";

            var data_url = url_base + method + "/" + merchant_id;

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

        //function MergeServeData() {
        function MergeServeData(div) {

            // append the widget html to the input div

            $("<div id=\"cbw-main-div\">").html( WidgetData.content ).appendTo(div);



            if (ServeData.email) {

                $("#cbw-email-input").val(ServeData.email);
            }

            // add the cause button html to the cbw html.  

            $("#cbw-btn").append(ServeData.promotion.button_html);

            // Populate the promotion text dictated by the server

            $("#cbw-promo-text").text(ServeData.promotion.banner);

            // Populate the active channels for current merchant/promotion

            var channel_pattern = "<img class='cbw-channel-toggle' nidx='{1}' idx='{0}' id='cbw-{0}' src='../img/chn_icons/icon-{0}-off.png'/>"

            var channel_div = $("#cbw-channels");

            var channels = ServeData.display_order;

            for (var i in channels) {

                //var chname = channels[i].name.toLowerCase();
                var chname = channels[i].toLowerCase();

                // purchase is a special channel - ignore this one from user perspective
                if (chname != "purchase") {

                //    channel_div.append(channel_pattern.replace(/\{0\}/g, channels[i].name.toLowerCase()).replace(/\{1\}/g, i));
                    channel_div.append(channel_pattern.replace(/\{0\}/g, channels[i].toLowerCase()).replace(/\{1\}/g, i));
                }
            }            

            // Set and update cookies...
            // First, get the number of minutes until the expiration of the current serve
            var expire_mins = GetExpireMins();

            // Now, set the session cookie and the serve cookie

            SetCookie("cbwsession", ServeData.session_id, 30, "/");
            SetCookie("cbwserve", ServeData.serve_id, expire_mins, "/"); 

            // Check and see if this serve has already been viewed.  If it has, update the CBPurchasePath with the currebt purchase path.  Otherwise, the path doesn't get updated until the CBW is actually viewed.

            var purchase_path = "";

            if (ServeData.viewed == true) {

                if (ServeData.paths['purchase']) {

                    purchase_path = ServeData.paths["purchase"];

                }

            }

            // update the CBPurchasePath
            PurchasePathUpdate(purchase_path);

        }

        /* ---------------------------------------------------------------------------------
         * LoadCausesData(data_url, merchant_id, callback)
         * ---------------------------------------------------------------------------------
         * Loads the active promotion from the server given the merchant_id that was 
         * presumably set on the embedded div element on the host page
         *
         * @data_url    = URL to use to obtain JSON data (AJAX call)
         * @merchant_id = ID of the merchant to pass into the AJAX call
         * @callback    = Callback function to call when the AJAX call is completed
         * --------------------------------------------------------------------------------- */
        function LoadCausesData(url_base, merchant_id, session_id, serve_id) {

            var method = "causes";

            var data_url = url_base + method + "/" + merchant_id;

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
                     CauseData = data;

                    if (CauseData.error) {
    
                        alert("API error: " + CauseData.error);

                    }

                },
                error: function(data, status, xhr) {

                        alert("LoadCauseData error");

                },
                complete: function(jqXHR, textStatus) {

                }
            });
            
        }

        /* ---------------------------------------------------------------------------------
         * MergeCauseData()
         * ---------------------------------------------------------------------------------
         * This function needs to be split into two separate functions: one that loads the causes
         * list for the cause selector, and the remaining stuff probably needs to be added
         * to the MergeServeData function.
         *
         * Callback function that is called when the results of the AJAX call to pull the 
         * cause data necessary to populate the select2 cause selector.
         *
         * @data   = JSON data returned by the AJAX call (passed through as part of callback)
         * @status = Status of the AJAX call (passed through as part of callback)
         * @xhr    = jqXHR object that contains information about AJAX call 
         * --------------------------------------------------------------------------------- */
        function MergeCauseData() {

            //var causes = PromotionData.causes.cause_list;
            var cause_select = $("#cbw-cause-select");

            // Populate the cause list...eventually this will be separate from the Promotion Data
            // but for now let's do this here...

            //for (var i=0; i < causes.length; i++) {
            for (var i=0; i < CauseData.length; i++) {

                //cause_select.append(new Option(causes[i], i));
                cause_select.append(new Option(CauseData[i].name, CauseData[i].uid));
            }

            cause_select.select2();

            if (ServeData.current_cause_id) {
                cause_select.select2("val", ServeData.current_cause_id);
            } else {
                cause_select.select2("val", ServeData.promotion.default_cause);
            }

        }


        /* RegisterWidgetView - registers with server that the user clicked the cause button
         */
        function RegisterWidgetView(url_base, merchant_id) {

            var method = "view";

            var data_url = url_base + method + "/" + merchant_id;

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

        /* RegisterShareEvent - registers a post to a social media channel (or attempt to do so)
         */
        function RegisterShareEvent(url_base, merchant_id, email, cause_id, path, callback) {

            var method = "update";

            var data_url = url_base + method + "/" + merchant_id;

            // The CBW Session Cookie contains the session_id 
            var cbwSessionCookie = GetCookie("cbwsession");

            // pass these values back into the server on the AJAX call so that we can get proper values in return
            var ajxDataObj = new Object();

            if (cbwSessionCookie) {
                ajxDataObj.session_id = cbwSessionCookie;
            }

            if (email && EmailValid(email)) {
                ajxDataObj.email = email;
            }

            if (cause_id) {
                ajxDataObj.cause_id = cause_id;
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
                    //alert(data.status);
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

        function RegisterShareResult(data, status, xhr) {

            // var channel_map = { "purchase":"pur", "twitter":"tw", "facebook":"fb", "pinterest":"pin",
            //     "linkedin":"li", "email": "em"
            // };

            ServeData.current_cause_id = data.current_cause_id;
            ServeData.email = data.email;

            // Replace the links with new ones from server

            for (var i in ServeData.paths) {
                // alert(i + " :: " + ServeData.paths[i] + " :: " + data.paths[i] );
                ServeData.paths[i] = data.paths[i];

            };

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
         * PurchasePathUpdate(path)
         * ---------------------------------------------------------------------------------
         * This function is called whenever purchase path values are loaded or reloaded. 
         *
         * @path   = path value of the current purchase channel link
         * --------------------------------------------------------------------------------- */
        function PurchasePathUpdate(path) {
 
            // Set the value of the global variable CBPurchasePath equal to the purchase path
            if (path) {
                CBPurchasePath = (path);
            }  

        }

        function RepositionWidget() {

            var widget_width = $("#cbw-widget").width();
            var widget_hgt = $("#cbw-widget").height();

            var win_hgt = $(window).height();
            var win_width = $(window).width();

            var widget_left = $("#cbw-widget").position().left;
            var widget_top = $("#cbw-widget").position().top;
            var widget_bottom = widget_top + widget_hgt;
            var widget_right = widget_left + widget_width;

            switch (WidgetPosition) {

                case 'top-left':

                    $("#cbw-widget").css('top', '1px');
                    $("#cbw-widget").css('left', '1px');

                case 'top-center':

                    $("#cbw-widget").css('top', '1px');
                    $("#cbw-widget").css('left', ((win_width-widget_width)/2));

                case 'top-right':

                    $("#cbw-widget").css('top', '1px');
                    $("#cbw-widget").css('right', '1px');

                case 'left-center':

                    $("#cbw-widget").css('top', ((win_hgt-widget_hgt)/2));
                    $("#cbw-widget").css('left', '1px');

                case 'center':

                    $("#cbw-widget").css('top', ((win_hgt-widget_hgt)/2));
                    $("#cbw-widget").css('left', ((win_width-widget_width)/2));
                    // $("#cbw-widget").css('top', '50%');
                    // $("#cbw-widget").css('left', '50%');
                    // $("#cbw-widget").css('margin-top', '-225px');
                    // $("#cbw-widget").css('margin-left', '-225px');

                case 'right-center':

                    $("#cbw-widget").css('top', ((win_hgt-widget_hgt)/2));
                    $("#cbw-widget").css('right', '1px');

                case 'bottom-left':

                    $("#cbw-widget").css('bottom', '1px');
                    $("#cbw-widget").css('left', '1px');

                case 'bottom-center':

                    $("#cbw-widget").css('bottom', '1px');
                    $("#cbw-widget").css('left', ((win_width-widget_width)/2));

                case 'bottom-right':

                    $("#cbw-widget").css('bottom', '1px');
                    $("#cbw-widget").css('right', '1px');

                default:

                    // right-center:

                    $("#cbw-widget").css('top', ((win_hgt-widget_hgt)/2));
                    $("#cbw-widget").css('right', '1px');                


                    // var move_up = 0, move_left = 0;

                    // $("#cbw-widget").css("top", ((win_hgt-widget_hgt)/2));

                    // if (widget_right > win_width) {

                    //     move_left = (widget_right - win_width);
                    //     $("#cbw-widget").css("margin-left", -(move_left + 15));
                    
                    // } else {
                    
                    //     $("#cbw-widget").css("margin-left", 0);
                    // }

                    // if (widget_bottom > win_hgt) {

                    //     move_up = (widget_bottom - win_hgt);

                    //     $("#cbw-widget").css("margin-top", -(move_up + 15));
                    
                    // } else {
                    
                    //     $("#cbw-widget").css("margin-top", "5px");
                    // }
            }
        }


        function CloseChannel() {

            new_img = SelectedChannel.attr('src').replace('-on.png','-off.png');

            SelectedChannel.attr('src', new_img);   

            $("#cbw-share-msg-ctrl-grp").hide();

            RepositionWidget();

        }

        function OpenChannel() {

            new_img = SelectedChannel.attr('src').replace('-off.png','-on.png');

            SelectedChannel.attr('src', new_img);   

            var chidx = SelectedChannel.attr('idx');

            if (!ServeData.channels[chidx].user_fields) {

                PostToChannel();

            } else {

                $("#cbw-share-msg-ctrl-grp").show();

                RepositionWidget();
                
            }
        }

        function SelectChannel() {

            var chidx = SelectedChannel.attr('idx');

            $("#cbw-share-msg").val("");

            if (ServeData.channels[chidx].user_fields) {

                var user_fields = ServeData.channels[chidx].user_fields;

                var elem = $("#" + user_fields.elem_id);
                var defval = user_fields.default; // default is either the default value or a reference to another field in JSON to take it from
                var deftype = user_fields.def_type; // reference = take defval from another field, o/w take whatever is present in user_fields.defaults

                if (deftype == "reference") {

                    defval = ServeData.channels[chidx].details[defval];

                }

                defval = defval.replace("{{merchant}}", ServeData.merchant.name);

                elem.val(defval);

            }

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
            // otherwise, use the url associated with this promotion. 
            if (URLTarget == "local") {
                // get the local page URL minus the params
                path = window.location.href.slice(window.location.href.indexOf('?') + 1);
                // now add the FilteredParamString if it exists, otherwise just add the '?' which will
                // preceed the new link param.  The FilteredParamString is the
                // original param string from this page's URL minus the referring path params.
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
            var channel_path = GetChannelPath(ServeData.paths[chname]);
            var sel_cause_idx = $("#cbw-cause-select").select2("val");
            //
            // Following assignment of selected_cause var does not work.  Need to figure
            // out how to get the noun name of the selected cause.  Until this is fixed,
            // the lines below that replace {{supporter_cause}} with the cause name can't be used.
            //
            // var selected_cause = $("#cbw-cause-select").select2().data();
            // alert("selected_cause = " + selected_cause);
            //
            var share_msg = $("#cbw-share-msg").val() ? $("#cbw-share-msg").val() : sel_channel.msg;
            share_msg = share_msg.replace("{{merchant}}", ServeData.merchant.name);
            //
            // following rem'd out because selected_cause not working from above
            //
            // share_msg = share_msg.replace("{{supporter_cause}}", selected_cause);
            //

            RegisterShareEvent(CBServeUrlBase, CBMerchantID, $("#cbw-email-input").val(), sel_cause_idx, ServeData.paths[chname], RegisterShareResult);

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

                    redirect_uri = "http://phil.causebutton.com/cbproto/fblanding.html?xyz=123";

                    // Hardcoding this for now 
                    var app_id = "331567326978199";

                    link_label = link_label.replace("{{merchant}}", ServeData.merchant.name);
                    //
                    // following rem'd because selected_cause not working from above
                    //
                    //link_label = link_label.replace("{{supporter_cause}}", selected_cause);
                    //

                    if (sel_channel.thumb_url) {

                        var image_url = sel_channel.thumb_url;

                        PostToFacebook(url_prefix, channel_path, share_msg, redirect_uri, link_label, caption, app_id, image_url);
                    
                    } else {
                        
                        PostToFacebook(url_prefix, channel_path, share_msg, redirect_uri, link_label, caption, app_id);
                    }

                    break;

                case 'pinterest':

                    // image is currently hardcoded on the server so replacing here with hardcoded one for testing purposes

                    var image_url = "http://phil.causebutton.com/cbproto/img/funky_astronaut.png";

                    PostToPinterest(sel_channel.url_prefix, channel_path, share_msg, image_url);
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

        function EmailValid (email) {

            var emlre = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

            if (email != "" && !emlre.test(email)) {
                return false
            } else {
                return true
            }
        };

        function BlinkErrorMessage () {

            $("#cbw-email-input-error-message")
                    .fadeOut(200)
                    .fadeIn(200)
                    .fadeOut(200)
                    .fadeIn(200);
        };


        /* --------------------------------------------------------
         * CloseWidget(reset) 
         * --------------------------------------------------------
         * Closes the widget and optionally (if reset == true) resets
         * the state of the widget fields to their default values
         * so that the next time it is opened, it will be set to
         * defaults.
         * -------------------------------------------------------- */
        function CloseWidget(reset) {

            $("#cbw-widget").hide();

            if (!reset) return;

            RegisterShareEvent(CBServeUrlBase, CBMerchantID, $("#cbw-email-input").val(), $("#cbw-cause-select").select2("val"), "", RegisterShareResult);
        }

        /*
         * EVENT HANDLER FUNCTIONS
         * -----------------------
         * - note, this must be inside the jQuery.ready function($) or else they will be using the incorrect
         * - version of jQuery (from host page) or possibly not have access to jQuery at all...
         */

        /* --------------------------------------------------------
         * Main Cause Button Handler
         * --------------------------------------------------------
         * Activates the cause button widget, eventually will 
         * incorporate more logic as to whether the widget can be
         * displayed, what form to display, etc. maybe also be
         * responsible for pulling the Active Promotion
         * -------------------------------------------------------- */
        $(document).on('click', '#cbw-main-btn', function() {

            var display = $("#cbw-widget").css('display');

            $("#cbw-widget").toggle();

            if (display == "none") {

                RegisterWidgetView(CBServeUrlBase, CBMerchantID);
            }

            RepositionWidget();

        });

        $(window).resize(function() {

            var shown = $("#cbw-widget").css('display');

            if (WidgetPosition != "center" && shown != "none") {

                RepositionWidget();
            }
        });

        $(document).on('click', '.cbw-exit-link', function() {

            CloseChannel();

        });

        $(document).on('click', '.cbw-post-link', function() {

            PostToChannel();

        });

        $(document).on('click', '#cbw-links-terms-toggle', function() {

            var display = $("#cbw-links-terms").css('display');

            $("#cbw-links-terms").toggle();

            if (display == "none") {

                $("#cbw-links-terms-toggle").html("show less"); 

            } else {

                $("#cbw-links-terms-toggle").html("show more");

            }

            RepositionWidget();

        });

        /* --------------------------------------------------------
         * Channel Selection Icon Click Handler (Toggle)
         * --------------------------------------------------------
         * Toggle image from/to selected/unselected version
         * Show or Hide the appropriate channel-specific fields based 
         * on the data from the served promotion
         * -------------------------------------------------------- */
        $(document).on('click', '.cbw-channel-toggle', function() {

            if ($("#cbw-email-ctl-grp").hasClass('error')) {

                BlinkErrorMessage();

                return
                
            }

            if (SelectedChannel) {

                if ($(this).attr('src') == SelectedChannel.attr('src')) {

                    if (SelectedChannel.attr('src').indexOf('-on.png') >= 0) {

                        CloseChannel();

                    } else {

                        OpenChannel();
                    }

                } else {

                    CloseChannel();

                    SelectedChannel = $(this);

                    SelectChannel();

                    OpenChannel();

                }

            } else {

                SelectedChannel = $(this);

                SelectChannel();

                OpenChannel();
            }

        });


        /* --------------------------------------------------------
         * E-Mail Input Blur Handler
         * --------------------------------------------------------
         * When the user exits the email input field, validate the
         * format of the input. If it is not valid, turn red and
         * disable the Post button, re-enable and turn normal
         * if valid.
         * -------------------------------------------------------- */
        $(document).on('blur', '#cbw-email-input', function() {

            var email = $('#cbw-email-input').val();

            //var emlre = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

            //if (email != "" && !emlre.test(email)) {
            if (!EmailValid(email)) {
                $("#cbw-email-ctl-grp").addClass('error');
                //$(".cbw-channel-toggle").addClass('disabled');
                //$(".cbw-channel-toggle").prop('disabled', true);
                $("#cbw-email-input-error-message").show();
                //$("#cbw-welcome-user-message").hide()
                BlinkErrorMessage();
            } else {
                $("#cbw-email-ctl-grp").removeClass('error');
                //$(".cbw-channel-toggle").removeClass('disabled');
                //$(".cbw-channel-toggle").prop('disabled', false);
                $("#cbw-email-input-error-message").hide();
                //$("#cbw-welcome-user-message").show();
                $("#cbw-user-name").replaceWith(email);
            }

            RepositionWidget();
        });

        /* --------------------------------------------------------
         * Cause Change Handler 
         * --------------------------------------------------------
         * Right now this primarily updates the text in the share
         * message (facebook only right now) so that it dynamically
         * upates with the correct cause...
         * -------------------------------------------------------- */
        $(document).on('change', '#cbw-cause-select', function(e) {

            var share_msg = $("#cbw-share-msg").val();

            var added = e.added.text;
            var removed = e.removed.text;

            if (share_msg) {
                share_msg = share_msg.replace(removed, added);
                $("#cbw-share-msg").val(share_msg);
            } 
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
         * Close Button Handler 
         * --------------------------------------------------------
         * This simply closes the widget and resets the values to
         * their defaults so that the next time it is opened it will
         * be in the proper state
         * -------------------------------------------------------- */
        $(document).on('click', '#cbw-close-button', function() {

            if ($("#cbw-email-ctl-grp").hasClass('error')) {

                BlinkErrorMessage();
                
            } else {

                CloseWidget(true);

            }

            // TO DO: Clear the state of the widget...
        });

        /* --------------------------------------------------------
         * Close Button Handler 
         * --------------------------------------------------------
         * This simply closes the widget and resets the values to
         * their defaults so that the next time it is opened it will
         * be in the proper state
         * -------------------------------------------------------- */
        $(document).on('click', '.cbw .close', function() {

            if ($("#cbw-email-ctl-grp").hasClass('error')) {

                BlinkErrorMessage();

            } else {

                CloseWidget(true);

            }

            // TO DO: Clear the state of the widget...
        });


    }); // end jquery.documentready

    /*** NOTE - ANY FUNCTIONS DEFINED OUT HERE WILL NOT HAVE ACCESS TO JQUERY PROPERLY DUE TO jQuery.noConflict(true) ***/

    /*
     * AWE.SM HELPER FUNCTIONS
     */
    
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

        var windowSpecs = "width=550,height=258,resizable=0,scrollbars=0";

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

        var windowSpecs = "width=640,height=370,resizable=0,scrollbars=0";

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

        var windowSpecs = "width=665,height=350,resizable=0,scrollbars=0";

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
        var result = AWESM.share.email({
            'subject': subject,
            'body': body
        });
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
        var result = AWESM.share.linkedin({
            'url': target_url
        });
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
        var result = AWESM.share.googleplus({
            'url': target_url
        });
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

})(); // immediately call our anonymous function here...