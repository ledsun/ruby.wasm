module JS
  module RubyFeature
    def self.filename_from(feature)
      feature = feature.to_s
      feature.end_with?(".rb") ? feature : "#{feature}.rb"
    end
  end
end
