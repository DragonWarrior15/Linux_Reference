# basic sed command to substitute characters is
sed 's|pattern to match|pattern to replace the matched pattern|'
# alternatively, the following is also valid
sed 's/pattern to match/pattern to replace the matched pattern/'
# remember, there are three pairs of foward slashes
# always having quotes is not necessary, but it's a good practice
echo day | sed s/day/night/
echo day | sed 's/day/night/'
echo day | sed 's|day|night|'
# produces the output
night

# in case of single matches, & will also work
echo "123 abc" | sed 's/[0-9]*/& &/'
# here & & will basically repeat the pattern
# produces
123 123 abc

# \( is not necessary here as this is the extended regular expression using the -r flag
# \2 represents the second matched group, sed can remeber upto 9 matchings
# use () to specify a group
echo abcd edcba | sed -r 's|([a-z]+) ([a-z]+)|\2 text \1|'
# produces the output
edcba text abcd

# \1 needn't be used only in the replacement patter but also in the search pattern
# to check for say duplicacies
echo abcd abcd | sed -r 's|([a-z].*) \1|\1|'

# detect duplicate words in every line and print them
sed -rn '/([a-z]+) \1/p'


# by default, sed matches the first occurrence of the match in the line
# to extend this behaviour to apply the rule on every match, use the g flag at the end of the last delimiter
echo abcd abcd | sed -r 's|([a-z]+)|2&2|g'
# produces
2abcd2 2abcd2

# using nos after the last delimiter/with the flags
echo ab cd ef gh | sed -r 's|[a-z]+|{&}|2g'
# does the changes to only the second matching onwards
ab {cd} {ef} {gh}

echo $'ab cd ef gh\nij kl mn op' | sed -r 's|[a-z]+|{&}|3g'
# gives
ab cd {ef} {gh}
ij kl {mn} {op}

# suppose we want to modify th character at a particular position
echo abcdefghij | sed 's|.|&:|4'
# produces
efghij

# as opposed to
echo abcdefghij | sed 's|.|&:|4g'
# produces
abcd:e:f:g:h:i:j:

# the /p flag for printing
# with -n, p only prints the matching lines
# -n suppresses printing of lines
echo abcd | sed -n 's|a|b|'
# will produce no output for instance

echo $'abcd\nefgh' | sed -n 's|a|b|p'
# prints
bbcd
# as opposed to
# bbcd
# efgh

echo $'abcd\nefgh' | sed 's|a|b|p'
# produces
bbcd
bbcd
efgh
# so it basically prints the lines with matching expressions twice
# and others get printed once

# use the w keyword after the last delimiter in order to redirect the output
# to a file, keep a single space between e and the file name
echo $'1\n2\n3\n4' | sed -rn 's|^[0-9]*[02468]|&|w even'
# will write
2
4
# to the file
# this command can be useful for selectively splitting the file into multiple output streams

# case insensitive matching using the I flag
echo $'abc\nABc\ndef' | sed -r 's|abc|{&}|I'
# produces
{abc}
{ABc}
def

echo $'abc\nABc\ndef' | sed -nr 's|abc||I p'
# produces


def

# notice the space between I and p, this specifies that p is not a part of the modifier
# but a separate command to be executed after the match
echo $'abc\nABc\ndef' | sed -rn 's|abc|&|I p'
# produces
abc
ABc

# instead of using pipes to chain multiple sed commands,
# using -e before every command is preferred

# using the sed '/PATTERN/some_command'
# this command helps find he lines with the matching pattern and then
# only executes the command on those lines, note s is not needed here
# sed '/PATTERN/' will throw an error
sed '/PATTERN/ p' # simply prints the lines with the matching PATTERN
# sed '/PATTERN/ p' and sed '/PATTERN/p' are identical

# can use the -f flag to specify a file containinfg a list of sed commands
sed -f file_name < input > output

