object @serve

node :purchase do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Purchase').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Purchase').id,false).first.link_id
	end
end	

node :facebook do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Facebook').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Facebook').id,false).first.link_id
	end
end	

#node :email do |serve|
#	if serve.promotion.channel_ids.include?(Channel.find_by_name('Email').id)
#		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Email').id,false).first.link_id
#	end
#end

node :linkedin do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Linkedin').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Linkedin').id,false).first.link_id
	end
end

node :pinterest do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Pinterest').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Pinterest').id,false).first.link_id
	end
end

node :twitter do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Twitter').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Twitter').id,false).first.link_id
	end
end

node :googleplus do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('GooglePlus').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('GooglePlus').id,false).first.link_id
	end
end