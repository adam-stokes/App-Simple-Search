package App::Simple::Search::TextTools;

use Mojo::Base -base;
use Data::Dumper::Concise;

sub normalize {
    my ($self, $text) = @_;
    $text = lc $text;
    $text =~ s/[[:punct:]]//g;
    return $text;
}

1;
