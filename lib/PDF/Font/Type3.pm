use v6;
use PDF::Font;
use PDF::Content::Resourced;

class PDF::Font::Type3
    is PDF::Font
    does PDF::Content::Resourced {

    use PDF::DAO::Tie;
    use PDF::DAO::Dict;
    use PDF::DAO::Name;
    use PDF::DAO::Stream;

    # see [PDF 1.7 TABLE 5.9 Entries in a Type 3 font dictionary]
    has PDF::DAO::Name $.Name is entry;                 #| (Required in PDF 1.0; optional otherwise) See Table 5.8 on page 413
    has Numeric @.FontBBox is entry(:required, :len(4));         #| (Required) A rectangle (see Section 3.8.4, “Rectangles”) expressed in the glyph coordinate system, specifying the font bounding box.
    has Numeric @.FontMatrix is entry(:required, :len(6));       #| (Required) An array of six numbers specifying the font matrix, mapping glyph space to text space
    has PDF::DAO::Stream %.CharProcs is entry(:required);        #| (Required) A dictionary in which each key is a character name and the value associated with that key is a content stream that constructs and paints the glyph for that character.

    use PDF::Encoding
    my subset NameOrEncoding of Any where PDF::DAO::Name | PDF::Encodiing;
    has NameOrEncoding $.Encoding is entry(:required); #| (Required) An encoding dictionary whose Differences array specifies the complete character encoding for this font

    has UInt $.FirstChar is entry(:required);          #| (Required) The first character code defined in the font’s Widths array

    has UInt $.LastChar is entry(:required);           #| (Required) The last character code defined in the font’s Widths array

    has Numeric @.Widths is entry(:required);          #| (Required) An array of (LastChar − FirstChar + 1) widths, each element being the glyph width for the character code that equals FirstChar plus the array index.

    use PDF::FontDescriptor;
    has PDF::FontDescriptor $.FontDescriptor is entry(:indirect);     #| (Required in Tagged PDF documents; must be an indirect reference) A font descriptor describing the font’s default metrics other than its glyph widths

    use PDF::Resources;
    has PDF::Resources $.Resources is entry;   #| (Optional but strongly recommended; PDF 1.2) A list of the named resources, such as fonts and images, required by the glyph descriptions in this font

    use PDF::CMap;
    has PDF::CMap $.ToUnicode is entry;        #| (Optional; PDF 1.2) A stream containing a CMap file that maps character codes to Unicode values
}
