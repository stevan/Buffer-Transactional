package Buffer::Transactional::Buffer::Array;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

with 'Buffer::Transactional::Buffer';

has '_buffer' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub { [] },
);

sub put {
    my $self = shift;
    push @{ $self->_buffer } => @_;
}

sub subsume {
    my ($self, $buffer) = @_;
    $self->put( @{ $buffer->_buffer } );
}

sub as_string {
    my $self = shift;
    join "" => @{ $self->_buffer }
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Buffer::Transactional::Buffer::Array - A Moosey solution to this problem

=head1 SYNOPSIS

  use Buffer::Transactional::Buffer::Array;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
