object @serve
attributes :id, :promotion_id

node :promotion do |serve|
	Promotion.find(serve.promotion_id)
end

#node :promotion_name do |serve|
#	Promotion.find(serve.promotion_id)
#end

#node :promotion do |serve|
# { :promotion => partial("promotions/show", :object => Promotion.find(serve.#promotion_id)) }
#end
