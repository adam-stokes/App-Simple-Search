package App::Simple::Search::Store;

use Mojo::Base -base;
use App::Simple::Search::Record;
use App::Simple::Search::RecordResult;
use App::Simple::Search::TextTools;
use Lingua::TFIDF;
use Lingua::TFIDF::WordSegmenter::SplitBySpace;
use Data::Dumper::Concise;

has 'record_results' => sub {
    my $self = shift;
    return App::Simple::Search::RecordResult->new;
};

sub add {
    my ($self, $text) = @_;
    my $record = App::Simple::Search::Record->new(original_text => $text);
    $self->record_results->add($record);
}

sub search {
    my ($self, $term) = @_;
    my $text_tool = App::Simple::Search::TextTools->new();

    $term = $text_tool->normalize($term);
    my $matches = App::Simple::Search::RecordResult->new;
    foreach my $record (@{$self->record_results->records}) {
        if (grep(/^$term$/, $record->terms)) {
            $matches->add($record);
        }
    }
    return $matches;
}

sub search_by_rank {
    my ($self, $term) = @_;
    my $matches = $self->search($term);
    my $records = [];
    foreach my $record (@{$matches->records}) {
        push @{$records}, $record;
    }
    my $tf_idf_calc = Lingua::TFIDF->new(
        word_segmenter => Lingua::TFIDF::WordSegmenter::SplitBySpace->new);
    my $scores = ();
    foreach my $record (@{$records}) {
        my $tf = $tf_idf_calc->tf(document => $record->text);
        $scores->{$record->id} = {score => $tf->{$term}, record => $record};
    }

    return $scores;
}

1;
