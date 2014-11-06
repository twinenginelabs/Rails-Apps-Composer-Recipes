class String
  def possessive
    suffix = if self.downcase == 'it'
      "s"
    elsif self.downcase == 'who'
      'se'
    elsif self.end_with?('s')
      "'"
    else
      "'s"
    end
    self + suffix
  end
end