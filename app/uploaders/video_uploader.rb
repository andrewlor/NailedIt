class VideoUploader

	# side effects: uploads video file to s3 or stores in tmp/videos
	# returns s3 object key or location of video
	def self.store_video(file)
		if !file; return nil end
		obj_key = "videos/#{SecureRandom.urlsafe_base64}.mp4"
		
		temp_location = Rails.root.join('tmp', obj_key)

		# check if videos dir exists
		dir_location = Rails.root.join('tmp', 'videos')
		if !File.directory?(dir_location)
			FileUtils.mkdir(dir_location)
		end

		temp_string = file.read.encode(Encoding::ASCII_8BIT)
		File.binwrite(temp_location, temp_string)

		# upload to s3
		if ENV['UPLOAD_TO_S3'].present?
			s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
			obj = s3.bucket(ENV['S3_BUCKET_NAME']).object(obj_key)
			obj.upload_file(temp_location, content_type: 'video/H264')
			FileUtils.rm(temp_location)
		end

		return obj_key
	end

	# side effects: none
	# returns video string
	def self.read_video(obj_key)
		if ENV['UPLOAD_TO_S3'].present?
			return "https://s3-us-west-2.amazonaws.com/nailedit/#{obj_key}"
		else
			return ENV['LOCAL_ASSEST_SERVER'] + obj_key
		end
	end
end