package Data::Format::Pretty;

use 5.010;
use strict;
use warnings;

use Module::Load;
use Module::Loaded;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(format_pretty);

# VERSION

sub format_pretty {
    my ($data, $opts0) = @_;

    my %opts = $opts0 ? %$opts0 : ();
    my $module = $opts{module};
    if (!$module) {
        if ($ENV{GATEWAY_INTERFACE} || $ENV{PLACK_ENV}) {
            $module = 'HTML';
        } else {
            $module = 'Console';
        }
    }
    delete $opts{module};

    my $module_full = "Data::Format::Pretty::" . $module;
    load $module_full unless is_loaded $module_full;
    my $sub = \&{$module_full . "::format_pretty"};

    $sub->($data, \%opts);
}

1;
# ABSTRACT: Pretty-print data structure
__END__

=head1 SYNOPSIS

In your program:

 use Data::Format::Pretty qw(format_pretty);
 print format_pretty($data, 'Console', {interactive=>1});


=head1 DESCRIPTION

Data::Format::Pretty is an extremely simple framework for pretty-printing data
structure. Its focus is on "prettiness" and automatic detection of appropriate
format to use.

To use this framework, install one or more Data::Format::Pretty::* formatter
modules, and call format_pretty($data, $formatter, $opts). Data::Format::Pretty
will delegate formatting to the formatting module, passing $data as well as
format-specific options ($opts).

To develop a formatter, look at one of the formatter module (like
L<Data::Format::Pretty::JSON>) for example. You only need to specify one
function, C<format_pretty>.


=head1 FUNCTIONS

=head2 format_pretty($data, \%opts) => STR

Send $data to formatter module (one of Data::Format::Pretty::* modules) and
return the result. Options:

=over 4

=item * module => STR

Select the formatter module. It will be prefixed with "Data::Format::Pretty::".

Currently if unspecified the default is 'Console', or 'HTML' if CGI/PSGI/plackup
environment is detected. In the future, more sophisticated detection logic will
be used.

=back

The rest of the options will be passed to the formatter module.


=head1 SEE ALSO

One of Data::Format::Pretty::* formatter, like L<Data::Format::Pretty::Console>,
L<Data::Format::Pretty::HTML>, L<Data::Format::Pretty::JSON>,
L<Data::Format::Pretty::YAML>.

=cut
