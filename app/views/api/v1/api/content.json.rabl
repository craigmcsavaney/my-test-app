object false

node :content do
	
'<a id="cbw-main-btn" class="btn btn-success" href="#">
	<i class="icon-heart icon-white"></i>
	Support Your Cause!
</a>
<div id="cbw-widget" style="display:none; top: 50%; left: 50%; margin-top: -225px; margin-left: -225px;">
	<div id="cbw-heading">Cause Button</div>
	<div id="cbw-body-normal">
		<p id="cbw-promo-text">Thanks for clicking on the Cause Button! Simply choose a cause and post a message \
                                    to your friends on our behalf and we will make a donation of 5% of all purchases</p>
		<form id="cbw-widget-form" class="form-horizontal form-small">
			<div id="cbw-cause-select-ctrl-grp" class="control-group">
				<label class="control-label" for="input-cause-sel">Select Cause</label>
				<div class="controls">
					<select id="cbw-cause-select" class="cbw-select2"/>
				</div>
			</div>
			<div class="control-group">
            	<label for="cbw-channels" class="control-label">Share Method</label>
            	<div id="cbw-channels" class="controls"/>
            </div>			
            <div id="cbw-share-msg-ctrl-grp" class="control-group">
            	<label for="cbw-share-msg" class="control-label">Share Message</label>
            	<div class="controls">
                	<textarea id="cbw-share-msg" rows="3" placeholder="Enter Text to Share" style="display: none"/>
            	</div>
        	</div>
        	<div id="cbw-email-ctl-grp" class="control-group">
				<label class="control-label" for="cbw-input-email">E-Mail</label>
				<div class="controls">
					<input id="cbw-email-input" type="text" placeholder="E-Mail">
				</div>
			</div>
			<div class="control-group">
				<div class="controls">
					<p id="cbw-email-hint">Enter your email to receive updates on how much you have helped raise for your cause!</p>
				</div>
			</div>
			<div class="control-group" style="margin-top: 10px;">
				<div class="controls">
					<a id="cbw-close-button" class="btn" href="#" style="margin-left: 25px;">Close</a>
					<a id="cbw-post-button" class="disabled btn btn-primary" href="#" style="margin-left: 55px;">Post</a>
				</div>
			</div>
		</form>          
    </div>
</div>'

end