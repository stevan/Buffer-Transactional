package Buffer::Transactional::Buffer::Lazy;
use Moose;
use MooseX::AttributeHelpers;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

with 'Buffer::Transactional::Buffer';

has '_buffer' => (
    metaclass => 'Collection::Array',
    is        => 'rw',
    isa       => 'ArrayRef[CodeRef]',
    lazy      => 1,
    default   => sub { [] },
    provides  => {
        'push' => '_add_to_buffer',
    }
);

sub put {
    my $self = shift;
    $self->_add_to_buffer( @_ );
}

sub subsume {
    my ($self, $buffer) = @_;
    $self->put(sub { map { $_->() } @{ $buffer->_buffer } });
}

sub as_string {
    my $self = shift;
    join "" => map { $_->() } @{ $self->_buffer }
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Buffer::Transactional::Buffer::Lazy - A lazy buffer using code refs

=head1 DESCRIPTION

This buffer accepts CodeRefs instead of strings and will hold onto
them only executing them at the very last moment when the top
level transaction is commited.

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
