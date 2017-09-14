PHOTO_STORAGE = YAML.load_file(Rails.root.join('config','s3.yml'))[::Rails.env].symbolize_keys!
