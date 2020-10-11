package App::Simple::Search::RecordResult;

use Mojo::Base -base;

has 'records' => sub {
    my $self = shift;
    return [];
};

sub count {
    my $self = shift;
    return scalar @{$self->records};
}

sub add {
    my ($self, $record) = @_;
    push @{$self->records}, $record;
}

1;
