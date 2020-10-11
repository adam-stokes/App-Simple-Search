package App::Simple::Search::Record;

use Mojo::Base -base;
use UUID 'uuid';
use App::Simple::Search::TextTools;

has 'id' => sub {
    my $self = shift;
    return uuid();
};

has 'original_text';
has 'text' => sub {
    my $self = shift;
    my $text_tool = App::Simple::Search::TextTools->new;
    return $text_tool->normalize($self->original_text);
};

sub terms {
    my $self = shift;
    return split / /, $self->text;
}

sub term_frequency {
    my $self = shift;
    my %count;
    foreach ($self->terms) {
        $count{$_}++;
    }
    return \%count;
}

1;
