use v6;
use PDF::FontStream;
use PDF::COS::Stream;
class PDF::FontFile
    does PDF::FontStream
    is PDF::COS::Stream {

    # use ISO_32000::Table_127-Additional_entries_in_an_embedded_font_stream_dictionary;
    # also does ISO_32000::Table_127-Additional_entries_in_an_embedded_font_stream_dictionary;

    use PDF::COS::Name;
    use PDF::COS::Tie;
    use PDF::Class::Defs :FontFileType;

    has PDF::COS::Name $.Subtype is entry(:required) where FontFileType;
}
