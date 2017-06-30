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
