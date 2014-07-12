namespace :cleanup do
	desc "Destroy obsoleted share records"
	task :shares => :environment do
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

	desc "Destroy obsoleted serve records"
	task :serves => :environment do
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

	desc "Destroy unused single cause records"
	task :singles => :environment do
		a = 0
		Single.all.each do |single|
			if single.users.count == 0 && single.groups.count == 0 && single.promotions.count == 0 && single.shares.count == 0 && single.donations.count == 0 && Serve.where("default_cause_id = ? or current_cause_id = ?",single.id,single.id).count == 0
				a = a + 1
				single.destroy
			end
		end
		puts "Single cause records destroyed:"
		puts a
	end

	desc "Count obsoleted share records that can be destroyed"
	task :share_count => :environment do
		a = 0
		Share.all.each do |s|
			if s.serves.count == 0 && s.sales.count == 0 && ((!s.serve.viewed && s.updated_at < Time.now-86400) || (!Serve.shared?(s.serve) && s.updated_at < Date.today-31))
				a = a + 1
			end
		end
		puts "Share records to be destroyed:"
		puts a
	end

	desc "Count obsoleted serve records that can be destroyed"
	task :serve_count => :environment do
		b = 0
		Serve.all.each do |serve|
			if serve.sales.count == 0 && serve.shares.count == 0 && ((!serve.viewed && serve.updated_at < Time.now-86400) || (!Serve.shared(serve) && serve.updated_at < Date.today-31))
				b = b + 1
			end
		end
		puts "Serve records to be destroyed:"
		puts b
	end

	desc "Count unused single cause records that can be destroyed"
	task :single_count => :environment do
		a = 0
		Single.all.each do |single|
			if single.users.count == 0 && single.groups.count == 0 && single.promotions.count == 0 && single.shares.count == 0 && single.donations.count == 0 && Serve.where("default_cause_id = ? or current_cause_id = ?",single.id,single.id).count == 0
				a = a + 1
			end
		end
		puts "Cause records to be destroyed:"
		puts a
	end

	desc "Destroy all obsoleted records"
	task :all => [:shares, :serves]
end