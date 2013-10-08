module Api
    module V1
        class ApiController < ApplicationController
            def serve
                # This is the main api method that serves all the intial widget load information.
                # This call accepts the following inputs: merchant_id, callback, [session_id], 
                # [serve_id], and [path].  merchant_id and callback are required on all calls 
                # and an error message will be returned if either is missing.  Remember that 
                # the merchant_id is a uid.

                # If a session_id is available (stored in the CB session cookie), it should be
                # passed in as it will significantly speed up processing of the api request.

                # If a serve_id is available (stored in the CB permanent cookie), it should be
                # passed in so any user-supplied data (email, cause, etc.) can be returned.

                # If a path value can be obtained from the referring url, it will be passed in
                # so we can determine who referred this visitor and if they are being referred 
                # by a new referrer.  

                # Also, the path is checked against share paths for the current serve_id to 
                # determine if the user referred themselves back to the same site using
                # one of their own share links.  If so, we don't treat this as a new
                # referral.

                # Finally, we check to see if the causebutton.com user cookie is set.  
                # If it is, we get the value and check to see if this is an invited but 
                # not confirmed user, or a confirmed (but not logged out) user.  If a user 
                # logs out, the user cookie should be destroyed.  If there is a valid user
                # and this is a new serve, we user the user's email when creating the new
                # serve.  If there is no valid user and this is a new serve, we create the
                # serve with no email.  If we are serving up an existing serve, we use the
                # email already associated with the serve, even if it is blank (as that
                # may be intentional).

                # The json response will always include a value for the purchase path, 
                # identified as pur_path.  This value must always be used to update the
                # path value in the awe.sm cookie.  The json will also contain a session_id,
                # which should be written to a CB session cookie, and a serve_id, which should
                # be written to the permanent CB cookie.

                # first, verify that a callback parameter was passed
                if params[:callback].nil?
                    render 'api/v1/api/errors/missing_callback'
                    return
                end

                # next, check to ensure that the merchant_id is valid and if so, get the merchant
                if Merchant.merchant_valid?(params[:merchant_id])
                        merchant = Merchant.find_by_uid(params[:merchant_id])
                    else
                        render 'api/v1/api/errors/merchant_invalid'
                        return
                end

                # Set the check_date to today.  Used to search for valid promotions
                check_date = Date.today

                # Get merchant's current promotion. If no valid promotion exists, return an error
                @current = Current.get_current_promotion(check_date,merchant)
                if @current[:promotion] == nil
                    # No current promotion found
                    render 'api/v1/api/errors/no_valid_promotion'
                    return
                end

                # next, check to see if a valid session_id (one that is associated with
                # the current merchant) was passed in.  If so, serve the promotion associated
                # with this session_id
                if Serve.session_valid?(params[:session_id],merchant)
                    @serve = Serve.find_by_session_id(params[:session_id])
                    render 'serve'
                    return
                end

                # Since we made it to this point, this must be a new session, and a valid current
                # promotion has been successfully identified.  Now set the promotion variable
                # equal to the current promotion:
                @promotion = @current[:promotion]
                # Check to see if valid serve_id and path were passed in.
                serve_valid = !Serve.not_exists?(params[:serve_id])
                path_valid = Share.path_valid?(params[:path])
                # Now determine if the current promotion is the same as the old promotion
                if serve_valid && Serve.find(params[:serve_id]).promotion_id == @promotion.id
                        promotion_same = true
                    else
                        promotion_same = false
                end

                # Now check the causebutton.com user cookie and if it exists, set the variable user to the value of the
                # cookie, which will be the email address of the user.
                # cookies.permanent.signed[:user] = "craigmcsavaney@yahoo.com"
                user = ""
                user_id = nil
                if cookies.signed[:user] and cookies.signed[:user] != ""
                    user = cookies.signed[:user]
                    user_id = User.GetUserID(user)
                end

                # Once a visitor has clicked the cause button and we have created a serve and
                # shares for them, it's possible that they may click one of the share links to 
                # test it out.  In this case, they will appear to be coming from a new referring
                # url.  We need to check the url and see if it's associated with any of the shares 
                # of the current serve.  If it is, we need to ignore it by treating it as
                # an invalid path.
                if serve_valid && path_valid && Serve.find(params[:serve_id]).shares.pluck(:link_id).include?(params[:path])
                        path_valid = false
                end

                # Now determine if the referring path has changed for valid serves and valid paths
                # First, check to see if the current serve and path are valid.  If either is invalid, mark the path_same as false.
                if serve_valid && path_valid
                        case 
                            
                            # First, check to see if the current serve came from an awesm referral link.  If not, path_same should always be false
                            when Serve.find(params[:serve_id]).share.nil?
                                path_same = false
                            
                            # Next, check to see if the current serve referring path is equal to the referring path for the new serve request.
                            when Serve.find(params[:serve_id]).share.link_id == params[:path]
                                path_same = true

                            # Finally, the current serve had a valid referral path which is different from the referring path for the new serve request.
                                path_same = false

                        end

                    else

                        path_same = false

                end

                # if serve_valid && path_valid && Serve.find(params[:serve_id]).share.link_id == params[:path]
                #         path_same = true
                # else
                #         path_same = false
                # end

                # Now, using the serve, path, and promotion variables set above,
                # examine the different cases and take appropriate actions to find, create,
                # update, and serve the correct promotion to this visitor
                case
                    # First case, when serve_id and path weren't passed in or don't match
                    # existing records.  Typically, this is a first time, non-referred visitor 
                    when !serve_valid && !path_valid
                        # create a new serve using the current promotion
                        @serve = Serve.create(promotion_id: @promotion.id, user_id: user_id)
                        # @serve = Serve.create(promotion_id: @promotion.id)

                    # Second case, when serve_id is invalid and path is valid.
                    # Typically, this is a first time, referred visitor 
                    when !serve_valid && path_valid
                        # create a new serve using the current promotion and the share_id associated with the path
                        # first, get the share associated with the referring path
                        @referring_share = Share.find_by_link_id(params[:path])
                        # now, create the new serve
                        @serve = Serve.create(promotion_id: @promotion.id, referring_share_id: @referring_share.id, user_id: user_id)
                        # @serve = Serve.create(promotion_id: @promotion.id, referring_share_id: @referring_share.id)

                    # Third case, when the serve is valid (implied, as the not valid cases are handled above) and the current promotion hasn't changed
                    # but either the path is invalid or is the same as the stored referring path
                    when promotion_same && (!path_valid || path_same)
                        # we're just going to serve up the old promotion here, but with a new session_id
                        session_id = Serve.new_session_id
                        Serve.find(params[:serve_id]).update_attributes(session_id: session_id)
                        @serve = Serve.find(params[:serve_id]) # reload the old serve with the new session_id

                    # Fourth case, when the serve is valid (implied, as the not valid cases are handled above) but the incoming path is new (and valid)
                    # This means the visitor is returning to the same site, but was referred here
                    # by someone new.
                    when path_valid && !path_same
                        # We're going to create a new serve for this visitor using the new path information (which exists because the path is valid) and copy over the cause and email info from the previous serve if possible.  TO DO: if the previous serve wasn't viewed, we'll delete it and all its shares.
                        @old = Serve.find(params[:serve_id])
                        @referring_share = Share.find_by_link_id(params[:path])
                        @serve = Serve.create(promotion_id: @promotion.id, email: @old.email, referring_share_id: @referring_share.id, current_cause_id: @old.current_cause_id, user_id: @old.user_id)
                        # @serve = Serve.create(promotion_id: @promotion.id, email: @old.email, referring_share_id: @referring_share.id, current_cause_id: @old.current_cause_id)

                        #if !@old.viewed?
                            # delete the old serve and its associated shares
                        #end

                    # Fifth case, when the serve is valid (implied, as the not valid cases are handled above), the promotion has changed, and the path is either invalid or is the same as the stored referring path
                    when !promotion_same && (!path_valid || path_same)
                        # This is basically the case where the promotion has changed, so if the
                        # serve hasn't been viewed yet, we'll just update it with the new promotion
                        # and a new session_id.
                        # If the serve has been viewed, we'll create a new serve and copy over the
                        # cause, email, user_id, and referring_share info if possible.
                        @old = Serve.find(params[:serve_id])
                        if @old.viewed?
                            @serve = Serve.create(promotion_id: @promotion.id, email: @old.email, referring_share_id: @old.referring_share_id, current_cause_id: @old.current_cause_id, user_id: @old.user_id)
                            # @serve = Serve.create(promotion_id: @promotion.id, email: @old.email, referring_share_id: @old.referring_share_id, current_cause_id: @old.current_cause_id)
                        else
                            session_id = Serve.new_session_id
                            Serve.find(params[:serve_id]).update_attributes(promotion_id: @promotion.id, session_id: session_id)
                            @serve = Serve.find(params[:serve_id])
                        end
                    else
                        render 'api/v1/api/errors/unrecognized_case'
                        return
                end
                puts @serve.id
                render 'serve'
            end

            def view
                # inputs: merchant_id, session_id, callback.  Remember that merchant_id is a uid.

                # first, verify that a callback parameter was passed
                if params[:callback].nil?
                    render 'api/v1/api/errors/missing_callback'
                    return
                end

                # next, check to ensure that the merchant_id is valid and if so, get the merchant
                if Merchant.merchant_valid?(params[:merchant_id])
                        merchant = Merchant.find_by_uid(params[:merchant_id])
                    else
                        render 'api/v1/api/errors/merchant_invalid'
                        return
                end

                # next, check to see if a valid session_id (one that is associated with
                # the current merchant) was passed in.  If so, mark the serve as viewed.  If not,
                # return a session_invalid error message
                if Serve.session_valid?(params[:session_id],merchant)
                        Serve.find_by_session_id(params[:session_id]).update_attributes(viewed: true)
                        render 'success'
                        return
                    else
                        render 'api/v1/api/errors/session_invalid'
                        return
                end
                render 'api/v1/api/errors/unrecognized_case'
                return
            end

            def update
                # inputs: merchant_id, session_id, callback, [path], [cause_id], [email]
                # remember that the merchant_id and cause_id are both uid's

                # first, verify that a callback parameter was passed
                if params[:callback].nil?
                    render 'api/v1/api/errors/missing_callback'
                    return
                end

                # next, check to ensure that the merchant_id is valid and if so, get the merchant
                if Merchant.merchant_valid?(params[:merchant_id])
                        merchant = Merchant.find_by_uid(params[:merchant_id])
                    else
                        render 'api/v1/api/errors/merchant_invalid'
                        return
                end

                # next, check to see if a valid session_id (one that is associated with the current merchant) was passed in.  If so, get the subject serve.  If not, return a session_invalid error message
                if Serve.session_valid?(params[:session_id],merchant)
                        @serve = Serve.find_by_session_id(params[:session_id])
                    else
                        render 'api/v1/api/errors/session_invalid'
                        return
                end

                # next, check to see if an email was passed in and if it is different than the email in the current serve record.  If it is different, set the @email[:email_changed] flag to true and set the @email[:email] variable to the new email address.  Otherwise, set the flag to false and the email variable to the current value of the email
                @email = Serve.email_changed?(@serve,params[:email])

                # next, check to see if an email was passed in and if it is different than the email associated with the user in the current serve record.  If it is different, set the @user[:user_changed] flag to true and set the @user[:user_id] variable to the new user_id.  Otherwise, set the flag to false and the user_id variable to the current value of the serve user_id.
                @user = Serve.user_changed?(@serve,params[:email])

                # check to see if a cause was passed in (non-nil) and if it is different from the current cause value.  If it is valid and different, set the @cause[:cause_changed] flag to true and the @cause[:cause] variable to the new cause.  Otherwise, set the flag to false and the cause variable to the current cause id value.  Remember that the cause_id being passed in is a uid but the cause being returned is an object.
                @cause = Serve.cause_changed?(@serve,params[:cause_id])

                # if either the current cause or the email has changed, update the current serve. Also, since the purchase path associated with the old cause and email may have been used already, mark it as confirmed and create a new paths for this channels.
                if @cause[:cause_changed] or @email[:email_changed]
                    # first, mark the Purchase share for this serve as confirmed:
                    #Serve.post_to_channel(@serve,Channel.find_by_name('Email'))
                    Serve.post_to_channel(@serve,Channel.find_by_name('Purchase'))
                    # next, update the Serve attributes to reflect the new email, current_cause_id, or both
                    @serve.update_attributes(email: @email[:email], current_cause_id: @cause[:cause], user_id: @user[:user_id])
                    # finally, create a new share for the purchase channel
                    #Share.create_share(@serve,Channel.find_by_name('Email'))
                    Share.create_purchase_share(@serve,Channel.find_by_name('Purchase'),@cause[:cause])
                end

                # next, check to see if a valid share path (one that is associated with the current serve) was passed in.  Note that if the share associated with the path has already been confirmed, the path will not be valid.  Not sure if this is necessary  - may be better to ignore whether the share is confirmed and create a new share anyhow.
                if Share.path_valid_for_this_serve?(params[:path],@serve)
                    # the path is valid, so get the current share
                    @share = Share.find_by_link_id(params[:path])
                    # Now, mark the posted channel as confirmed, then create a new path for this channel
                    Serve.post_to_channel(@serve,@share.channel)
                    Share.create_share(@serve,@share.channel)
                end

                # Get the current Serve and render it to the update template
                @serve = Serve.find_by_session_id(params[:session_id])
                render 'update'
            end

            def causes
                # inputs: merchant_id, session_id, callback. Remember that merchant_id is a uid.

                # first, verify that a callback parameter was passed
                if params[:callback].nil?
                    render 'api/v1/api/errors/missing_callback'
                    return
                end

                # next, check to ensure that the merchant_id is valid and if so, get the merchant
                if Merchant.merchant_valid?(params[:merchant_id])
                        merchant = Merchant.find_by_uid(params[:merchant_id])
                    else
                        render 'api/v1/api/errors/merchant_invalid'
                        return
                end

                # # next, check to see if a valid session_id (one that is associated with
                # # the current merchant) was passed in.  If so, mark the serve as viewed.  If not,
                # # return a session_invalid error message
                # if Serve.session_valid?(params[:session_id],merchant)
                #         Serve.find_by_session_id(params[:session_id]).update_attributes(viewed: true)
                #         render 'success'
                #         return
                #     else
                #         render 'api/v1/api/errors/session_invalid'
                #         return
                # end
                # render 'api/v1/api/errors/unrecognized_case'
                @causes = Cause.all
                render 'causes'
                return
            end

            def sale
                # inputs: merchant_id, path, callback, amount, [transaction_id]. Remember that merchant_id is a uid.

                # first, verify that a callback parameter was passed
                if params[:callback].nil?
                    render 'api/v1/api/errors/missing_callback'
                    return
                end

                # next, check to ensure that the merchant_id is valid and if so, get the merchant
                if Merchant.merchant_valid?(params[:merchant_id])
                        merchant = Merchant.find_by_uid(params[:merchant_id])
                    else
                        render 'api/v1/api/errors/merchant_invalid'
                        return
                end

                # next, check to ensure that the amount is numeric and does not include more than two digits after the decimal
                if !Sale.is_a_number?(params[:amount])
                        render 'api/v1/api/errors/amount_non-numeric'
                        return
                    elsif !Sale.only_dollars_and_cents(params[:amount].to_f)
                        render 'api/v1/api/errors/amount_invalid'
                        return
                end

                # next, check to see if a valid share path (one that is associated with the current merchant) was passed in.  
                if Share.path_valid_for_this_merchant?(params[:path],merchant)
                    # the path is valid, so get the current share
                    share = Share.find_by_link_id(params[:path])
                    # Now, mark the posted channel as confirmed, then create a new path for this channel
                    Sale.create(share_id: share.id, amount: params[:amount].to_f, transaction_id: params[:transaction_id]);
                    #Serve.post_to_channel(@serve,@share.channel)
                    #Share.create_share(@serve,@share.channel)
                else
                    render 'api/v1/api/errors/path_invalid'
                end

                render 'success'
                return
            end

            def content
                render 'content'
                return
            end

        end
    end
end