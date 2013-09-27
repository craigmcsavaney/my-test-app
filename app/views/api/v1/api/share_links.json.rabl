object @serve

node do |serve|
	if serve.promotion.channels.where("name = ? and active = ?", 'Purchase', true).exists?
		{ :purchase => serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Purchase').id,false).first.link_id }
	end
end	

node do |serve|
	if serve.promotion.channels.where("name = ? and active = ?", 'Facebook', true).exists?
		{ :facebook => serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Facebook').id,false).first.link_id }
	end
end	

#node do |serve|
#	if serve.promotion.channels.where("name = ? and active = ?", 'Email', true).exists?
#		{ :email => serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Email').id,false).first.link_id }
#	end
#end

node do |serve|
	if serve.promotion.channels.where("name = ? and active = ?", 'Linkedin', true).exists?
		{ :linkedin => serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Linkedin').id,false).first.link_id }
	end
end

node do |serve|
	if serve.promotion.channels.where("name = ? and active = ?", 'Pinterest', true).exists?
		{ :pinterest => serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Pinterest').id,false).first.link_id }
	end
end

node do |serve|
	if serve.promotion.channels.where("name = ? and active = ?", 'Twitter', true).exists?
		{ :twitter => serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('Twitter').id,false).first.link_id }
	end
end

node do |serve|
	if serve.promotion.channels.where("name = ? and active = ?", 'GooglePlus', true).exists?
		{ :googleplus  => serve.shares.where("channel_id = ? and confirmed = ?",Channel.find_by_name('GooglePlus').id,false).first.link_id }
	end
end