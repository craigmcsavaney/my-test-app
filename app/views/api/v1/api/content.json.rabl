object false

node :content do
	
'<div class="cbw">
	<div id="cbw-btn"></div>
	<div id="cbw-widget" style="display:none;" class="box_shadow">
		<div id="cbw-heading">
			<div id="cbw-heading-logo">
				<img id="cbw-heading-logo-img" src="https://morning-savannah-7661.herokuapp.com/assets/widget/cb-white-ltblue-15x123.svg">
			</div>
			<span id="cbw-welcome-user-message" style="display:none;">Welcome&nbsp;
				<span id="cbw-user-name"></span>
				<a id="cbw-user-name-change">&nbsp(change)</a>
			</span>
			<button type="button" class="close" aria-hidden="true" id="cbw-heading-close">&times;</button>
		</div>
		<div id="cbw-body-normal">
			<p id="cbw-promo-text">Thanks for clicking on the Cause Button! Simply choose a cause and post a message \
	                                    to your friends on our behalf and we will make a donation of 5% of all purchases</p>
			<form id="cbw-widget-form" class="form-horizontal form-small">
				<div id="cbw-cause-select-ctrl-grp" class="control-group">
					<label class="control-label" for="input-cause-sel">Select A Cause</label>
					<div class="controls">
						<select id="cbw-cause-select" class="cbw-select2"/>
					</div>
				</div>
				<div class="control-group" id="cbw-email-checkbox-ctl-grp">
					<label style="text-align: center; display: block; padding-top: 0px;" class="control-label" for="cbw-input-email-checkbox"><input type="checkbox"></label>
					<div class="controls">
						<p style="margin-top: 3px;" id="cbw-email-checkbox-text">Tell me when I've caused a donation!</p>
					</div>
				</div>
	        	<div id="cbw-email-ctl-grp" class="control-group" style="display:none;">
					<label class="control-label" for="cbw-input-email">E-Mail</label>
					<div class="controls">
						<input id="cbw-email-input" type="text" placeholder="enter your email address">
						<!-- <p id="cbw-email-hint">Enter your email to receive updates on how much you have helped raise for your cause!</p> -->
						<p id="cbw-email-input-error-message" style="display:none;" class="error">Please correct email<p>
					</div>
				</div>
				<div id="cbw-channels-grp" class="control-group">
	            	<label for="cbw-channels" class="control-label">Preview & Edit</label>
	            	<div id="cbw-channels" class="controls"/>
	            </div>			
	            <div id="cbw-share-msg-ctrl-grp" class="control-group" style="display: none;">
					<label class="control-label" for="cbw-share-msg">Share Message<br/><br/>
						<a id="cbw-share-msg-post-link" class="cbw-post-link" href="#" style="margin-right: 20px;">continue</a>
						<a id="cbw-share-msg-exit-link" class="cbw-exit-link" href="#">exit</a>
					</label>
					<div class="controls">
						<textarea id="cbw-share-msg" rows="3" placeholder="Enter Text To Share"></textarea>
					</div>
					<!-- <div class="controls">
						<a id="cbw-close-button" class="btn" href="#" style="margin-left: 25px;">Close</a>
						<a id="cbw-post-button" class="disabled btn btn-primary" href="#" style="margin-left: 55px;">Post</a>
					</div> -->
				</div>
			</form>          
			<div id="cbw-links">
    			<span id="cbw-links-terms-toggle">show more</span>
			</div>
			<div id="cbw-links-terms" style="display:none;" >
    			lots and lots and lots of terms go here
			</div>
	    </div>
	</div>
</div>'

end