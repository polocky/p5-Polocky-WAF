use inc::Module::Install;
name 'Polocky-WAF';
all_from 'lib/Polocky-WAF.pm';

# requires '';

tests 't/*.t';

test_requires 'Test::More';
auto_include;
WriteAll;
