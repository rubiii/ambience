module Ambience
  module CoreExt
    module Hash

      # Returns a new Hash with self and +other_hash+ merged recursively.
      # Implementation from ActiveSupport::CoreExtensions::Hash::DeepMerge.
      def deep_merge(other_hash)
        merge(other_hash) do |key, oldval, newval|
          oldval = oldval.to_hash if oldval.respond_to? :to_hash
          newval = newval.to_hash if newval.respond_to? :to_hash
          oldval.class.to_s == "Hash" && newval.class.to_s == "Hash" ? oldval.deep_merge(newval) : newval
        end
      end

      # Returns a new Hash with self and +other_hash+ merged recursively. Modifies the receiver in place.
      # Implementation from ActiveSupport::CoreExtensions::Hash::DeepMerge.
      def deep_merge!(other_hash)
        replace deep_merge(other_hash)
      end

    end
  end
end

Hash.send :include, Ambience::CoreExt::Hash
