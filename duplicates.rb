def delete_recursive(path)
  files = {}
  Dir.new(path).entries.each do |entry_name|
    next if ['.', '..'].include? entry_name
    if File.directory?(path + entry_name + '/')
      delete_recursive(path + entry_name + '/')
    else
      name = File.basename(entry_name, '.*').downcase
      name.gsub!('._', '')
      files[name] ||= []
      files[name] << { path: path + entry_name, time: File.ctime(path + entry_name) }
    end
  end
  selected = files.select { |_, values| values.size > 1 }
                  .map { |_, values| values.sort { |a, b| a[:time] - b[:time] }.drop(1) }
  remove_files selected
end

def remove_files(selected)
  permited = ['.cue', '.txt']
  selected.each do |fs|
    fs.each do |f|
      unless permited.include? File.extname(f[:path])
        p "Deleted: #{File.basename(f[:path])}"
        File.delete(f[:path])
      end
    end
  end
end

delete_recursive '/media/HDD/Denis/music/'
