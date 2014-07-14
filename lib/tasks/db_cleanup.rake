namespace :cleanup do
	desc "Count obsoleted share and serve records that can be destroyed"
	task :shares_and_serves_count => :environment do
		# IMPORTANT: never delete share records from a serve without deleting the serve.
		# If the serve lives in a cookie and the API sees it's valid and tries to retreive
		# it without the necessary shares, the api response will fail.
		# To prevent this, all the selection logic is applied at the serve level, and
		# when the serve is destroyed all of its dependents will be destroyed as
		# per the association in the Serve model.
		# selection logic:
		# 1. never delete a serve that has any sales
		# 2. never delete a serve that was referred by another serve
		# 3. delete a serve that has referral serves
		# 4. never delete a serve that is less than 24 hours old
		# for serves that meet 1 - 4 above (no sales, not a referral, no referrals, >24 hours old)
		# 5. serves that haven't been either viewed or shared can be destroyed
		# 6. serves that have gone more than 30 days since an update can be destroyed
		# UPDATE: #6 temporarily removed, so no serves that have been viewed or shared
		# will be destroyed.  Need to capture summary data on views and shares at the promotion
		# level before destroying viewed and / or shared serves and their shares.
		a = 0
		b = 0
		Serve.all.each do |serve|
			#if serve.updated_at < Time.now-86400 && serve.sales.count == 0 && !Serve.referred?(serve) && serve.referral_count == 0 && ((!serve.viewed && !Serve.shared?(serve)) || serve.updated_at < Date.today-31)
			if serve.updated_at < Time.now-86400 && serve.sales.count == 0 && !Serve.referred?(serve) && serve.referral_count == 0 && !serve.viewed && !Serve.shared?(serve)
				a = a + 1
				b = b + serve.shares.count
			end
		end
		puts "Serve records to be destroyed:"
		puts a
		puts "Share records to be destroyed:"
		puts b
	end

	desc "Destroy obsoleted share and serve records"
	task :shares_and_serves => :environment do
		# IMPORTANT: never delete share records from a serve without deleting the serve.
		# If the serve lives in a cookie and the API sees it's valid and tries to retreive
		# it without the necessary shares, the api response will fail.
		# To prevent this, all the selection logic is applied at the serve level, and
		# when the serve is destroyed all of its dependents will be destroyed as
		# per the association in the Serve model.
		# selection logic:
		# 1. never delete a serve that has any sales
		# 2. never delete a serve that was referred by another serve
		# 3. delete a serve that has referral serves
		# 4. never delete a serve that is less than 24 hours old
		# for serves that meet 1 - 4 above (no sales, not a referral, no referrals, >24 hours old)
		# 5. serves that haven't been either viewed or shared can be destroyed
		# 6. serves that have gone more than 30 days since an update can be destroyed
		# UPDATE: #6 temporarily removed, so no serves that have been viewed or shared
		# will be destroyed.  Need to capture summary data on views and shares at the promotion
		# level before destroying viewed and / or shared serves and their shares.
		a = 0
		b = 0
		Serve.all.each do |serve|
			#if serve.updated_at < Time.now-86400 && serve.sales.count == 0 && !Serve.referred?(serve) && serve.referral_count == 0 && ((!serve.viewed && !Serve.shared?(serve)) || serve.updated_at < Date.today-31)
			if serve.updated_at < Time.now-86400 && serve.sales.count == 0 && !Serve.referred?(serve) && serve.referral_count == 0 && !serve.viewed && !Serve.shared?(serve)
				a = a + 1
				b = b + serve.shares.count
				serve.destroy
			end
		end
		puts "Serve records to be destroyed:"
		puts a
		puts "Share records to be destroyed:"
		puts b
	end

	desc "Count unused single cause records that can be destroyed"
	task :singles_count => :environment do
		a = 0
		Single.all.each do |single|
			if single.users.count == 0 && single.groups.count == 0 && single.promotions.count == 0 && single.shares.count == 0 && single.donations.count == 0 && Serve.where("default_cause_id = ? or current_cause_id = ?",single.id,single.id).count == 0
				a = a + 1
			end
		end
		puts "Cause records to be destroyed:"
		puts a
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

	desc "Destroy all obsoleted records"
	task :all => [:shares_and_serves, :singles]

	# desc "Destroy obsoleted share records"
	# task :shares => :environment do
	# 	a = 0
	# 	Share.all.each do |share|
	# 		if share.serves.count == 0 && share.sales.count == 0 && ((!share.serve.viewed && share.updated_at < Time.now-86400) || (!Serve.shared?(share.serve) && share.updated_at < Date.today-31))
	# 			a = a + 1
	# 			share.destroy
	# 		end
	# 	end
	# 	puts "Share records destroyed:"
	# 	puts a
	# end

	# desc "Destroy obsoleted serve records"
	# task :serves => :environment do
	# 	b = 0
	# 	Serve.all.each do |serve|
	# 		if serve.sales.count == 0 && serve.shares.count == 0 && !Serve.referred?(serve) && ((!serve.viewed && serve.updated_at < Time.now-86400) || (!Serve.shared?(serve) && serve.updated_at < Date.today-31))
	# 			b = b + 1
	# 			serve.destroy
	# 		end
	# 	end
	# 	puts "Serve records destroyed:"
	# 	puts b
	# end


	# desc "Count obsoleted share records that can be destroyed"
	# task :shares_count => :environment do
	# 	a = 0
	# 	Share.all.each do |share|
	# 		if share.serves.count == 0 && share.sales.count == 0 && ((!share.serve.viewed && share.updated_at < Time.now-86400) || (!Serve.shared?(share.serve) && share.updated_at < Date.today-31))
	# 			a = a + 1
	# 		end
	# 	end
	# 	puts "Share records to be destroyed:"
	# 	puts a
	# end

	# desc "Count obsoleted serve records that can be destroyed"
	# task :serves_count => :environment do
	# 	b = 0
	# 	Serve.all.each do |serve|
	# 		if serve.sales.count == 0 && serve.shares.count == 0 && !Serve.referred?(serve) && ((!serve.viewed && serve.updated_at < Time.now-86400) || (!Serve.shared?(serve) && serve.updated_at < Date.today-31))
	# 			b = b + 1
	# 		end
	# 	end
	# 	puts "Serve records to be destroyed:"
	# 	puts b
	# end

end