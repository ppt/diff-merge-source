# diff org new > diff-org-new
# ruby merge-old-new.rb org new diff-org-new2

# require 'pry'
# binding.pry

# original = ARGV[0], comment = ARGV[1], diff result = ARGV[2]
org_file = open(ARGV[0]) { |f| f.readlines }
new_file = open(ARGV[1]) { |f| f.readlines }
diff_file = open(ARGV[2]) { |f| f.readlines }

# create 2 int elements array from 9,9 or 9
def split_number(s)
  if s =~ /(\d+),(\d+)/
    [$1.to_i,$2.to_i]
  else
    [s.to_i,s.to_i]
  end
end

diff_cmd_array = diff_file.grep(/^\d/).collect { |line|
  line =~ /([0-9,]+)([acd])([0-9,]+)/
  {:cmd => $2, :org => split_number($1), :new => split_number($3)}
}

result = []
org_idx = 1

for cmd in diff_cmd_array
  # fill gap
  if cmd[:org][0] > 0
    result = result + org_file[(org_idx-1)...(cmd[:org][0]-1)]
  end
  if cmd[:cmd] == 'c'
    result.push '#'+'-+'*10
    result = result + org_file[cmd[:org][0]-1..cmd[:org][1]-1].collect { |line| "# #{line}"}
    result = result + new_file[cmd[:new][0]-1..cmd[:new][1]-1]
    result.push '#'+'-+'*10
  elsif cmd[:cmd] == 'd'
    result.push '#'+'-'*20
    result = result + org_file[cmd[:org][0]-1..cmd[:org][1]-1].collect { |line| "# #{line}"}
    result.push '#'+'-'*20
  elsif cmd[:cmd] == 'a'
    if cmd[:org][0] > 0
      result.push org_file[cmd[:org][0]-1]
    end
    result.push '+'*20
    result = result + new_file[cmd[:new][0]-1..cmd[:new][1]-1]
    result.push '#'+'+'*20
  end
  org_idx = cmd[:org][1] + 1
end

# fill what left in org
if org_idx <= org_file.length
  result = result + org_file[org_idx-1..-1]
end

puts result
