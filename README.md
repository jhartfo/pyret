# pyret
This repository contains various Pyret programs. It includes new libraries, student facing starter files, and independent projects I ave completed.

**CHS-starter-files**: 
starter files that I have created for my classroom. These are not intended to be shared/used within the greater bootstrap community.

CHS-working-file:
students facing files I activey used in the class

bootstrap-algebra: starter files and libraries created to extend the standard Bootstrap: Algebra offereings
bootstrap-calculus: largely for myself and to help with statistics. Currently, the is not intended to be a robust treatment of Calculus for external consumption.

bootstrap-statistics:
Long suffereing project to create a bootstrap-style curriculum for HS statistics. Includes pyret libraries and starter files along with other elements for the curriculum

game files: complete and working games for demonstration purposes
pyret-art: various art projects I have worked on, includes flags and the US-flag 6 ways.

@ifnotpathway{p1,p2,...}{text}
Reusable text
When using @if…​ and @ifnot…​ pairs of conditional text, we may often find that the controlled text nevertheless contains commonalities that may be too tedious and/or error-prone to repeat. In such cases use the @define directive to save reusable text in a dynamic directive, and use call the directive (rather than repeat the reusable text) whenever it needs to be used. E.g.,

@define{savedtext}{... long piece of text ...}
@ifslide{... slide-specific text containing @savedtext ...}
@ifnoslide{.. non-slide text, also containing @savedtext ...}
Adding custom CSS classes
Some standard CSS classes to emphasize certain regions of text.

Add the class .physics-table to a table attribute to generate a single-arg function table, e.g., one that maps miles driven to cost.

You can add your own CSS classes or IDs. Classes are specified with an initial dot and IDs with an initial #. Note that at most one ID is meaningful, although any number of classes may be specified. A combination of classes and ID are simply strung together, e.g.,

[.class1.class2.class3#onlyid]
The above works for blocks. Use @span{classes and id}{text} to enclose CSS classes and/or an ID around arbitrary (i.e., in-line) text. @spans may be nested. @span’s first argument of classes and ID is specified in the same way as for blocks, without the brackets.
