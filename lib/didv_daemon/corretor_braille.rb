require 'yaml'

bar = {}
foo = YAML::load_file 'braille.yml'
foo.each do |k,v|
  if v.is_a? String
    if v.size == 6
      bar[k] = v.chars.reverse.join
    else
      bar[k] = v
    end
  else
    if v.is_a? Hash
      puts v
      bar[k] = {}
      v.each do |vk,vv|
        if vv.size == 6
          bar[k][vk] = vv.chars.reverse.join
        else
          bar[k][vk] = vv
        end
      end
    end
  end
end
File.open('braille_new.yml','w') do |f|
  f.puts bar.to_yaml
end
