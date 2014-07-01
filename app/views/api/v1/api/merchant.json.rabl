object @merchant
attributes :name
attributes :uid => :id

node do |merchant|
	if !merchant.auto_button.nil?
		{ :auto_button => merchant.auto_button.name }
	else
		{ :auto_button => "" }
	end
end
