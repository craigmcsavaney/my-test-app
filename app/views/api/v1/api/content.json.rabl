object false

node :content do
	
'<div class="cbw-reset">
	<div class="cbw">
		<div id="cbw-widget" class="box-shadow widget-hide">
			<div id="cbw-heading">
				<div id="cbw-heading-logo">
					<a id="cbw-heading-logo-link" target="_blank">
						<!--<img id="cbw-heading-logo-img">-->
						CauseButton
					</a>
				</div>
				<span id="cbw-welcome-user-message" class="widget-hide">Welcome&nbsp;
					<span id="cbw-user-name"></span>
					<a id="cbw-user-name-change">&nbsp(change)</a>
				</span>
				<div id="cbw-heading-close">&times;</div>
			</div>
			<div id="cbw-body-normal">
				<div id="cbw-pledge-title" class="main widget-show">
					Pledge Title Placeholder
				</div>
				<div id="cbw-promo-text" class="cbw-body-text main widget-show">
					Thanks for clicking on the Cause Button! Simply choose a cause and post a message \
		                                    to your friends on our behalf and we will make a donation of 5% of all purchases
		        </div>
				<div class="cbw-horiz-line main widget-show"></div>
				<div class="main cbw-currently-selected-cause widget-show">
					<div class="cbw-control-group" id="cbw-currently-selected-cause-box">
						<div class="cbw-radio-button-label" id="currently-selected-cause-label">
							The currently selected cause is...
						</div>
						<div id="cbw-currently-selected-cause-radio-button-box">
							<div id="cbw-currently-selected-cause-inner-box" >
								<div id="cbw-currently-selected-cause-text" class="cbw-body-text">
									My favorite charity
								</div>
								<div id="cbw-currently-selected-cause-search-icon">
									<i class="fa fa-search"></i>
								</div>
							</div>
						</div>
						<div id="cbw-change-cause-label">
							(click to change)
						</div>
					</div>
				</div>
				<div class="cbw-horiz-line main cbw-currently-selected-cause widget-show"></div>
				<div id="cbw-cause-selector" class="box-shadow">
					<i id="cbw-cause-selector-close" class="fa fa-times"></i>
					<div class="cbw-control-group">
						<div id="cbw-cause-selector-title">
							Choose from...
						</div>
						<div class="cbw-radio-button-label" id="default-cause-control-label">
							Our recommended cause.
						</div>
						<div class="cbw-cause-radio-button-box">
							<div class="cbw-radio-button">
								<input type="radio" name="cause-type-radio" id="cbw-cause-type-default" value="default" class="cause-select-radio">
							</div>
							<div class="cbw-body-text" id="default-cause-control-text">
									default cause placeholder
							</div>
						</div>
					</div>
					<div class="cbw-horiz-line">
						<div class="cbw-or">OR</div>
					</div>
					<div id="cbw-cause-select-ctrl-grp" class="cbw-control-group widget-hide">
						<div class="cbw-radio-button-label" id="cause-sel-control-label">
							Trending causes.
						</div>
						<div id="cbw-trending-cause-0" class="cbw-cause-radio-button-box widget-hide">
							<div class="cbw-radio-button">
								<input type="radio" name="cause-type-radio" id="cbw-cause-trend-0" value="0" class="cause-select-radio">
							</div>
							<div class="cbw-body-text" id="trending-cause-0-text">
									trending cause 1 placeholder text
							</div>
						</div>
						<div  id="cbw-trending-cause-1" class="cbw-cause-radio-button-box widget-hide">
							<div class="cbw-radio-button">
								<input type="radio" name="cause-type-radio" id="cbw-cause-trend-1" value="1" class="cause-select-radio">
							</div>
							<div class="cbw-body-text" id="trending-cause-1-text">
									trending cause 2 placeholder text
							</div>
						</div>
						<div  id="cbw-trending-cause-2" class="cbw-cause-radio-button-box widget-hide">
							<div class="cbw-radio-button">
								<input type="radio" name="cause-type-radio" id="cbw-cause-trend-2" value="2" class="cause-select-radio">
							</div>
							<div class="cbw-body-text" id="trending-cause-2-text">
									trending cause 3 placeholder text
							</div>
						</div>
					</div>
					<div class="cbw-horiz-line">
						<div class="cbw-or">OR</div>
					</div>
					<div id="cbw-fgcause-select-ctrl-grp" class="cbw-control-group">
						<div class="cbw-radio-button-label" id="fgcause-sel-control-label">
							Find a cause by name.
						</div>
						<div class="cbw-cause-radio-button-box">
							<input type="radio" name="cause-type-radio" id="cbw-cause-type-single" value="single"  class="cause-select-radio">
							<div class="cbw-controls">
								<input id="cbw-fgcause-select" class="cbw-fg-select2" type="hidden">
							</div>
						</div>
					</div>
				</div>
				<div id="cbw-channels-grp" class="cbw-control-group main widget-show">
	            	<div id="cbw-channels-grp-label" class="cbw-radio-button-label">Share with friends.</div>
	            	<div id="cbw-channels-grp-text" class="cbw-body-text">
	            		You can review and edit before posting.
	            	</div>
	            	<div id="cbw-channels" class="cbw-controls"/>
	            </div>			
				<div id="cbw-share-again" class="cbw-control-group share-again widget-hide">
	            	<div id="cbw-share-again-button-box">
	            		<div id="cbw-share-again-button" class="cbw-share-again-button">
	            			Share Again
	            		</div>
	            		<div id="cbw-share-again-done-button" class="cbw-share-again-button">
	            			All Done
	            		</div>
	            	</div>
	            </div>			
				<div class="email cbw-horiz-line main widget-hide"></div>
				<div class="email widget-hide">
					<div id="cbw-email-checkbox-ctl-grp" class="cbw-control-group">
						<div class="cbw-email-checkbox-box">
							<div class="cbw-email-checkbox">
								<input type="checkbox" id="cbw-email-checkbox">
							</div>
							<div class="cbw-body-text" id="cbw-email-checkbox-label">
								Tell me when I&apos;ve caused a donation!
							</div>
						</div>
					</div>
		        	<div id="cbw-email-ctl-grp" class="cbw-control-group widget-hide">
						<div class="cbw-controls">
							<input id="cbw-email-input" type="text" placeholder="Enter your email address here." class="cbw-body-text">
							<div id="cbw-email-input-error-message" class="error widget-hide">Oops! Please correct email :)</div>
						</div>
					</div>
				</div>
	            <div id="cbw-share-msg-ctrl-grp" class="cbw-control-group widget-hide">
					<div class="cbw-control-label" for="cbw-share-msg">Share Message<br/><br/>
						<div id="cbw-share-msg-post-link" class="cbw-post-link cbw-link" href="#" style="margin-right: 20px;">continue</div>
						<div id="cbw-share-msg-exit-link" class="cbw-exit-link cbw-link" href="#">exit</div>
					</div>
					<div class="cbw-controls">
						<textarea id="cbw-share-msg" rows="3" placeholder="Enter Text To Share"></textarea>
					</div>
				</div>
				<div id="cbw-links" class="cbw-control-group widget-hide">
	    			<div id="cbw-links-info-toggle" class="cbw-link">more info</div>
				</div>
				<div id="cbw-links-info" class="widget-hide cbw-control-group"" >
	    			<textarea id="cbw-links-info-text" rows="10">content placeholder</textarea>
				</div>
		    </div>
		</div>
	</div>
</div>'

end