module JS
  module RubyFeature
    # Convert a require feature name to a Ruby source filename, appending the
    # .rb extension when it is omitted.
    def self.filename_from(feature)
      feature = feature.to_s
      feature.end_with?(".rb") ? feature : "#{feature}.rb"
    end
  end
end
