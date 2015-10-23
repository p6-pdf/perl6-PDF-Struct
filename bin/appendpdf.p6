#!/usr/bin/perl -w
use v6;
use PDF::DOM;
use PDF::DAO::Type::Encrypt :PermissionsFlag;

sub MAIN(*@files, Str :$save-as, Bool :$forms)  {

    my $pdf = PDF::DOM.open: @files.shift;

    die "nothing to do"
	unless @files;

    for @files -> $in-file {
	my $in-pdf = PDF::DOM.open: $in-file;
	$in-pdf.Root<Acroform>:delete
	    if $forms;

	die "PDF forbids copy: $in-file"
	    unless $in-pdf.permitted( PermissionsFlag::Copy );

	for 1 .. $in-pdf.page-count -> $page-no {
	    $pdf.add-page( $in-pdf.page($page-no) )
	}
    }

    die "PDF forbids modification\n"
	unless $pdf.permitted( PermissionsFlag::Modify );

    if $save-as {
	# save to a new file
	$pdf.save-as: $save-as;
    }
    else {
	# inplace incremental update of first file
	$pdf.update;
    }
}

=begin pod

=head1 NAME

appendpdf.p6 - Append one PDF to another

=head1 SYNOPSIS

 appendpdf.p6 [options] --save-as=output.pdf file1.pdf file2.pdf

 Options:
   --prepend        prepend the document instead of appending it
   --forms          wipe all forms and annotations from the PDF

=head1 DESCRIPTION

Copy the contents of C<file2.pdf> to the end of C<file1.pdf>.  This may
break complex PDFs which include forms, so the C<--forms> option is
provided to eliminate those elements from the resulting PDF.

=head1 SEE ALSO

CAM::PDF

F<deletepdfpage.pl>

=head1 AUTHOR

See L<CAM::PDF>

=cut

=end pod
