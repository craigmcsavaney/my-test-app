task :remove_shares => :environment do
	a = 0
	Share.all.each do |s|
		if s.serves.count == 0 && !s.serve.viewed && s.sales.count == 0 && s.updated_at < Time.now-86400
			a = a + 1
			s.destroy
		end
	end
	puts "Share records destroyed:"
	puts a
end

task :remove_serves => :environment do
	b = 0
	Serve.all.each do |t|
		if !t.viewed && t.sales.count == 0 && t.shares.count == 0 && t.updated_at < Time.now-86400
			b = b + 1
			t.destroy
		end
	end
	puts "Serve records destroyed:"
	puts b
end

task :remove_share_count => :environment do
	a = 0
	Share.all.each do |s|
		if s.serves.count == 0 && !s.serve.viewed && s.sales.count == 0 && s.updated_at < Time.now-86400
			a = a + 1
		end
	end
	puts "Share records to be destroyed:"
	puts a
end

task :remove_serve_count => :environment do
	b = 0
	Serve.all.each do |t|
		if !t.viewed && t.sales.count == 0 && t.shares.count == 0 && t.updated_at < Time.now-86400
			b = b + 1
		end
	end
	puts "Serve records to be destroyed:"
	puts b
end