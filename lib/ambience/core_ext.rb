class Hash

  # Returns a new Hash with all keys converted to Symbols.
  def recursively_symbolize_keys
    inject({}) do |hash, (key, value)|
      hash[key.to_sym] = case value
        when Hash then value.recursively_symbolize_keys
        else value
      end
      hash
    end
  end

  # Converts this Hash to a new Hash with all keys converted to Symbols.
  def recursively_symbolize_keys!
    replace recursively_symbolize_keys
  end

  # Returns a new hash with self and other_hash merged recursively.
  # Implementation from ActiveSupport.
  def deep_merge(other_hash)
    merge(other_hash) do |key, oldval, newval|
      oldval = oldval.to_hash if oldval.respond_to? :to_hash
      newval = newval.to_hash if newval.respond_to? :to_hash
      oldval.class.to_s == "Hash" && newval.class.to_s == "Hash" ? oldval.deep_merge(newval) : newval
    end
  end

  # Returns a new hash with self and other_hash merged recursively. Modifies the receiver in place.
  # Implementation from ActiveSupport.
  def deep_merge!(other_hash)
    replace deep_merge(other_hash)
  end

end
