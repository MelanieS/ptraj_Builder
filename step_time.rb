#ruby 2.0.0p451 (2014-02-24 revision 45167)
#energies files must contain time on left column, energy on right, separated by space
#change paths on lines 5, 51-60, 69

text = File.open('dyn_energies.txt').read
text = text.to_s
array = text.split("\n")

#creates time_arr which only holds time (same indices as main array)
$time_arr =[]

array.each do |i|
  white = i.index(" ")
  white = white.to_i
  time_num = white - 1
  time_num = time_num.to_i
  time = i[0..time_num]
  $time_arr.push(time)
end

#puts blank space before and after time to clean up "grep"
$time_arr.map! {|x| " " + x + " "}
$cleaning_time = $time_arr

$grep_arr = []

def file_checker(file_path)
    $grep_arr.push(file_path)
  puts " "
  count = 1
  $time_arr.each do |i|
    size = $time_arr.size
    puts "Grepping time #{count} of #{size} in #{file_path}"
    grepped = File.open(file_path).read
    grepped = grepped.to_s
    grepped_array = grepped.split("\n")
    count = count + 1
    
    grepped_array.each do |e|
      if e.include? i
        length = e.length
        clean_str = e[0..43]
        $grep_arr.push(clean_str)
      end
    end
  end
  return $grep_arr
end

#This is really repetitive. Must find another way.
results = file_checker('files/dyn1.out')
results = file_checker('files/dyn2.out')
results = file_checker('files/dyn3.out')
results = file_checker('files/dyn4.out')
results = file_checker('files/dyn5.out')
results = file_checker('files/dyn6.out')
results = file_checker('files/dyn7.out')
results = file_checker('files/dyn8.out')
results = file_checker('files/dyn9.out')
results = file_checker('files/dyn10.out')

def answer()
  $grep_arr.each do |b|
  end
end

puts answer

#writes to new file
new = File.new("time_step_wy_12_60_dyn.txt", "w")
new.puts answer
new.close
