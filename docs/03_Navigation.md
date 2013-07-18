# Navigation

Navigation menu on the left is built from directories and mardown file names in
the directory with documentation. For example, given the following directory
structure:

    docs
    |-- 01_Quick_Start.md
    |-- 02_Advanced_Usage.md
    |-- 02_Advanced_Usage
    |    |-- 01_Installation.md
    |    |-- 02_Configuration.md
    |    +-- 03_Customization.md
    +-- 03_Contributing
         |-- 01_First_Section
         |    |-- 01_Sub_Section.md
         |    |-- 02_Second_Sub_Section.md
         |    +-- 03_Last_Sub_Section.md
         +-- 02_Second_Section.md

Would become a navigation menu with each section mapping directly to a file or
directory in documentation tree:

    Quick Start
    Advanced Usage
        Installation
        Configuration
        Customization
    Contributing
        First Section
            Sub Section
            Second Sub Section
            Last Sub Section
        Second Section

Advanced usage section will have the contents of the appropriate markdown file
as well as subsections with contents of markdown files stored in the directory
with the same name.
