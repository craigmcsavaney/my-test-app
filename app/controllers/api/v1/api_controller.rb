module Api
    module V1
        class ApiController < ApplicationController
            def serve
                # This is the main api method that serves all the intial widget load information.
                # This call accepts the following inputs: merchant_id, callback, [session_id], 
                # [serve_id], [cbcause_id], and [path].  merchant_id and callback are required on all calls 
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

                # If a referring cause value (cbcause) can be obtained from the referring url, 
                # it will be passed in and used to set or update the default cause value
                # for the resulting serve. 

                # Finally, we check to see if the causebutton.com user cookie is set.  
                # If it is, and if it contains a valid user email value, 
                # we find the associated user_id and use it when creating the new
                # serve.  If there is no valid user and this is a new serve, we create the
                # serve with no user.  If we are serving up an existing serve, we use the
                # user already associated with the serve, even if it is blank (as that
                # may be intentional).

                # TODO: We should probably check the status of the user associated with the email
                # in the user cookie so see if they have confirmed their account, if they are
                # logged in, etc.

                # The json response will always include a value for the purchase path, 
                # identified as pur_path.  This value must always be used to update the
                # path value in the awe.sm cookie.  The json will also contain a session_id,
                # which should be written to a CB session cookie, and a serve_id, which should
                # be written to the permanent CB cookie.

                # test of devise rememberable follows:
                # User.find(1).remember_me!

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

                # next, check to see if a referring cause was passed in and if it is a valid
                # cause.  If it is, get the cause.  This is an optional parameter so if it is blank
                # or invalid no action is required.merchant.  First, set cbcause to nil
                cbcause = nil
                if Cause.cause_valid?(params[:cbcause_id])
                        cbcause = Cause.find_by_uid(params[:cbcause_id])
                end

                # Check to see if a valid path was passed in.  If so, we may need to use it in the
                # next section if it was accompanied by a new referring cause
                path_valid = Share.path_valid?(params[:path])

                # Check to see if a valid session_id.
                session_valid = Serve.session_valid?(params[:session_id],merchant)

                # Check to see if valid serve_id was passed in.
                serve_valid = !Serve.not_exists?(params[:serve_id])

                # If either a valid serve or valid session was passed in, get the 
                # promotion associated with this serve or session
                case 
                    when session_valid
                        @old_serve = Serve.find_by_session_id(params[:session_id])
                        servable = Serve.servable?(@old_serve)

                    when serve_valid
                        @old_serve = Serve.find(params[:serve_id])
                        servable = Serve.servable?(@old_serve)

                    else
                        @old_serve = nil
                        servable = false

                end
 
                # Once a visitor has clicked the cause button and we have created a serve and
                # shares for them, it's possible that they may click one of the share links from
                # the same browser to test it out.  In this case, they will appear to be coming
                # from a new referrer but will have an existing valid serve.  We need to check
                # the new path and see if it's associated with any of the shares 
                # of the current serve.  If it is, we need to ignore it by treating it as
                # an invalid path.
                if !@old_serve.nil? && path_valid && @old_serve.shares.pluck(:link_id).include?(params[:path])
                        path_valid = false
                end

                # Now determine if the referring path has changed for existing serves and valid 
                # incoming paths. The only way this can be true is if a an old serve exists, a
                # valid path exists, and they are different.  Otherwise, the path does not change
                if !@old_serve.nil? && path_valid && @old_serve.share.link_id != params[:path]
                    path_changed = true
                else
                    path_changed = false
                end

                # Check to see if the new cause is different from the default cause (if one exists)
                # The only way this can be true is if an old serve exists, a valid cbcause exists,
                # and they are different.  Otherwise, the cause does not change.
                if !cbcause.nil? && !@old_serve.nil? && @old_serve.default_cause_id != cbcause.id
                    cause_changed = true
                else
                    cause_changed = false
                end

                # Now, see if the current serve is still servable and the path and cause didn't
                # change.  Otherwise, we'll have to continue with the longer
                # and more expensive process of finding the current promotion, then creating 
                # a new serve or updating the existing one.
                if servable && !cause_changed && !path_changed
                    # check to see if the session is still valid
                    if session_valid
                        # it is, so update the serve counter 
                        @old_serve.update_attributes(serve_count: @old_serve.serve_count + 1)
                        @serve = @old_serve
                    else
                        # it's not, so get a new session id and update the old serve with the
                        # new session id and an updated serve count
                        session_id = Serve.new_session_id
                        @old_serve.update_attributes(session_id: session_id, serve_count: @old_serve.serve_count + 1)
                        @serve = @old_serve
                    end
                    # now return the old serve
                    render 'serve'
                    return
                end

                # Set the check_date to today.  Used to search for valid current promotions
                check_date = Date.today

                # Get merchant's current promotion. If no valid promotion exists, return an error
                @current = Current.get_current_promotion(check_date,merchant)
                if @current[:promotion] == nil
                    # No current promotion found
                    render 'api/v1/api/errors/no_valid_promotion'
                    return
                end

                # Since we made it to this point, this must be a new session, and a valid current
                # promotion has been successfully identified.  Now set the promotion variable
                # equal to the current promotion:
                @promotion = @current[:promotion]

                # Now check the causebutton.com user cookie and if it exists, set the variable 
                # user to the value of the cookie, which will be the email address of the user.
                # cookies.permanent.signed[:user] = "craigmcsavaney@yahoo.com"
                user = ""
                user_id = nil
                if cookies.signed[:user] and cookies.signed[:user] != ""
                    user = cookies.signed[:user]
                    @user = User.GetUserID(user)
                    user_id = @user[:user_id]
                    # the following should never happen.  If a valid user is read from a cookie and passed to the GetUserID method, it should always find a valid user in the User table.  If it doesn't, a new user will be created and the :type variable will be set to "new"
                    if @user[:type] == "new"
                        cookies.permanent.signed[:user] = user
                    end
                end

                # Now, using the serve, path, promotion, and cause variables set above,
                # examine the different cases and take appropriate actions to find, create,
                # update, and serve the correct promotion to this visitor
                case
                    # First case, when serve_id and path weren't passed in or were invalid.  Typically,
                    # this is a first time, non-referred visitor or one whose serve cookie has expired,
                    # or one whose serve can't be matched to an existing serve record.
                    # If a valid cbcause was passed in, use it to set the default cause for the new serve
                    when !serve_valid && !path_valid
                        # If a valid cbcause was passed in, use it to set the default cause for the new serve.
                        # Otherwise, use the cause associated with the promotion
                        if !cbcause.nil?
                            new_cause_id = cbcause.id
                        else
                            new_cause_id = @promotion.cause_id
                        end
                        # create a new serve using the current promotion
                        # Note that the current cause will be set to the default cause before validation
                        # by the serve model
                        @serve = Serve.create(promotion_id: @promotion.id, default_cause_id: new_cause_id, user_id: user_id, serve_count: 1)

                    # Second case, when serve_id is invalid and path is valid. Typically, this is a first time,
                    # referred visitor.  Since they are referred, we use the default cause of the serve
                    # from the referring share as the default cause for the new serve.
                    # However, if they show up with a valid cbcause, use it to set the default cause for the
                    # new serve.  
                    when !serve_valid && path_valid
                        # create a new serve using the current promotion and the share_id associated with the path
                        # first, get the share associated with the referring path
                        @referring_share = Share.find_by_link_id(params[:path])
                        # now check to see if there's a valid cbcause and if so use it as the default cause
                        # Otherwise, use the referrer's default cause
                        if !cbcause.nil?
                            new_cause_id = cbcause.id
                        else
                            new_cause_id = @referring_share.serve.default_cause_id
                        end
                        # Note that the current cause will be set to the default cause before validation
                        # by the serve model.
                        # Now, create the new serve
                        @serve = Serve.create(promotion_id: @promotion.id, default_cause_id: new_cause_id, referring_share_id: @referring_share.id, user_id: user_id, serve_count: 1)

                    # If we made it to this point, the serve is valid (implied, as the not valid cases
                    # are handled above), so @old_serve exists, and the old serve may or may not be
                    # servable and/or the cause changed and/or the referrer changed.
                    # This section covers all of those possible combinations, and all of these will result
                    # in a new serve being created using some elements of the old serve.
                    else
                        # If the old promotion is not servable, use the new current promotion, otherwise use the
                        # promotion associated with the old serve
                        if !servable
                            # use current promotion
                            promotion_id = @promotion.id
                        else
                            # use promotion associated with old serve
                            promotion_id = @old_serve.promotion_id
                        end

                        if path_changed
                            # use the new path
                            referring_share_id = Share.find_by_link_id(params[:path]).id 
                        else
                            # use the path associated with the old serve
                            referring_share_id = @old_serve.referring_share_id
                        end

                        if cause_changed
                            # use the new cause as the default and current causes
                            default_cause_id = cbcause.id
                            current_cause_id = cbcause.id
                        else
                            # use the default and current causes associated with the old serve
                            default_cause_id = @old_serve.default_cause_id
                            current_cause_id = @old_serve.current_cause_id
                        end

                        # now create the new serve using the appropriate values
                        @serve = Serve.create(promotion_id: promotion_id, default_cause_id: default_cause_id, referring_share_id: referring_share_id, current_cause_id: current_cause_id, user_id: @old_serve.user_id, serve_count: 1)

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
                # inputs: merchant_id, session_id, callback, [path], [event_uid], [fg_uuid], [cause_type], [email]. Remember that the merchant_id is a uid

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

                # next, check to see if an email was passed in and if it is different than the email associated with the user in the current serve record.  If it is different, the @user[:user_changed] flag will be set to true and the @user[:user_id] variable will be set to the new user_id.  Otherwise, the flag will be set to false and the user_id variable will be set to the current value of the serve user_id.
                @user = Serve.user_changed?(@serve,params[:email])

                # next, update the permanent user cookie if the email that was passed in results in the creation of a new user or if the email that was passed in is different than the current value of the user email stored in the cookie.  Note that if the user updates email to "", the cookie will be updated with no email value as well. 
                if @user[:type] == "new" || cookies.signed[:user] != params[:email]
                    cookies.permanent.signed[:user] = params[:email]
                end

                # Using the cause_type, fg_uuid, and event_uid, get the new cause_id. When a serve is updated, values for cause_type ('single' or 'event'), fg_uuid (for single causes), and event_id (for events) may be included (all are optional).  If the cause_type is "single" and we have an actual value for fg_uuid, we use the fg_uuid to get (or create) the new cause_id. If the cause_type is event and there is an event_id submitted, we use the group_id associated with the event.  All other cases will result in a cause_id value of nil, meaning no new cause_id will be rendered.

                # first, create a cause_id variable and set to nil:

                cause_id = nil  

                # using the three inputs event_uid, fg_uuid, and cause_type, determine the correct cause if possible.  Here are the allowable cases that will result in a new cause_id:

                # 1.  cause_type is 'single' and there is a corresponding value for fg_uuid.  The get_cause_id method below will return an existing cause_id for the fg_uuid value if one exists, or will create a new single cause using the fg_uuid.  If fg_uuid is invalid or the firstgiving api call fails, something bad will probably happen here.
                if params[:cause_type] == "single" && !params[:fg_uuid].nil? && params[:fg_uuid] != ""
                    cause_id = Cause.get_cause_id(params[:fg_uuid])
                end

                # 2.  cause_type is 'event' and there is a corresponding value for event_uid.  IN this case, we first check to see if an event exists for this event_uid, and if it does we use the cause_id associated with the group that is associated with the event.  If the event_uid does not belong to a valid event, we leave the cause_id set to nil.
                if params[:cause_type] == "event" && !params[:event_uid].nil? && params[:event_uid] != ""
                    if !Event.find_by_uid(params[:event_uid]).nil?
                        # this will fail if an invalid event_uid was passed in, in which case the cause_id will not be updated.  
                        cause_id = Event.find_by_uid(params[:event_uid]).group.id
                    end
                end

                # Now check to see if the new cause is different from the current cause value for this serve.  Note that the new cause value can be nil.  If it is valid and different, set the @cause[:cause_changed] flag to true and the @cause[:cause_id] variable to the new cause id.  Otherwise, set the flag to false and the cause_id variable to the current cause id value.  Remember that the cause_id being passed in is an id but the cause being returned is an object.
                @cause = Serve.cause_changed?(@serve,cause_id)

                # if either the current cause or the user has changed, update the current serve. Also, since the purchase path associated with the old cause and email may have been used already, mark it as confirmed and create a new paths for this channel.
                if @cause[:cause_changed] or @user[:user_changed]
                    # first, mark the Purchase share for this serve as confirmed:
                    #Serve.post_to_channel(@serve,Channel.find_by_name('Email'))
                    Serve.post_to_channel(@serve,Channel.find_by_name('Purchase'))
                    # next, update the Serve attributes to reflect the new email (which means a new user), current_cause_id, or both
                    @serve.update_attributes(current_cause_id: @cause[:cause_id], user_id: @user[:user_id])
                    # finally, create a new share for the purchase channel
                    #Share.create_share(@serve,Channel.find_by_name('Email'))
                    Share.create_purchase_share(@serve,Channel.find_by_name('Purchase'),@cause[:cause_id])
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
                @causes = Cause.order('name').all
                render 'causes'
                return
            end

            def events
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
                @events = Event.where("end_date is ? or end_date > ?",nil,Time.now).order('event_date DESC').all
                render 'events'
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

                # next, check to ensure that the amount is numeric and does not include more than two digits after the decimal.
                # Remember that amount is actually a string
                if !Sale.is_a_number?(params[:amount])
                        render 'api/v1/api/errors/amount_non-numeric'
                        return
                    elsif !Sale.only_dollars_and_cents(params[:amount])
                        render 'api/v1/api/errors/amount_invalid'
                        return
                end

                # next, check to see if a valid share path (one that is associated with the current merchant) was passed in.  
                if Share.path_valid_for_this_merchant?(params[:path],merchant)
                    # the path is valid, so get the current share
                    share = Share.find_by_link_id(params[:path])
                else
                    render 'api/v1/api/errors/path_invalid'
                    return
                end

                # next, check to see if the serve associated with this share has either been shared or has a 
                # referrer.  If either is true, post this sale, but if neither is true we skip it.  
                if Serve.shared?(share.serve) || Serve.referred?(share.serve)
                    # This is a qualifying purchase.  Check to see if a record for this
                    # sale already exists.  If so, return the duplicate sale response.  Otherwise,
                    # create the sale record.
                    # First, create a new sale record using the current sale amount.  This is necessary
                    # in order to access the Money method of account_cents, which we need
                    # to use in the find_by statement that follows:
                    n = Sale.new(amount: params[:amount].to_f)
                    if Sale.find_by(share_id: share.id, amount_cents: n.amount_cents, transaction_id: params[:transaction_id]).nil?
                        Sale.create(share_id: share.id, amount: params[:amount].to_f, transaction_id: params[:transaction_id])
                        render 'success'
                        return
                    else
                        render 'api/v1/api/errors/duplicate_sale'
                        return
                    end
                else
                    render 'api/v1/api/errors/disqualified_sale'
                    return
                end
                
                # the following error should never be raised:
                render 'api/v1/api/errors/unrecognized_case'
                return
            end

            def content
                render 'content'
                return
            end

        end
    end
end