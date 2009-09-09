package Buffer::Transactional::StringBuffer;
use Moose;
use Moose::Util::TypeConstraints;

use IO::String;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

class_type 'IO::String';

with 'Buffer::Transactional::Buffer';

has '_buffer' => (
    is      => 'ro',
    isa     => 'IO::String',
    lazy    => 1,
    default => sub { IO::String->new },
);

sub put {
    my $self = shift;
    $self->_buffer->print( @_ );
}

sub subsume {
    my ($self, $buffer) = @_;
    (blessed $buffer && $buffer->isa( __PACKAGE__ ))
        || confess "You can only subsume other buffers";
    $self->put( $buffer->as_string );
}

sub as_string {
    my $self = shift;
    ${ $self->_buffer->string_ref }
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Buffer::Transactional::StringBuffer - A Moosey solution to this problem

=head1 SYNOPSIS

  use Buffer::Transactional::StringBuffer;

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