# a single complex sed command can be neatly formatted
# in a shell script
sed -e 's/a/A/g' \
    -e 's/e/E/g' \
    -e 's/i/I/g' \
    -e 's/o/O/g' \
    -e 's/u/U/g'  < old > new

# this also works
sed 's/a/A/g  \
s/e/E/g \
s/i/I/g \
s/o/O/g \
s/u/U/g'  <old >new


# the substitution command works well, but a limitation is that it works on all the lines in the input file, line by line.
# what if we want to somehow restrict the lines on which sed operates, say by the line number
# simply placae the line no before the sed expression
echo $'1\n2\n3\n4\n5' | sed -r '3 s|[0-9]+||'
# produces
1
2

4
5

# a range of line nos can also be specified here using comma
# can use the special symbol $ to mean the last line if it's
# not explicitly known
echo $'b\na\nc\na\ne' | sed -r '2,3 s|a|A|'
# produces
b
A
c
a
e

echo $'b\na\nc\na\ne' | sed -r '3,$ s|a|A|'
# produces
b
a
c
A
e

# patterns can also be used to select specific lines
# instead of putting a number before the expression as above, use a /PATTERN/
# to replace the first no on lines with a
echo $'a1\nb2\n3\na4\n5' | sed -r '/^a/ s|[0-9]+||'
# produces
a
b2
3
a
5

# a starting and ending pattern can also be specified
# between which the operation must be applied
# the patterns are both contained between two delimiters
# and are separated by a comma
# note that the patterns act as a switch which acts on the line, ie when the 
# pattern is found, the flag is switched on and acts on the line where the switch was found also
# when the end is found, the substitution acts on that line also
# so the switch is line oriented and not the 'word' oriented
echo $'a\n3start\nb\n8\nd\nend7d\ng\nh' | sed -r '/start/,/end/ s/[0-9]+/-/'
# produces
a
-start
b
-
d
end-d
g
h

# line number and pattern can also be combined together
echo $'a\n3start\n6\nb\n8\nd\nend7d\ng\nh' | sed '5,/end/ s/[a-z]/-/'
# produces
a
3start
6
b
8
-
-nd7d
g
h

echo $'a\n3start\n6\nb\n8\nd\nend7d\ng\nh' | sed '5,/end/ s/[a-z]/-/g'
# produces
a
3start
6
b
8
-
---7-
g
h

# can use two combinations of ranges to exclude the middle range
echo $'a\n3start\n6\nb\n8\nd\nend7d\ng\nh' | sed -e '1,/start/ s/[0-9]/-/' -e '/end/,$ s/[0-9]/-/'
# produces
a
-start
6
b
8
d
end-d
g
h


# the d command
# the d command can be used to delete lines
echo $'#\n#\na\nb\n\n\n\nd\n#\nr\nt\n#\n\n\n' | sed -e '/^#/ d' -e '/^$/ d'
# produces
a
b
d
r
t

echo $'#\n#\na\nb\n\n\n\nd\n#\nr\nt\n#\n\n\n' | sed -e '/^#/ d' -e '/^$/ d' -e 's/d/D/'
# produces
a
b
D
r
t


# the p command
# th p command can be used for printing
# unless the -n flag is present, using p will duplicate every line
# this command can be used to print only some restricted set of lines
echo $'1\n2\n3' | sed 'p'
# produces
1
1
2
2
3
3

echo $'1\n2\n3' | sed -n 'p'
# produces
1
2
3

echo $'1\n2\n3' | sed -n '1,2 p'
# produces, similar to head -2
1
2

# ! is the inversion operator and can be used to invert the
# command we are trying to perform
echo $'1\n2\n3\n4\n5' | sed -n '1,2 !p'
# produces
3
4
5

# some other use cases of d, p and i
echo $'1\n2\n3\n4\n5' | sed '1,2 p'
# prduces
1
1
2
2
3
4
5

echo $'1\n2\n3\n4\n5' | sed '1,2 !p'
# produces
1
2
3
3
4
4
5
5


