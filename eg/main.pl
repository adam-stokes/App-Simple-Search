#!/usr/bin/env perl

use Mojo::Base -base;
use FindBin;
use lib "$FindBin::Bin/../lib";
use App::Simple::Search::Store;
use Mojo::JSON qw(encode_json);
use Data::Dumper::Concise;

my @quotes = (
      "The greatest glory in living lies not in never falling, but in rising every time we fall.",
      "The way to get started is to quit talking and begin doing.",
      "Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma which is living with the results of other people's thinking.",
      "If life were predictable it would cease to be life, and be without flavor.",
      "If you look at what you have in life, you'll always have more. If you look at what you don't have in life, you'll never have enough.",
      "If you set your goals ridiculously high and it's a failure, you will fail above everyone else's success.",
      "Life is what happens when you're busy making other plans."
    );

my $store = App::Simple::Search::Store->new;
foreach my $quote (@quotes) {
    $store->add($quote);
}

my $query = $ENV{SEARCHTERM};
my $matches = $store->search($query);

print("\n## OUTPUT\n");
foreach my $record (@{$matches->records}) {
    printf("(id => %s, text => %s, terms => %s)\n", $record->id, $record->text, join ", ", $record->terms);
}

print("\n## JSON\n");

my %json_output = ();
foreach my $record (@{$matches->records}) {
    $json_output{$record->id} = {'text' => $record->text, 'terms' => join ",", $record->terms};
}
print(encode_json(\%json_output));

print("\n\n## OUTPUT BY RANK\n");
$matches = $store->search_by_rank($query);
foreach my $key (keys %{$matches}) {
    my $terms = join ", ", $matches->{$key}->{record}->terms;
    printf("(id => %s, text => %s, terms => %s, score => %d)\n", $matches->{$key}->{record}->id, $matches->{$key}->{record}->text, $terms, $matches->{$key}->{score});
}
