#ruby 2.2.1p85 (2015-02-26 revision 49769)
#energies files must contain time on left column, energy on right, separated by space
#change paths on line 73

#This opens the energies file, and splits it into an array at newlines
energies = Dir.glob('*energies.txt')
energies = energies.pop
text = File.open(energies).read
text = text.to_s
array = text.split("\n")

#creates time_arr which only holds time (same indices as main array)
time_arr =[]

#takes input data from energies.txt and pulls only the time at which energy occurs
#retains the whitespace char at the end of each time as well
array.each do |i|
    whitespace = i.index(" ")
    whitespace = whitespace.to_i
    time = i[0..whitespace]
    time_arr.push(time)
end

#this inserts a whitespace in front of each time allowing for grepping
time_arr.map! {|x| " " + x}

new_str_arr = []

def file_checker(file_path, time_arr, new_str_arr)
    puts " "
    count = 1
    to_del = []
    $file_path = file_path
    time_arr.each do |i|
        #this gives us the size of the project so a status can be seen with "count"
        size = time_arr.size
        puts "Grepping time #{count} of #{size} in #{file_path}"
        #opens an .out file, pulls data, and splits into array on newline
        grepped = File.open(file_path).read.to_s
        grepped_array = grepped.split("\n")
        count = count + 1
        
        grepped_array.each do |e|    
            #arrays look roughly like this
            #NSTEP =  5180000   TIME(PS) =    5215.000  TEMP(K) =   309.60  PRESS =     0.0
            #Etot   =        43.0108  EKtot   =        43.3737  EPtot      =        -0.3629
            #BOND   =        17.4371  ANGLE   =        13.2322  DIHED      =        32.3214
            #1-4 NB =        17.1057  1-4 EEL =        72.6723  VDWAALS    =        -9.9034
            #EELEC  =      -143.2282  EHBOND  =         0.0000  RESTRAINT  =         0.0000
            if e.include? i
                puts "Item found: #{i}"
                #if item found in .out file, a path is made for it, substituting the current
                #.out filename for .mdcrd. For example, if found in dyn1.out, the corresponding
                #.mdcrd path is dyn1.mdcrd
                mdcrd_path = file_path.gsub 'out', 'mdcrd'
                #grabs the step associated with the time
                #unclear on how the code works
                #example line:
                #NSTEP =  2765000   TIME(PS) =  202800.000  TEMP(K) =   411.39  PRESS =     0.0
                #time = 202800.000
                #associated step is 2765000
                clean_str = e.scan(/\d+/).first
                math_str = clean_str.to_i
                #Divides the step by 500 to account for ... why?
                math_str = math_str/500
                #creates a string for output
                new_str = "trajin #{mdcrd_path} #{math_str} #{math_str}"
                new_str_arr.push(new_str)
                #inserts the time used here into a new array for maintenance/speed 
                to_del.push(i)
            end
        end
    end
    #this removes a "used" time so it is not searched for after instance is found
    to_del.each do |f|
        time_arr.delete(f)
    end
        to_del = []
end

#iterates through the array of new strings
def answer(new_str_arr)
    new_str_arr.each do |b|
    end
end

#runs the program
Dir.glob('*out') do |file_path|
  results = file_checker(file_path, time_arr, new_str_arr)
end

#grabs file prefix and uses it to name files
stub = $file_path.split("_")[0]
#writes to new file
new = File.new("ptraj.in", "w")
#puts trajin strings from the file_checker and answer methods into the file
new.puts answer(new_str_arr)
new.puts 
new.puts "trajout #{stub}.pdb pdb"
new.close