# the q command
# the quit command exits sed after a certain condition in reached
# here a single condition like starting line or ending line must be given
# range of conditions cannot be given
echo $'1\n2\n3\n4\n5' | sed -e '2 !p' -e '4 q'
# produces
1
1
2
3
3
4
4

echo $'1\n2\n3\n4\n5' | sed -e '2,$ !p' -e '3 q'
# produces
1
1
2
3


# using the {} to group sed commands
# below is a self explanatory example for the same

#!/bin/sh
# This is a Bourne shell script that removes #-type comments
# between 'begin' and 'end' words.
sed -n '
    /begin/,/end/ {
         s/#.*//
         s/[ ^I]*$//
         /^$/ d
         p
    }
'
# this piece of code only operates between and including the lines conataining the begin and end pattern
# this replaces the lines beginning with #        s/#.*//
# this replaces lines containing a space or tab   s/[ ^I]*$//
# this deletes the empty lines                    /^$/ d
# this prints all the lines                       p

#!/bin/sh
sed '
    /begin/,/end/ !{
         s/#.*//
         s/[ ^I]*$//
         /^$/ d
         p
    }
'

# only difference from the previous example is that this inverts
# the pattern being searched


# operating on a pattern range except for the pattern
#!/bin/sh
sed '
    /begin/,/end/ {
        /begin/n # skip over the line that has "begin" on it
        s/old/new/
    }
'

# skipping the end doesn;t work the same way
# instead, we apply the pattern on every line not
# containing the pattern
#!/bin/sh
sed '
    /begin/,/end/ {
      /begin/n # skip over the line that has "begin" on it
      /end/ !{
        s/old/new/
      }  
    }
'


# the w command
# similar to the w flag, we also have the w command
# this will write to only those lines to the specified output file where
# the pattern is matching
sed -n '/^[0-9]*[02468]/ w even' <file
# only 10 files maximum can be opened simultaneously
# anything after a single space will be considered to be a part
# of the file name


# the a command
# this command can be used to insert a line after every line where
# the matching pattern has been found
echo $'a9b\ncde\n76r\nmki' | sed -r '/[0-9]/ a\add new line after every line with a number'
# produces
a9b
add new line after every line with a number
cde
76r
add new line after every line with a number
mki

echo $'a9b\ncde\n76r\nmki' | sed -r '/[0-9]/ a\
add new line after every line with a number'

# also works and produces the same result

# the i command
# this command inserts a line before every line which contains the matching pattern
# analogous to the a command, but it inserts before the line
# as apposed to the a command which inserts it afterwards
echo $'a9b\ncde\n76r\nmki' | sed -r '/[0-9]/ i\a new line'
# produces
a new line
a9b
cde
a new line
76r
mki


# the c command
# this command replaces every line with a matching pattern
# with a new supplied line
echo $'a9b\ncde\n76r\nmki' | sed -r '/[0-9]/ c\replace line'
# produces
replace line
cde
replace line
mki

echo $'a9b\ncde\n76r\nmki'
a9b
cde
76r
mki
# chaining these commands
echo $'a9b\ncde\n76r\nmki' | sed -e '/[0-9]/ i\before line' -e '/[0-9]/ a\after line' -e '/[0-9]/ c\replace line'
# produces
before line
replace line
after line
cde
before line
replace line
after line
mki

echo $'a9b\ncde\n76r\nmki' | sed -e '/[0-9]/ c\before line' -e '/[0-9]/ i\after line' -e '/[0-9]/ a\replace line'
# produces
before line
cde
before line
mki

# appending multiple lines
echo $'a9b\ncde\n76r\nmki' | sed '/[0-9]/ a\append line 1\nappend line 2'
# produces
a9b
append line 1
append line 2
cde
76r
append line 1
append line 2
mki


#!/bin/sh
# add a blank line after every line
sed '1,$ {
    a\

}'


# the = command
# this command can be used to print the line no of the
# line with the matching expression
sed -n '$=' file
# will print the no of lines in the file

