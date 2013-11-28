class Article < ActiveRecord::Base
  has_many :comments

  has_many :taggings
  has_many :tags, through: :taggings

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }

  def tag_list
    self.tags.collect do |tag|
      tag.name
    end.join(", ")
  end

  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
    # we split the string, and then trim each and every element
    # and collect those updated items
    # The String#split(",") will create the array with elements
    # that have the extra spaces as before, then the Array#collect
    # will take each element of that array and send it into the
    # following block where the string is named s and the
    # String#strip and String#downcase methods are called on it.
    # The downcase method is to make sure that "ruby" and "Ruby"
    # don’t end up as different tags. This line should give you
    # back ["programming", "ruby", "rails"].
    # Lastly, we want to make sure that each and every tag in the
    # list is unique. Array#uniq allows us to remove duplicate items
    # from an array.
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
    # go through each of those tag_names and find or create a tag
    # with that name
    self.tags = new_or_found_tags
    # collect up these new or found new tags and then assign them to our article
  end
end
