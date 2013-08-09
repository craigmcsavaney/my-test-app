object @serve

node :pur_path do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Purchase').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Purchase').id,false).first.link_id
	end
end	

node :fb_path do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Facebook').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Facebook').id,false).first.link_id
	end
end	

node :em_path do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Email').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Email').id,false).first.link_id
	end
end

node :li_path do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Linkedin').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Linkedin').id,false).first.link_id
	end
end

node :pin_path do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Pinterest').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Pinterest').id,false).first.link_id
	end
end

node :tw_path do |serve|
	if serve.promotion.channel_ids.include?(Channel.find_by_name('Twitter').id)
		serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Twitter').id,false).first.link_id
	end
end