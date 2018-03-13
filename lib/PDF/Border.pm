use v6;

use PDF::COS::Tie::Hash;

#| /Type /Border

role PDF::Border
    does PDF::COS::Tie::Hash {

    # set [PDF 1.7 TABLE 8.17 Entries in a border style dictionary]
    use PDF::COS::Tie;
    use PDF::COS::Name;

    my subset BorderType of PDF::COS::Name where 'Border';
    has BorderType $.Type is entry;     #| (Optional) The type of PDF object that this dictionary describes; if present, must be Border for a border style dictionary.

    has Numeric $.W is entry(:alias<width>);           #| (Optional) The border width in points. If this value is 0, no border is drawn. Default value: 1.

    my subset BorderStyle of PDF::COS::Name where 'S' | 'D' | 'B' | 'I' | 'U';
    has BorderStyle $.S is entry(:alias<style>);       #| (Optional) The border style:
    #| S(Solid) A solid rectangle surrounding the annotation.
    #| D(Dashed) A dashed rectangle surrounding the annotation. The dash pattern is specified by the D entry (see below).
    #| B(Beveled) A simulated embossed rectangle that appears to be raised above the surface of the page.
    #| I(Inset) A simulated engraved rectangle that appears to be recessed below the surface of the page.
    #| U(Underline) A single line along the bottom of the annotation rectangle.
    #| Other border styles may be defined in the future. Default value: S.

    has UInt @.D is entry(:alias<dash-pattern>);              #| (Optional) A dash array defining a pattern of dashes and gaps to be used in drawing a dashed border (border style D above). The dash array is specified in the same format as in the line dash pattern parameter of the graphics state (see “Line Dash Pattern” on page 217). The dash phase is not specified and is assumed to be 0. For example, a Dentry of [ 3 2 ] specifies a border drawn with 3-point dashes alternating with 2-point gaps. Default value: [ 3 ].

}
