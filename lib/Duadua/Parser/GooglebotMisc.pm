package Duadua::Parser::GooglebotMisc;
use strict;
use warnings;
use Duadua::Util;

sub try {
    my ($class, $d) = @_;

    if ($d->ua eq 'google-speakr') {
        return {
            name   => 'google-speakr',
            is_bot => 1,
        };
    }

    return unless index($d->ua, 'Google') > -1;

    if ( index($d->ua, 'Googlebot-Image') == 0 ) {
        my $h = {
            name   => 'Googlebot-Image',
            is_bot => 1,
        };

        if ($d->opt('version')) {
            my ($version) = ($d->ua =~ m!^Googlebot-Image/([\d.]+)!);
            version($h, $version) if $version;
        }

        return $h;
    }

    if ( index($d->ua, 'Googlebot-News') == 0 ) {
        return {
            name   => 'Googlebot-News',
            is_bot => 1,
        };
    }

    if ( index($d->ua, 'Googlebot-Video') == 0 ) {
        my $h = {
            name   => 'Googlebot-Video',
            is_bot => 1,
        };

        if ($d->opt('version')) {
            my ($version) = ($d->ua =~ m!^Googlebot-Video/([\d.]+)!);
            version($h, $version) if $version;
        }

        return $h;
    }

    if ( index($d->ua, 'AdsBot-Google-Mobile-Apps') > -1 ) {
        return {
            name   => 'AdsBot-Google-Mobile-Apps',
            is_bot => 1,
        };
    }

    if ( index($d->ua, 'AdsBot-Google') > -1 ) {
        return {
            name   => 'AdsBot-Google',
            is_bot => 1,
        };
    }

    if ( index($d->ua, 'FeedFetcher-Google') == 0 ) {
        return {
            name   => 'FeedFetcher-Google',
            is_bot => 1,
        };
    }
}

1;

__END__

=head1 METHODS

=head2 try

Do parse


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 LICENSE

C<Duadua> is free software; you can redistribute it and/or modify it under the terms of the Artistic License 2.0. (Note that, unlike the Artistic License 1.0, version 2.0 is GPL compatible by itself, hence there is no benefit to having an Artistic 2.0 / GPL disjunction.) See the file LICENSE for details.

=cut