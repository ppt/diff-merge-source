# diff org comment > diff-org-comm
# ruby merge-comment.rb org comment diff-org-comm

# require 'pry'
# binding.pry

def split_number(s)
  if s =~ /(\d+),(\d+)/
    [$1.to_i,$2.to_i]
  else
    [s.to_i,s.to_i]
  end
end

def merge_comment(diff,original,update)
  result = []
  org_index = 1
  for cmd in diff
    # fill gap
    if cmd[:org][0] > 0
      result = result + original[(org_index-1)...(cmd[:org][0]-1)]
    end
    if cmd[:cmd] == 'a'
      if cmd[:org][0] == 0
        result.push "##{'+'*20}\n" + update[cmd[:new][0]-1..cmd[:new][1]-1].join('') + "##{'+'*20}\n" + original[cmd[:org][0]]
      else
        result.push original[cmd[:org][0]-1]
        result.push "##{'+'*20}\n" + update[cmd[:new][0]-1..cmd[:new][1]-1].join('') + "##{'+'*20}\n" + original[cmd[:org][0]]
      end
    end
    if cmd[:org][0] == 0
      org_index += 1
    else
      org_index = cmd[:org][1] + 2
    end
  end
  result
end

org_file = open(ARGV[0]) { |f| f.readlines }
comment_file = open(ARGV[1]) { |f| f.readlines }
diff_file = open(ARGV[2]) { |f| f.readlines }

diff_cmd_array = diff_file.grep(/^\d/).collect { |line|
  line =~ /([0-9,]+)([acd])([0-9,]+)/
  {:cmd => $2, :org => split_number($1), :new => split_number($3)}
}

result = merge_comment diff_cmd_array,org_file,comment_file

puts org_file.length,result.length
for l in result
  puts l
  puts '_'*50
end