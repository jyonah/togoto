module Dataset

  def self.make_names(names_array)
    names_arr = []
    names_array.each do |fullname|
      names = fullname.split(' ')
      this_person = {}
      this_person[:first_name] = names.shift
      this_person[:middle_name] = nil
      this_person[:last_name] = names.delete_at(-1)
      if names.length > 0
        this_person[:middle_name] = names.join(' ')
      end #if
      names_arr << this_person
    end #do
    names_arr
  end #method

end #module
