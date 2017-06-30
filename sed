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
