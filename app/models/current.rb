class Current < ActiveRecord::Base

  def self.get_current_promotion(check_date,merchant)
    if !merchant.promotions.exists?
      # This merchant has no promotions at all
      @message = "The selected merchant has no promotions"
      return {promotion: nil, message: @message}
    end
    # Check to see if this merchant has any enabled promotions
    if merchant.promotions.where(disabled: [false,nil]).none?
      # All of this merchants promotions are disabled
      @message = "All of this merchant's promotions are currently disabled"
      return {promotion: nil, message: @message}
    end
    # Add only promotions to the @promotions collection that have channels selected
    # and are not disabled
    @promotions = merchant.promotions
    @promotion1 = []
    @promotions.each do |promotion|
      @promotion1 << promotion if (!promotion.channel_ids.blank? and !promotion.disabled)
    end
    @promotions = @promotion1
    # If there are no promotions with channels assigned, exit
    if @promotions.count == 0
      @message = "There are no promotions for the selected merchant with channels assigned"
      return {promotion: nil, message: @message}
    end
    # We know that there are one more promotions with channels assigned, so check for valid dates
    # Now get the array of all promotions valid on the check_date
    @promotion1 = [] 
    @promotions.each do |promotion|
      @promotion1 << promotion if ((promotion.start_date < check_date) and ((promotion.end_date.nil?) or (promotion.end_date > check_date)))
    end
    @promotions = @promotion1
    # Now check to see if there are zero or only one date-wise valid promotions and return
    if @promotions.count == 1
      # Return the current promotion for this date
        @message = "This is the current promotion because it is the only active promotion"
        return {promotion: @promotions.first, message: @message} 
      elsif @promotions.count == 0
        # This merchant has no valid current promotions for this date
        # Return appropriate message
        @message = "The selected merchant has no active promotions on this date"
        return {promotion: nil, message: @message}
    end
    # We know there are multiple date-wise valid promotions
    # Now order them based on priority and keep only those with the highest priority
    # Remember that priority can't be nill but zeros are allowed and are the default
    @promotion1 = []
    @maxpriority = 0
    @promotions.each do |promotion|
      if promotion.priority > @maxpriority
        @maxpriority = promotion.priority
      end
    end
    @promotions.each do |promotion|
      @promotion1 << promotion if promotion.priority >= @maxpriority
    end
    @promotions = @promotion1    
    # Now check to see if there is only one current promotions remaining and return
    if @promotions.count == 1
      # Return the current promotion for this date
      @message = "This is the current promotion because it has the highest priority"
      return {promotion: @promotions.first, message: @message}
    end
    # We know there are still multiple valid promotions of equal priority
    # Put all remaining promotions with non-nil end_dates in a separate 
    # collection for further evaluation.
    @nonnils = [] # Array for all promotions with non-nil end_dates
    @promotions.each do |promotion|
      if !promotion.end_date.nil?
        @nonnils << promotion 
      end
    end
    # Check to see if there are any non-nil end_date promotions
    if @nonnils.count == 1
        # If there's only one, return it as the current promotion for this date
        @message = "This is the current promotion because it has the closest end date"
        return {promotion: @nonnils.first, message: @message}
      elsif @nonnils.count > 1
      # This means that there is more than one promotion with a non-nil end_date.
      # Find all such promotions that share the closest non-nil end_date.
        @closest = [] # Array for all promotions with the closest end_date
        @end_date = @nonnils.first.end_date  # seed @end_date with the first value
        @nonnils.each do |promotion|
          if promotion.end_date < @end_date
            @end_date = promotion.end_date
          end
        end
        @nonnils.each do |promotion|
          @closest << promotion if promotion.end_date == @end_date
        end
        # Now check to see how many promotions share the closest end_date
        # If there is only one, it is the current promotion.  If there is more than one,
        # copy @closest to @promotions and continue with the next check.
        if @closest.count == 1
            @message = "This is the current promotion because it has the closest end date"
            return {promotion: @closest.first, message: @message}
          else
            # There must be more than one promotion that shares closest end_date
            @promotions = @closest
        end
        # If there were no @nonnils, processing will continue using the original
        # @promotions array, which contains only promotions with nil end_dates.
        # If there were @nonnils and there was more than one that shared the 
        # closest end_date, processing will continue on those promotions, which
        # are now in the @promotions collection
    end 
    # We know there must still be multiple valid promotions
    # Now check to see if a single one can be selected based on start_date order
    # Find all such promotions that share the closest non-nil end_date.
    @most_recent = [] # Array for all promotions with the most recent start_date
    @start_date = @promotions.first.start_date  # seed @start_date with the first value
    @promotions.each do |promotion|
      if promotion.start_date > @start_date
        @start_date = promotion.start_date
      end
    end
    @promotions.each do |promotion|
      @most_recent << promotion if promotion.start_date == @start_date
    end
    # Now check to see how many promotions share the most recent start_date
    # If there is only one, it is the current promotion.  If there is more than one,
    # copy @most_recent to @promotions and continue with the next check.
    if @most_recent.count == 1
        @message = "This is the current promotion because it has the most recent start date"
        return {promotion: @most_recent.first, message: @message}
      else
        # There must be more than one promotion that shares the most recent end_date
        @promotions = @most_recent
    end
    # We know there must still be multiple valid promotions with the same priority, end_dates, and
    # start_dates.  Find the one with the most recent updated_at date and select it.
    @most_recent = [] # Array for all promotions with the most recent updated_at datetime
    @updated_at = @promotions.first.updated_at  # seed @updated_at with the first value
    @promotions.each do |promotion|
      if promotion.updated_at > @updated_at
        @updated_at = promotion.updated_at
      end
    end
    @promotions.each do |promotion|
      @most_recent << promotion if promotion.updated_at == @updated_at
    end
    # Finally, return the promotion with the most recent updated_at datetime
    @message = "This is the current promotion because it was updated most recently"
    return {promotion: @most_recent.first, message: @message}
  end

end
