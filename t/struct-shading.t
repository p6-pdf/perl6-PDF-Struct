use v6;
use Test;

plan 8;

use PDF::Type;
use PDF::Storage::IndObj;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;
use PDF::Grammar::Test :is-json-equiv;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
5 0 obj << % Shading dictionary
  /ShadingType 3
  /ColorSpace /DeviceCMYK
  /Coords [ 0.0 0.0 0.096 0.0 0.0 1.0 00]  % Concentric circles
  /Function 10 0 R
  /Extend [ true true ]
>> endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my %ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%ast);
is $ind-obj.obj-num, 5, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $shading-obj = $ind-obj.object;
isa-ok $shading-obj, ::('PDF::Type')::('Shading::Radial');
is $shading-obj.ShadingType, 3, '$.ShadingType accessor';
is $shading-obj.type, 'Shading', '$.type accessor';
is $shading-obj.subtype, 'Radial', '$.subtype accessor';
is $shading-obj.ColorSpace, 'DeviceCMYK', '$.ColorSpace accessor';
is-json-equiv $ind-obj.ast, %ast, 'ast regeneration';