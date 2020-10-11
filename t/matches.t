use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";

diag("Testing");

my @quotes = (
      "The greatest glory in living lies not in never falling, but in rising every time we fall.",
      "The way to get started is to quit talking and begin doing.",
      "Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma which is living with the results of other people's thinking.",
      "If life were predictable it would cease to be life, and be without flavor.",
      "If you look at what you have in life, you'll always have more. If you look at what you don't have in life, you'll never have enough.",
      "If you set your goals ridiculously high and it's a failure, you will fail above everyone else's success.",
      "Life is what happens when you're busy making other plans."
    );


use_ok("App::Simple::Search::Record");
use_ok("App::Simple::Search::RecordResult");
use_ok("App::Simple::Search::Store");
use_ok("App::Simple::Search::TextTools");

my $text_tool = App::Simple::Search::TextTools->new;
my $string = "The broken window shatters across the ground!";
my $expected = "the broken window shatters across the ground";
ok($text_tool->normalize($string) eq $expected, "String is normalized properly");

$string = "There is that one person and only that one person";
my $record = App::Simple::Search::Record->new(original_text => $string);
ok($record->term_frequency->{person} eq 2, "Correct term frequency for 'person'");
ok($record->term_frequency->{there} eq 1, "Correct term frequency for 'there'");

my $store = App::Simple::Search::Store->new;
foreach my $quote (@quotes) {
    $store->add($quote);
}
ok($store->search("GrEaTeSt")->count eq 1, "Found 1 result of 'GrEaTeSt'");
ok($store->search("life")->count eq 4, "Found 1 result of 'life'");
ok($store->search("life!")->count eq 4, "Found 1 result of 'life!'");
ok($store->search(",life,")->count eq 4, "Found 1 result of ',life,'");


done_testing;
