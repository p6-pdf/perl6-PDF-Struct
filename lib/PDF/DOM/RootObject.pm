use v6;

role PDF::DOM::RootObject {

    use PDF::Storage::Serializer;
    use PDF::Reader;
    use PDF::Writer;

    #| open an input file
    method open(Str $file-name) {
        my $reader = PDF::Reader.new;
        $reader.open($file-name);
	my Hash $dict = $reader.trailer;
        my $obj = self.new( :$dict, :$reader );
	$obj;
    }

    #| perform an incremental save back to the opened input file
    method update(:$compress) {
        my $reader = $.reader
            // die "pdf is not associated with an input source";

        die "pdf reader is defunct"
            if $reader.defunct;
 
        # todo we should be able to leave the input file open and append to it
        my Numeric $offset = $reader.input.chars + 1;

        my $serializer = PDF::Storage::Serializer.new;
	my Hash $trailer = self.content.value;
        my Hash $body = $serializer.body( $reader, :updates, :$compress, :$trailer );
        my Pair $root = $reader.root.ind-ref;
        my Int $prev = $body<trailer><dict><Prev>.value;
        my $writer = PDF::Writer.new( :$root, :$offset, :$prev );
        my Str $new-body = "\n" ~ $writer.write( :$body );
        $reader.input.?close;
        $reader.input = Any;
        $reader.defunct = True;
        $reader.file-name.IO.open(:a).write( $new-body.encode('latin-1') );
    }

    #| use the reader when available.
    multi method save-as(Str $file-name! where {$.reader.defined && !$.reader.defunct},
                         Numeric :$version?,
                         Bool :$rebuild = False,
                         :$compress,
        ) {
        $.reader.recompress( :$compress ) if $compress.defined;
        $.reader.version = $version if $version.defined;
        $.reader.save-as($file-name, :$rebuild,)
    }

    #| do a full save to the named file
    multi method save-as(Str $file-name!,
                         Numeric :$version=1.3,
                         :$type='PDF',     #| e.g. 'PDF', 'FDF;
                         :$compress = False,
        ) {

	my $serializer = PDF::Storage::Serializer.new;
	my Hash $trailer = self.content.value;
	my PDF::Object $root-object = self.Root;
	$serializer.save-as( $file-name, :$root-object, :$type, :$version, :$compress, :$trailer);
    }
}
