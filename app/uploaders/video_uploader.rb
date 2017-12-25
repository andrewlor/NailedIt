class VideoUploader

	# side effects: uploads video file to s3 or stores in tmp/videos
	# returns s3 object key or location of video
	def self.store_video(attempt_id, file_contents)
		file_name = 'attempt' + attempt_id.to_s + '.webm'
		temp_location = Rails.root.join('tmp', 'videos', file_name)
		file = File.new(temp_location, 'w')
		file.puts(file_contents)
		file.close

		if Rails.env.production? # prod
			# upload to s3
			s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
			obj = s3.bucket(ENV['S3_BUCKET_NAME']).object('videos/' + file_name)
			obj.upload_file(temp_location)
			FileUtils.rm(temp_location)
			return obj.key
		else
			return temp_location
		end
	end

	# side effects: none
	# returns video string
	def self.read_video(attempt_id)
		file_name = 'attempt' + attempt_id.to_s + '.webm'
		temp_location = Rails.root.join('tmp', 'videos', file_name)

		if Rails.env.production?
			File.open(temp_location, 'wb') do |file|
				s3 = Aws::S3::Client.new
	  		reap = s3.get_object({ bucket: ENV['S3_BUCKET_NAME'], key: Attempt.find(attempt_id).video }, target: file)
			end
		end

		file = File.open(temp_location, 'r')
		video_string = file.read

		if Rails.env.production?
			FileUtils.rm(temp_location)
		end

		return video_string
	end
end