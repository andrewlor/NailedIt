class VideoUploader
	# side effects: uploads video file to s3 or stores in tmp/videos
	# returns s3 object key or location of video
	def self.store_video(file_contents)
		if file_contents.empty?; return nil end
		obj_key = "videos/#{SecureRandom.urlsafe_base64}.webm"
		
		temp_location = Rails.root.join('tmp', obj_key)

		# check if videos dir exists
		dir_location = Rails.root.join('tmp', 'videos')
		if !File.directory?(dir_location)
			FileUtils.mkdir(dir_location)
		end

		file = File.new(temp_location, 'w')
		file.puts(file_contents)
		file.close

		# upload to s3
		if Rails.env.production?
			s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
			obj = s3.bucket(ENV['S3_BUCKET_NAME']).object(obj_key)
			obj.upload_file(temp_location)
			FileUtils.rm(temp_location)
		end

		return obj_key
	end

	# side effects: none
	# returns video string
	def self.read_video(obj_key)
		temp_location = Rails.root.join('tmp', obj_key)

		if Rails.env.production?
			File.open(temp_location, 'wb') do |file|
				s3 = Aws::S3::Client.new
	  		s3.get_object({ bucket: ENV['S3_BUCKET_NAME'], key: obj_key }, target: file)
			end
		end

		file = File.open(temp_location, 'r')
		video_string = file.read

		if Rails.env.production?; FileUtils.rm(temp_location) end

		return video_string
	end
end