package Buffer::Transactional::Buffer;
use Moose::Role;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

requires 'put';
requires 'as_string';

sub subsume {
    my ($self, $buffer) = @_;
    (blessed $buffer && $buffer->does('Buffer::Transactional::Buffer'))
        || confess "You can only subsume other buffers";
    $self->put( $buffer->as_string );
}

no Moose::Role; 1;

__END__

=pod

=head1 NAME

Buffer::Transactional::Buffer - A Moosey solution to this problem

=head1 SYNOPSIS

  use Buffer::Transactional::Buffer;

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
