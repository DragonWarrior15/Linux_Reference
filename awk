# The essential premise of awk is
# pattern {action}
# and awk works on a line by line fashion, so the action is executed
# whenever a pattern match is found

# Two other specific patterns are specified through the keywords
# BEGIN and END
# BEGIN { print "START" }
#       { print         }
# END   { print "STOP"  }
# BEGIN is performed before any line is read
# END is performed after the last line is read

# a basic awk command to print the 3rd and the 10th fields in
# the ll command
ll | sed '1 d' | awk 'BEGIN{print "File\tOwner"}{print $10,"\t",$3}END{print "-Done-"}'
# line 1 is deleted as it tells the total bytes

# counting the no of files owned by every user
ls -l | sed '1 d' | awk '{print $3}' | sort | uniq -c

# to sort in the rerverse order of no of files
# sort -n does numeric sorting, -r does reverse sorting
ls -l | sed '1 d' | awk '{print $3}' | sort | uniq -c | sort -nr

# awk has ++x and --x operators too which are similar in
# behaviour to C++
# ++x increments the variable and then uses it's value
# x++ first uses the variable and then increments it
# in a similar fashion, += etc al work
# conditional operators like ==, >= etc are also valid
# regex matching can be achieved through ~ sign
# !~ is the opposite and checks if the regex doesn't match
# place the regex inside two forward slashes
# example $0 ~ /:/

# basic code blocks that can be used in awk
# there are only a limited no of them
if ( conditional ) statement [ else statement ]
while ( conditional ) statement
for ( expression ; conditional ; expression ) statement
for ( variable in array ) statement
break
continue
{ [ statement ] ...}
variable=expression
print [ expression-list ] [ > expression ]
printf format [ , expression-list ] [ > expression ]
next 
exit


# basic code to print squares of a few first nos
#!/bin/awk -f
BEGIN {
# Print the squares from 1 to 10 the first way

    i=1;
    while (i <= 10) {
        printf "The square of ", i, " is ", i*i;
        i = i+1;
    }

# do it again, using more concise code

    for (i=1; i <= 10; i++) {
        printf "The square of ", i, " is ", i*i;
    }

# now end
exit;
}

# a basic use case of awk to find avg words per file in a folder
# the following prints the tab separated table consisting of wno of words
# and the file name, remove the last line which is the total word count
wc -c * | sed '$ d'
# the following uses the outpu
wc -c * | sed '$ d' | awk 'BEGIN{lines=0;total=0;}{lines+=$1;total+=1;}END{print lines/total}'
# a more elaborate command using conditionals
wc -c * | sed '$ d' | awk 'BEGIN{lines=0;total=0;}{lines+=$1;total+=1;}END{print "total lines ",lines;print "total files ",total;\
if(lines>0){print "avg is ",lines/total}else{print "avg is 0"}}'


# awk has built in and positional arguments
# $1, $2 etc refers to nth field and are pre defined variables
# $0 refers to the entire line
# print $0 si similar to print $1, $2 and so on till the last column
# we can create new variables too as done in an earlier example

# -F flag with awk can be used to change the delimiter
# the default is a whitespace
echo $'col1|col2|col3\n1|a|4\n2|b|5' | awk -F"|" '{print $2}'
# produces
col2
a
b
# the field separator can be accessed in a shell script through the FS variable
# the value can be dynamically changed as per requirement on each line
# depending on conditionals

# similar to above, awk's output is separated through OFS
# or the output field separator, this can also be dynamically
# modified


